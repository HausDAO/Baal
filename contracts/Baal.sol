// SPDX-License-Identifier: UNLICENSED
/*
███   ██   ██   █     
█  █  █ █  █ █  █     
█ ▀ ▄ █▄▄█ █▄▄█ █     
█  ▄▀ █  █ █  █ ███▄  
███      █    █     ▀ 
        █    █        
       ▀    ▀*/
pragma solidity >=0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/interfaces/IERC3156.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Votes.sol";

/// @notice Interface for Baal {memberAction} that adjusts membership shares & loot.
interface IShaman {
    function memberAction(address member, uint96 loot, uint96 shares) external payable returns (uint96 lootOut, uint96 sharesOut);
}

/// @title Baal ;_;
/// @notice Guild contract inspired by Moloch DAO framework.
contract Baal is IERC3156FlashLender, ERC20Votes {
    bool    public lootPaused; /*tracks transferability of loot economic weight - amendable through period[2] proposal*/
    bool    public sharesPaused; /*tracks transferability of erc20 shares - amendable through period[2] proposal*/
    uint32  public gracePeriod; /*time delay after proposal voting period for processing*/
    uint32  public minVotingPeriod; /*minimum period for voting in seconds - amendable through period[2] proposal*/
    uint32  public maxVotingPeriod; /*maximum period for voting in seconds - amendable through period[2] proposal*/
    uint96  public totalLoot; /*counter for total loot economic weight held by accounts*/  
    uint256 public proposalCount; /*counter for total `proposals` submitted*/
    uint256 public flashFeeNumerator; /*tracks fee for {flashLoan} - 1 = 0.0001%*/
    uint256 constant MAX_GUILD_TOKEN_COUNT = 400; /*maximum number of whitelisted tokens*/
    
    address[] guildTokens; /*array list of erc20 tokens approved on summoning or by whitelist[3] `proposals` for {ragequit} claims*/
    address[] memberList; /*array list of `members` summoned or added by membership[1] `proposals`*/
 
    mapping(address => bool)     public shamans; /*maps contracts approved in whitelist[3] proposals for {memberAction} that mints or burns shares*/
    mapping(address => Member)   public members; /*maps `members` accounts to struct details*/
    mapping(uint256 => Proposal) public proposals; /*maps `proposalCount` to struct details*/
    
    event SummonComplete(address[] shamans, address[] guildTokens, address[] summoners, uint96[] loot, uint96[] shares, uint32 gracePeriod, uint32 minVotingPeriod, uint32 maxVotingPeriod, string name, string symbol, bool lootPaused, bool sharesPaused); /*emits after Baal summoning*/
    event SubmitProposal(address[] to, uint96[] value, uint32 votingPeriod, uint256 indexed proposal, uint8 indexed flag, bytes[] data, string details); /*emits after proposal submitted*/
    event SubmitVote(address indexed member, uint256 balance, uint256 indexed proposal, bool indexed vote); /*emits after vote submitted on proposal*/
    event ProcessProposal(uint256 indexed proposal); /*emits when proposal is processed & executed*/
    event Ragequit(address indexed memberAddress, address to, uint96 lootToBurn, uint96 sharesToBurn); /*emits when callers burn Baal shares and/or loot for a given `to` account*/
    event TransferLoot(address indexed from, address indexed to, uint96 amount); /*emits when Baal loot is transferred*/
    
    uint256 status;
    modifier nonReentrant() { /*Reentrancy guard*/
        require(status == 1,'reentrant'); 
        status = 2; 
        _;
        status = 1;
    }

    struct Member { /*Baal membership details*/
        uint256 highestIndexYesVote; /*highest proposal index # on which the member voted YES*/
        uint96  loot; /*economic weight held by `members` - combined with `shares` on ragequit - can be set on summoning & adjusted via {memberAction} or membership[1] proposal*/
        mapping(uint256 => bool) voted; /*maps vote decisions on proposals by `members` account*/
    }
    
    struct Proposal { /*Baal proposal details*/
        uint32 votingStarts; /*starting time for proposal in seconds since unix epoch*/
        uint32 votingEnds; /*termination date for proposal in seconds since unix epoch - derived from `votingPeriod`*/
        uint96 yesVotes; /*counter for `members` 'yes' votes to calculate approval on processing*/
        uint96 noVotes; /*counter for `members` 'no' votes to calculate approval on processing*/
        bool[4] flags; /*flags for proposal type & status - [action, membership, period, whitelist]*/
        address[] to; /*account(s) that receive(s) low-level call `data` & ETH `value` - if `membership`[2] flag, account(s) that will receive or lose `value` shares, respectively*/
        uint96[] value; /*ETH sent from Baal to execute approved proposal low-level call(s)*/
        bytes[] data; /*raw data sent to `target` account for low-level call*/
        string details; /*context for proposal*/
    }
    
    /// @notice Summon Baal with guild configuration & create initial array of `members` accounts with `shares` & `loot` weights.
    /// @param _shamans External contracts approved for {memberAction}.
    /// @param _guildTokens Tokens approved for internal accounting - {ragequit} of shares &/or loot.
    /// @param _summoners Accounts to add as `members`.
    /// @param _loot Economic weight among `members`.
    /// @param _shares Voting weight among `members` (shares also have economic weight & are erc20 tokens).
    /// @param _gracePeriod Time delay in seconds after voting period before proposal can be processed.
    /// @param _minVotingPeriod Minimum voting period in seconds for `members` to cast votes on proposals.
    /// @param _maxVotingPeriod Maximum voting period in seconds for `members` to cast votes on proposals.
    /// @param _name Name for erc20 shares accounting.
    /// @param _symbol Symbol for erc20 shares accounting.
    constructor(
        address[] memory _shamans, 
        address[] memory _guildTokens, 
        address[] memory _summoners, 
        uint96[]  memory _loot, 
        uint96[]  memory _shares, 
        uint32           _gracePeriod,
        uint32           _minVotingPeriod, 
        uint32           _maxVotingPeriod, 
        string    memory _name, 
        string    memory _symbol,
        bool             _lootPaused) ERC20(_name, _symbol) ERC20Permit(_name) {
        require(_summoners.length == _loot.length && _loot.length == _shares.length,'member mismatch'); /*check array lengths match*/
        unchecked {
            for (uint256 i; i < _shamans.length; i++) shamans[_shamans[i]] = true; /*update mapping of approved `shamans` in Baal*/
            for (uint256 i; i < _guildTokens.length; i++) guildTokens.push(_guildTokens[i]); /*update array of `guildTokens` approved for {ragequit}*/
            for (uint256 i; i < _summoners.length; i++) {
                _delegate(_summoners[i], _summoners[i]); /*delegate `summoners` voting weights to themselves - this saves a step before voting*/
                _mintLoot(_summoners[i], _loot[i]); /*mint Baal `loot` to `summoners`*/
                _mint(_summoners[i], _shares[i]); /*mint Baal `shares` to `summoners`*/ 
                memberList.push(_summoners[i]); /*push `summoners` to `members` array*/
            }
        }
        gracePeriod = _gracePeriod; /*sets delay for processing proposal*/
        minVotingPeriod = _minVotingPeriod; /*set minimum voting period - adjustable via 'period'[2] proposal*/
        maxVotingPeriod = _maxVotingPeriod; /*set maximum voting period - adjustable via 'period'[2] proposal*/
        lootPaused = _lootPaused; /*set initial transferability for 'loot' - if 'paused', transfers are blocked*/
        //sharesPaused = _sharesPaused; /*set initial transferability for 'shares' tokens - if 'paused', transfers are blocked*/
        status = 1; /*initialize reentrancy guard status*/
        //emit SummonComplete(_shamans, _guildTokens, _summoners, _loot, _shares, _gracePeriod, _minVotingPeriod, _maxVotingPeriod, _name, _symbol, _lootPaused, sharesPaused_); /*emit event reflecting Baal summoning completed*/
    }

    /// @notice Execute membership action to mint or burn shares or loot against whitelisted `minions` in consideration of `msg.sender` & given amounts.
    /// @param shaman Whitelisted contract to trigger action.
    /// @param loot Loot involved in external call.
    /// @param shares Shares involved in external call.
    /// @param mint Confirm whether action involves mint or burn action - if `false`, perform burn.
    /// @return lootOut sharesOut Loot and/or shares derived from action.
    function memberAction(address shaman, uint96 loot, uint96 shares, bool mint) external nonReentrant payable returns (uint96 lootOut, uint96 sharesOut) {
        require(shamans[shaman],'!shaman'); /*check `shaman` is approved*/
        if (mint) { /*execute `mint` action*/
            (lootOut, sharesOut) = IShaman(shaman).memberAction{value: msg.value}(msg.sender, loot, shares); /*fetch 'reaction' mint per inputs*/
            if (lootOut != 0) _mintLoot(msg.sender, lootOut); emit TransferLoot(address(0), msg.sender, lootOut); /*add loot to `msg.sender` account & Baal totals*/
            if (sharesOut != 0) _mint(msg.sender, sharesOut); /*add shares to `msg.sender` account & Baal total with erc20 accounting*/
        } else { /*otherwise, execute burn action*/
            (lootOut, sharesOut) = IShaman(shaman).memberAction{value: msg.value}(msg.sender, loot, shares); /*fetch 'reaction' burn per inputs*/
            if (lootOut != 0) _burnLoot(msg.sender, lootOut); emit TransferLoot(msg.sender, address(0), lootOut); /*subtract loot from `msg.sender` account & Baal totals*/
            if (sharesOut != 0) _burn(msg.sender, sharesOut); /*subtract shares from `msg.sender` account & Baal total with erc20 accounting*/
        }
    }
    
    /*****************
    PROPOSAL FUNCTIONS
    *****************/
    /// @notice Submit proposal to Baal `members` for approval within voting period.
    /// @param to Account to target for proposal.
    /// @param value Numerical value to bind to proposal.
    /// @param data Data to bind to proposal.
    /// @param details Context for proposal.
    /// @return proposal Count for submitted proposal.
    function submitProposal(address[] calldata to, uint96[] calldata value, uint32 votingPeriod, uint8 flag, bytes[] calldata data, string calldata details) external nonReentrant returns (uint256 proposal) {
        require(balanceOf(msg.sender) != 0,'!member'); /*check membership - required to submit proposal*/
        require(minVotingPeriod <= votingPeriod && votingPeriod <= maxVotingPeriod,'!votingPeriod'); /*check voting period is within bounds*/
        require(to.length == value.length && value.length == data.length,'!arrays'); /*check array lengths match*/
        require(to.length <= 10,'array max'); /*limit executable actions to help avoid block gas limit errors on processing*/
        require(flag <= 3,'!flag'); /*check flag is in bounds*/
        bool[4] memory flags; /*plant flags - [action, membership, period, whitelist]*/
        flags[flag] = true; /*flag proposal type for struct storage*/ 
        unchecked {
            proposalCount++; /*increment total proposal counter*/
            proposals[proposalCount] = Proposal(uint32(block.number), uint32(block.timestamp) + votingPeriod, 0, 0, flags, to, value, data, details); /*push params into proposal struct - start voting period timer*/
        }
        emit SubmitProposal(to, value, votingPeriod, proposal, flag, data, details); /*emit event reflecting proposal submission*/
    }
 
    /// @notice Submit vote - proposal must exist & voting period must not have ended.
    /// @param proposal Number of proposal in `proposals` mapping to cast vote on.
    /// @param approve If 'true', member will cast `yesVotes` onto proposal - if 'false', `noVotes` will be counted.
    function submitVote(uint256 proposal, bool approve) external nonReentrant {
        Proposal storage prop = proposals[proposal]; /*alias proposal storage pointers*/
        uint96 balance = uint96(getPastVotes(msg.sender, prop.votingStarts)); /*fetch & gas-optimize voting weight at proposal creation time*/
        require(prop.votingEnds >= block.timestamp,'ended'); /*check voting period has not ended*/
        unchecked {
            if (approve) { prop.yesVotes += balance; members[msg.sender].highestIndexYesVote = proposal; /*if 'approve', cast delegated balance 'yes' votes to proposal*/
            } else { prop.noVotes += balance;} /*otherwise, cast delegated balance 'no' votes to proposal*/
        }
        members[msg.sender].voted[proposal] = approve; /*record voting decision to `members` struct per account*/
        emit SubmitVote(msg.sender, balance, proposal, approve); /*emit event reflecting vote*/
    }
        
    // ********************
    // PROCESSING FUNCTIONS
    // ********************
    /// @notice Process `proposal` & execute internal functions based on `flag`[#].
    /// @param proposal Number of proposal in `proposals` mapping to process for execution.
    function processProposal(uint256 proposal) external nonReentrant {
        Proposal storage prop = proposals[proposal]; /*alias `proposal` storage pointers*/
        _processingReady(proposal, prop); /*validate `proposal` processing requirements*/
        if (prop.yesVotes > prop.noVotes) /*check if `proposal` approved by simple majority of members*/
            if (prop.flags[0]) processActionProposal(prop); /*check `flag`, execute 'action'*/
            else if (prop.flags[1]) processMemberProposal(prop); /*check `flag`, execute 'membership'*/
            else if (prop.flags[2]) processPeriodProposal(prop); /*check `flag`, execute 'period'*/
            else processWhitelistProposal(prop); /*otherwise, execute 'whitelist'*/
        delete proposals[proposal]; /*delete given proposal struct details for gas refund & the commons*/
        emit ProcessProposal(proposal); /*emit event reflecting that given proposal processed*/
    }
    
    /// @notice Process 'action'[0] proposal.
    function processActionProposal(Proposal memory prop) private returns (bytes memory returnData) {
        for (uint256 i; i < prop.to.length; i++) 
            (,returnData) = prop.to[i].call{value:prop.value[i]} /*pass ETH value(s), if any*/
            (prop.data[i]); /*execute low-level call(s)*/
    }
    
    /// @notice Process 'membership'[1] proposal.
    function processMemberProposal(Proposal memory prop) private {
        for (uint256 i; i < prop.to.length; i++) {
            if (prop.data[i].length == 0) {
                if (balanceOf(prop.to[i]) == 0) memberList.push(prop.to[i]); /*update membership list if new*/
                _mint(prop.to[i], prop.value[i]); /*grant `to` member shares & update Baal totals*/
            } else {
                unchecked {memberList[prop.value[i]] = memberList[(memberList.length - 1)];} memberList.pop(); /*swap & pop removed & last member listings*/
                uint96 removedBalance = uint96(balanceOf(prop.to[i])); /*gas-optimize variable*/
                _burn(prop.to[i], removedBalance); /*burn targeted member `shares` & convert into `loot`*/
                _mintLoot(prop.to[i], removedBalance); /*mint equivalent `loot`*/
            }
        }
    }
    
    /// @notice Process 'period'[2] proposal.
    function processPeriodProposal(Proposal memory prop) private {
        if (prop.value[0] != 0) minVotingPeriod = uint32(prop.value[0]); /*if positive, reset min. voting periods to first `value`*/ 
        if (prop.value[1] != 0) maxVotingPeriod = uint32(prop.value[1]); /*if positive, reset max. voting periods to second `value`*/
        if (prop.value[2] != 0) gracePeriod = uint32(prop.value[2]); /*if positive, reset grace periods to third `value`*/
        prop.value[3] == 0 ? lootPaused = false : lootPaused = true; /*if positive, pause loot transfers on fourth `value`*/
        prop.value[4] == 0 ? sharesPaused = false : sharesPaused = true; /*if positive, pause loot shares transfers on fifth `value`*/
    }  
        
    /// @notice Process 'whitelist'[3] proposal.
    function processWhitelistProposal(Proposal memory prop) private {
        for (uint256 i; i < prop.to.length; i++) 
            if (prop.value[i] == 0 && prop.data.length == 0) { /*if `value` & `data` are null, approve `shamans`*/
                shamans[prop.to[i]] = true; /*add account(s) to `shamans` extensions*/
                } else if (prop.value[i] == 0 && prop.data.length != 0) { /*if `value` is null & `data` is populated, remove `shamans`*/
                    shamans[prop.to[i]] = false; /*remove account(s) from `shamans` extensions*/
                } else if (prop.value[i] != 0 && prop.data.length == 0) { /*if `value` is positive & `data` is null, add `guildTokens`*/
                    if (guildTokens.length == MAX_GUILD_TOKEN_COUNT) guildTokens.push(prop.to[i]); /*push account to `guildTokens` array if within 'MAX'*/
                } else { /*otherwise, remove `guildTokens`*/
                    guildTokens[prop.value[i]] = guildTokens[guildTokens.length - 1]; /*swap-to-delete index with last value*/
                    guildTokens.pop(); /*pop account from `guildTokens` array*/
                }
    }
            
    /// @notice Process member burn of `shares` and/or `loot` to claim 'fair share' of `guildTokens`.
    /// @param lootToBurn Baal pure economic weight to burn.
    /// @param sharesToBurn Baal voting weight to burn.
    function ragequit(address to, uint96 lootToBurn, uint96 sharesToBurn) external nonReentrant {
        require(proposals[members[msg.sender].highestIndexYesVote].votingEnds == 0,'processed'); /*check highest index proposal member approved has processed*/
        for (uint256 i; i < guildTokens.length; i++) {
            (,bytes memory balanceData) = guildTokens[i].staticcall(abi.encodeWithSelector(0x70a08231, address(this))); /*get Baal token balances - 'balanceOf(address)' - this technique saves gas*/
            uint256 balance = abi.decode(balanceData, (uint256)); /*decode Baal token balances for calculation*/
            uint256 amountToRagequit = ((lootToBurn + sharesToBurn) * balance) / totalSupply(); /*calculate 'fair shair' claims*/
            if (amountToRagequit != 0) { /*gas optimization to allow higher maximum token limit*/
                _safeTransfer(guildTokens[i], to, amountToRagequit); /*execute 'safe' token transfer*/
            }
        }
        if (lootToBurn != 0) /*gas optimization*/ 
            _burnLoot(msg.sender, lootToBurn); /*subtract `loot` from `msg.sender` account & Baal totals*/
        if (sharesToBurn != 0) /*gas optimization*/ 
            _burn(msg.sender, sharesToBurn);  /*subtract `shares` from `msg.sender` account with erc20 accounting*/
        emit Ragequit(msg.sender, to, lootToBurn, sharesToBurn); /*event reflects claims made against Baal*/
    }
 
    /// @notice Transfer `amount` `loot` from `msg.sender` to `to`.
    /// @param to The address of destination account.
    /// @param amount The sum of loot to transfer.
    function transferLoot(address to, uint96 amount) external {
        require(!lootPaused,'!transferable');
        members[msg.sender].loot -= amount;
        members[to].loot += amount;
        emit TransferLoot(msg.sender, to, amount);
    }
    
    /// @notice Flashloan ability that conforms to `IERC3156FlashLender`.
    /// @param receiver Address of token receiver that conforms to `IERC3156FlashBorrower` & handles flashloan.
    /// @param token The loan currency.
    /// @param amount The amount of tokens lent.
    /// @param data Arbitrary data structure, intended to contain user-defined parameters.
    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external override returns (bool success) {
        uint256 fee = flashFee(token, amount);
        _safeTransfer(token, address(receiver), amount);
        require(receiver.onFlashLoan(msg.sender, token, amount, fee, data) == keccak256('ERC3156FlashBorrower.onFlashLoan'),'Callback failed');
        _safeTransferFrom(token, address(receiver), address(this), amount + fee);
        return true;
    }
    
    /***************
    GETTER FUNCTIONS
    ***************/
    /// @notice Returns array list of approved `guildTokens` in Baal for {ragequit}.
    function getGuildTokens() external view returns (address[] memory tokens) {
        tokens = guildTokens;
    }

    /// @notice Returns array list of registered `members` accounts in Baal.
    function getMemberList() external view returns (address[] memory membership) {
        membership = memberList;
    }

    /// @notice Returns 'flags' for given Baal `proposal` describing type ('action'[0], 'membership'[1], 'period'[2], 'whitelist'[3]).
    function getProposalFlags(uint256 proposal) external view returns (bool[4] memory flags) {
        flags = proposals[proposal].flags;
    }
    
    /// @notice Returns true/false 'vote' by a given `account` on Baal `proposal` to indicate approval.
    function getProposalVotes(address account, uint32 proposal) external view returns (bool vote) {
        vote = members[account].voted[proposal];
    }
    
    /// @dev The fee to be charged for a given loan.
    /// @param amount The amount of tokens lent.
    /// @return fee The `fee` amount of 'token' to be charged for the loan, on top of the returned principal.
    function flashFee(address, uint256 amount) public view override returns (uint256 fee) {
        fee = amount * flashFeeNumerator / 10000; /*Calculate fee - precision factor `10000` derived from ERC-3156 'Flash Loan Reference'*/
    }
    
    /// @dev The amount of currency available to be lent.
    /// @param token The loan currency.
    /// @return amount The `amount` of `token` that can be borrowed.
    function maxFlashLoan(address token) external view override returns (uint256 amount) {
        amount = IERC20(token).balanceOf(address(this));
    }

    /***************
    HELPER FUNCTIONS
    ***************/
    /// @notice Deposits ETH sent to Baal.
    receive() external payable {}
    
    /// @notice Provides confirmation for 'safe' ERC-721 (NFT) transfers to Baal.
    function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4 sig) {
        sig = 0x150b7a02; /*'onERC721Received(address,address,uint256,bytes)'*/
    }
    
    /// @notice Provides confirmation for 'safe' ERC-1155 transfers to Baal.
    function onERC1155Received(address, address, uint256, uint256, bytes calldata) external pure returns (bytes4 sig) {
        sig = 0xf23a6e61; /*'onERC1155Received(address,address,uint256,uint256,bytes)'*/
    }
    
    /// @notice Provides confirmation for 'safe' batch ERC-1155 transfers to Baal.
    function onERC1155BatchReceived(address, address, uint256[] calldata, uint256[] calldata, bytes calldata) external pure returns (bytes4 sig) {
        sig = 0xbc197c81; /*'onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)'*/
    }

    /// @notice Internal check to ensure share transfers are not paused in Baal.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        super._beforeTokenTransfer(from, to, amount);
        require(!sharesPaused,'!transferable');
    }
    
    /// @notice Internal burn function for Baal `loot`.
    function _burnLoot(address from, uint96 loot) private {
        members[from].loot -= loot; /*subtract `loot` for `from` account*/
        totalLoot -= loot; /*subtract from total Baal `loot`*/
        emit TransferLoot(from, address(0), loot); /*emit event reflecting burn of `loot`*/
    }
    
    /// @notice Internal minting function for Baal `loot`.
    function _mintLoot(address to, uint96 loot) private {
        members[to].loot += loot; /*add `loot` for `to` account*/
        totalLoot += loot; /*add to total Baal `loot`*/
        emit TransferLoot(address(0), to, loot); /*emit event reflecting mint of `loot`*/
    }
 
    /// @notice Internal check to validate basic proposal processing requirements. 
    function _processingReady(uint256 proposal, Proposal memory prop) private view returns (bool ready) {
        unchecked {
            require(proposal <= proposalCount,'!exist'); /*check proposal exists*/
            require(prop.votingEnds + gracePeriod <= block.timestamp,'!ended'); /*check voting period has ended*/
            require(proposals[proposal - 1].votingEnds == 0,'prev!processed'); /*check previous proposal has processed by deletion*/
            require(proposals[proposal].votingEnds != 0,'processed'); /*check given proposal has not yet processed by deletion*/
            if (memberList.length == 1) ready = true; /*if single membership, process early*/
            else if (prop.yesVotes > totalSupply() / 2) ready = true; /*process early if majority member support*/
            else if (prop.votingEnds >= block.timestamp) ready = true; /*otherwise, process if voting period done*/
        }
    }
    
    /// @notice Provides 'safe' {transfer} for tokens that do not consistently return true/false.
    /// @param token Address of ERC-20 token.
    /// @param to Account to send tokens to.
    /// @param amount The token amount to send.
    function _safeTransfer(address token, address to, uint256 amount) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, amount)); /*'transfer(address,uint256)'*/
        require(success && (data.length == 0 || abi.decode(data, (bool))),'transfer failed'); /*checks success & allows non-conforming transfers*/
    }

    /// @notice Provides 'safe' {transferFrom} for tokens that do not consistently return true/false.
    /// @param token Address of ERC-20 token.
    /// @param from Account to send tokens from.
    /// @param to Account to send tokens to.
    /// @param amount Token amount to send.
    function _safeTransferFrom(address token, address from, address to, uint256 amount) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, amount)); /*'transferFrom(address,address,uint256)'*/
        require(success && (data.length == 0 || abi.decode(data, (bool))),'transferFrom failed'); /*checks success & allows non-conforming transfers*/
    }
}

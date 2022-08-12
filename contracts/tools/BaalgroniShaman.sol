// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

import "../libraries/Base64.sol";

// import "hardhat/console.sol";

import "../interfaces/IBaal.sol";

interface IWRAPPER {
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
}

interface IERC5192 {
    /// @notice Returns the locking status of an Soulbound Token
    /// @dev SBTs assigned to zero address are considered invalid, and queries
    /// about them do throw.
    /// @param tokenId The identifier for an SBT.
    function locked(uint256 tokenId) external view returns (bool);
}

contract BaalgroniShaman is ERC721, IERC5192, Initializable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    // ERC721 CONFIG
    string private _name; /*Name for ERC721 trackers*/
    string private _symbol; /*Symbol for ERC721 trackers*/

    IBaal public moloch;
    IWRAPPER public wrapper;
    IERC20 private lootToken;
    IERC20 private sharesToken;

    uint256 public price; // ex. 200000000000000000000;
    uint256 public cap; // ex. 200;
    uint256 public tokensPerUnit; // ex. 100;
    uint256 public daoCut; // ex. 3;
    uint256 public expiry;
    address[] public cuts; // ex. 3;
    uint256[] public amounts; // ex. 3;

    bool public shares;

    string public core; // ex. "Bourbon";
    string public property; // ex. "Aged";
    // use pinned file upload with file baalgroni-bound/baalgroni-unbound
    string public imageHash;

    mapping(uint256 => address) public bindings;

    event Bind(address baalgroni, uint256 tokedId);

    event Unbind(address baalgroni, uint256 tokedId);

    // TODO: isManager checks
    error InvalidIndex();
    error Bound();
    error Unbound();
    error OnlyOwnerCanUnbind();
    error OnlyOwnerCanBind();
    error NotEnough();
    error InvalidOrder();
    error CapMet();
    error Expired();
    error WrapFailed();
    error TransferFailed();
    error OnlyLootHolderCanUnbind();
    error OnlyShareHolderCanUnbind();

    constructor() ERC721("Template", "T") initializer {} /*Configure template to be unusable*/

    // ****************
    // INIT FUNCTION
    // ****************

    /// @notice initialize the function from factory
    /// @param _moloch The DAO this is a shaman for
    /// @param _wrapper A native token wrapper contract
    /// @param _shares is this minting shares or loot
    /// @param _price the price for a single NFT
    /// @param _cap the total amount of NFTs
    /// @param _tokensPerUnit number of shares/loot per nft sold
    /// @param _expiry when to disable this shaman from minting
    /// @param _cuts linked list of addresses to split tokens to on initial mint
    /// @param _amounts linked list of amounts to split to _cuts on initial mint
    /// @param _initializationParams bytes some metadata strings
    function init(
        address _moloch,
        address _wrapper,
        bool _shares,
        uint256 _price,
        uint256 _cap,
        uint256 _tokensPerUnit,
        uint256 _expiry,
        address[] memory _cuts,
        uint256[] memory _amounts,
        bytes memory _initializationParams
    ) external initializer {
        moloch = IBaal(_moloch);
        wrapper = IWRAPPER(_wrapper);
        lootToken = IERC20(moloch.lootToken());
        sharesToken = IERC20(moloch.sharesToken());

        (
            string memory _tokenName,
            string memory _tokenSymbol,
            string memory _core,
            string memory _property,
            string memory _imageHash
        ) = abi.decode(
                _initializationParams,
                (string, string, string, string, string)
            );

        price = _price;
        cap = _cap;
        tokensPerUnit = _tokensPerUnit;
        expiry = _expiry;
        cuts = _cuts;
        amounts = _amounts;
        _name = _tokenName;
        _symbol = _tokenSymbol;
        core = _core;
        property = _property;
        imageHash = _imageHash;
        shares = _shares;
    }

    // ****************
    // INTERNAL FUNCTIONS
    // ****************

    /// @notice mint NFT, bind to address and issues tokens to address and cuts
    /// @param to address to receive
    function _mint(address to) private {
        if (expiry > 0 && expiry < block.timestamp) revert Expired();
        if (msg.value < price) revert NotEnough();
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        if (tokenId > cap) revert CapMet();

        _safeMint(to, tokenId);
        _bind(tokenId, to);
        _mintTokens(to);

        // loop to fill cut receivers
        address[] memory _receivers = new address[](cuts.length);
        for (uint256 i = 0; i < cuts.length; i++) {
            _receivers[i] = cuts[i];
        }

        // loop to fill amount per cut
        uint256[] memory _amounts = new uint256[](amounts.length);
        for (uint256 i = 0; i < amounts.length; i++) {
            _amounts[i] = amounts[i];
        }

        // mint loot to cuts
        moloch.mintLoot(_receivers, _amounts);
    }

    /// @notice to keep treasury ratio correct a dead address needs to hold tokens
    function _burnTokens(address _to) private {
        address[] memory _sinkReceivers = new address[](1);
        _sinkReceivers[0] = address(_to);

        uint256[] memory _amounts = new uint256[](1);
        _amounts[0] = tokensPerUnit;

        if (shares) {
            moloch.burnShares(_sinkReceivers, _amounts);
        } else {
            moloch.burnLoot(_sinkReceivers, _amounts);
        }
    }

    /// @notice remove tokens from the dead address and give them to the receiver
    /// @param to address to receive
    function _mintTokens(address to) private {
        address[] memory _receivers = new address[](1);
        _receivers[0] = to;

        uint256[] memory _amounts = new uint256[](1);
        _amounts[0] = tokensPerUnit;

        if (shares) {
            moloch.mintShares(_receivers, _amounts);
        } else {
            moloch.mintLoot(_receivers, _amounts);
        }
    }

    /// @notice make nft non transferable
    /// @param tokenId NFT to bind by ID
    /// @param to address to bind to
    function _bind(uint256 tokenId, address to) private {
        bindings[tokenId] = to;
        emit Bind(to, tokenId);
    }

    /// @notice make nft transferable
    /// @param tokenId NFT to bind by ID
    /// @param to address to bind to
    function _unbind(uint256 tokenId, address to) private {
        bindings[tokenId] = address(0);
        emit Unbind(to, tokenId);
    }

    // ****************
    // EXTERNAL FUNCTIONS
    // ****************

    /// @notice mint a batch of NFTs to multiple addresses
    /// @param tos addresses to receive
    function batchMint(address[] memory tos) public payable {
        // wrap
        (bool success, ) = address(wrapper).call{value: price * tos.length}("");
        if (!success) revert WrapFailed();
        // send to dao
        require(
            wrapper.transfer(moloch.target(), price * tos.length),
            "Transfer failed"
        );

        if (msg.value > price * tos.length) {
            // Return the extra money to the minter.
            (bool success2, ) = msg.sender.call{
                value: msg.value - (price * tos.length)
            }("");
            if (!success2) revert TransferFailed();
        }

        for (uint256 i = 0; i < tos.length; i++) {
            _mintTokens(tos[i]);
            _mint(tos[i]);
        }
    }

    /// @notice mint a NFT to an addresses
    /// @param to addresses to receive
    function mint(address to) public payable {
        // wrap
        (bool success, ) = address(wrapper).call{value: price}("");
        if (!success) revert WrapFailed();
        // send to dao
        require(wrapper.transfer(moloch.target(), price), "Transfer failed");

        if (msg.value > price) {
            // Return the extra money to the minter.
            (bool success2, ) = msg.sender.call{value: msg.value - price}("");
            if (!success2) revert TransferFailed();
        }

        _mint(to);
    }

    /// @notice bind NFT, issues shares/loot to owner
    /// @param tokenId NFT to bind
    function bind(uint256 tokenId) public {
        if (ownerOf(tokenId) != msg.sender) revert OnlyOwnerCanBind();
        if (locked(tokenId)) revert Bound();
        _bind(tokenId, msg.sender);
        _mintTokens(msg.sender);
        _burnTokens(address(0xbaa1));
    }

    /// @notice unbind NFT, issues shares/loot to owner
    /// @param tokenId NFT to unbind
    function unbind(uint256 tokenId) public {
        if (!locked(tokenId)) revert Unbound();
        if (bindings[tokenId] != msg.sender) revert OnlyOwnerCanUnbind();

        if (!shares && lootToken.balanceOf(msg.sender) < tokensPerUnit)
            revert OnlyLootHolderCanUnbind();
        if (shares && sharesToken.balanceOf(msg.sender) < tokensPerUnit)
            revert OnlyShareHolderCanUnbind();

        _unbind(tokenId, msg.sender);
        _burnTokens(msg.sender);
        _mintTokens(address(0xbaa1));
    }

    /// @notice is the current token soulbound
    /// @param tokenId NFT to bind
    function locked(uint256 tokenId)
        public
        view
        override(IERC5192)
        returns (bool)
    {
        if (bindings[tokenId] != address(0)) {
            return true;
        } else {
            return false;
        }
    }

    // ****************
    // OVERRIDE FUNCTIONS
    // ****************

    /// @notice override before transfer so token can be non transferable
    /// @param from address
    /// @param to address
    /// @param tokenId of NFT to transfer
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721) {
        if (from != address(0) && locked(tokenId)) revert Bound();
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /// @notice Returns the name of the token.
    function name() public view override(ERC721) returns (string memory) {
        return _name;
    }

    /// @notice Returns the symbol of this token
    function symbol() public view override(ERC721) returns (string memory) {
        return _symbol;
    }

    /**  Constructs the tokenURI, separated out from the public function as its a big function.
     * Generates the json data URI and svg data URI that ends up sent when someone requests the tokenURI
     * svg has a image tag that can be updated by the owner (dao)
     * param: _tokenId the tokenId
     */
    function _constructTokenURI(uint256 tokenId)
        internal
        view
        returns (string memory)
    {
        string memory _nftName = string(abi.encodePacked("BAALgroni: ", _name));

        uint256 xp = shares
            ? sharesToken.balanceOf(ownerOf(tokenId))
            : lootToken.balanceOf(ownerOf(tokenId));

        bytes memory _image = abi.encodePacked(
            _baseURI(),
            imageHash,
            "/baalgroni-",
            locked(tokenId) ? "bound" : "unbound",
            ".png"
        );

        bytes memory _core = abi.encodePacked(
            '{"trait_type": "Core", "value": "',
            core,
            '"},'
        );

        bytes memory _sup = abi.encodePacked(
            '{"trait_type": "Property", "value": "',
            property,
            '"},',
            '{"trait_type": "Trainer_XP", "value": "',
            Strings.toString(xp),
            '"}'
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                _nftName,
                                '", "image":"',
                                _image,
                                '", "description": "BaalgroniShaman DAO",',
                                ' "attributes":[{"trait_type": "Locked", "value": "',
                                Strings.toHexString(bindings[tokenId]),
                                '"},',
                                _core,
                                _sup,
                                "]}"
                            )
                        )
                    )
                )
            );
    }

    /* Returns the json data associated with this token ID
     * param tokenId the token ID
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return string(_constructTokenURI(tokenId));
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721)
        returns (bool)
    {
        return
            interfaceId == type(IERC5192).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}

contract CloneFactory {
    // implementation of eip-1167 - see https://eips.ethereum.org/EIPS/eip-1167
    function createClone(address target) internal returns (address result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(
                clone,
                0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
            )
            mstore(add(clone, 0x14), targetBytes)
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )
            result := create(0, clone, 0x37)
        }
    }
}

contract BaalgroniSummoner is CloneFactory {
    address public template;

    event SummonBaalgroniComplete(
        address baalgroni,
        address moloch,
        address wrapper,
        bool shares,
        uint256 price,
        uint256 cap,
        uint256 tokensPerUnit,
        uint256 expiry,
        address[] cuts,
        uint256[] amounts,
        bytes initializationParams
    );

    constructor() {
        BaalgroniShaman baalgroni = new BaalgroniShaman();
        template = address(baalgroni);
    }

    function summonBaalgroni(
        address moloch,
        address wrapper,
        bool shares,
        uint256 price,
        uint256 cap,
        uint256 tokensPerUnit,
        uint256 expiry,
        address[] memory cuts,
        uint256[] memory amounts,
        bytes memory initializationParams
    ) public returns (address) {
        BaalgroniShaman baalgroni = BaalgroniShaman(
            createClone(template)
        );

        baalgroni.init(
            moloch,
            wrapper,
            shares,
            price,
            cap,
            tokensPerUnit,
            expiry,
            cuts,
            amounts,
            initializationParams
        );

        emit SummonBaalgroniComplete(
            address(baalgroni),
            moloch,
            wrapper,
            shares,
            price,
            cap,
            tokensPerUnit,
            expiry,
            cuts,
            amounts,
            initializationParams
        );

        return address(baalgroni);
    }
}

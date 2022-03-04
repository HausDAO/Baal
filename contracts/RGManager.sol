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

import "./Baal.sol";

contract BaalHelpers {
    uint256 status; /*internal reentrancy check tracking value*/
    Baal moloch;

    event Ragequit(
        address indexed member,
        address to,
        uint256 indexed lootToBurn,
        uint256 indexed sharesToBurn,
        address[] tokens
    ); /*emits when users burn Baal `shares` and/or `loot` for given `to` account*/

    modifier nonReentrant() {
        /*reentrancy guard*/
        require(status == 1, "reentrant");
        status = 2;
        _;
        status = 1;
    }

    constructor(address _moloch) {
        moloch = Baal(_moloch);
    }

    /// @notice Process member burn of `shares` and/or `loot` to claim 'fair share' of `guildTokens`.
    /// @param to Account that receives 'fair share'.
    /// @param lootToBurn Baal pure economic weight to burn.
    /// @param sharesToBurn Baal voting weight to burn.
    function ragequit(
        address to,
        uint256 sharesToBurn,
        uint256 lootToBurn
    ) external nonReentrant {
        _ragequit(to, sharesToBurn, lootToBurn, moloch.getGuildTokens());
    }

    /// @notice Process member burn of `shares` and/or `loot` to claim 'fair share' of specified `tokens`
    /// @dev Useful to omit malicious treasury tokens, or include tokens the DAO has not voted into guild tokens
    /// @param to Account that receives 'fair share'.
    /// @param lootToBurn Baal pure economic weight to burn.
    /// @param sharesToBurn Baal voting weight to burn.
    /// @param tokens Array of tokens to include in rage quit calculation
    function advancedRagequit(
        address to,
        uint256 sharesToBurn,
        uint256 lootToBurn,
        address[] calldata tokens
    ) external nonReentrant {
        for (uint256 i; i < tokens.length; i++) {
            if (i > 0) {
                require(tokens[i] > tokens[i - 1], "!order");
            }
        }

        _ragequit(to, sharesToBurn, lootToBurn, tokens);
    }

    /// @notice Internal execution of rage quite
    /// @param to Account that receives 'fair share'.
    /// @param lootToBurn Baal pure economic weight to burn.
    /// @param sharesToBurn Baal voting weight to burn.
    /// @param tokens Array of tokens to include in rage quit calculation
    function _ragequit(
        address to,
        uint256 sharesToBurn,
        uint256 lootToBurn,
        address[] memory tokens
    ) internal {
        // uint256 totalShares = moloch.totalSupply();
        // uint256 _totalLoot = moloch.totalLoot();
        // Workaround for solidity dynamic memory array
        address[] memory _recipients = new address[](1);
        _recipients[0] = msg.sender;

        if (lootToBurn != 0) {
            uint256[] memory _lootToBurn = new uint256[](1);
            _lootToBurn[0] = lootToBurn;
            /*gas optimization*/
            moloch.burnLoot(_recipients, _lootToBurn); /*subtract `loot` from user account & Baal totals*/
        }

        if (sharesToBurn != 0) {
            uint256[] memory _sharesToBurn = new uint256[](1);
            _sharesToBurn[0] = lootToBurn;
            /*gas optimization*/
            moloch.burnShares(_recipients, _sharesToBurn); /*subtract `shares` from user account & Baal totals with erc20 accounting*/
        }

        for (uint256 i; i < tokens.length; i++) {
            (, bytes memory balanceData) = tokens[i].staticcall(
                abi.encodeWithSelector(0x70a08231, address(moloch.target()))
            ); /*get Baal token balances - 'balanceOf(address)'*/
            uint256 balance = abi.decode(balanceData, (uint256)); /*decode Baal token balances for calculation*/

            uint256 amountToRagequit = ((lootToBurn + sharesToBurn) * balance) /
                (moloch.totalSupply() + moloch.totalLoot()); /*calculate 'fair shair' claims*/

            if (amountToRagequit != 0) {
                /*gas optimization to allow higher maximum token limit*/

                (bool success, bytes memory data) = moloch.executeAsBaal(
                    address(moloch),
                    0,
                    abi.encodeWithSelector(0xa9059cbb, to, amountToRagequit)
                );

                require(
                    success && (data.length == 0 || abi.decode(data, (bool))),
                    "transferFrom failed"
                ); /*checks success & allows non-conforming transfers*/
            }
        }

        emit Ragequit(msg.sender, to, lootToBurn, sharesToBurn, tokens); /*event reflects claims made against Baal*/
    }
}

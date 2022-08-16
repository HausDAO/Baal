pragma solidity >=0.8.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "./interfaces/IBaal.sol";

/// @title Shares
/// @notice Accounting for Baal non voting shares
contract Shares is ERC20, ERC20Permit, ERC20Votes, Initializable {
    using ECDSA for bytes32;

    // ERC20 CONFIG
    string private __name; /*Name for ERC20 trackers*/
    string private __symbol; /*Symbol for ERC20 trackers*/

    // Baal Config
    IBaal public baal;

    modifier baalOnly() {
        require(msg.sender == address(baal), "!auth");
        _;
    }

    constructor() ERC20("Template", "T") ERC20Permit("Shares") initializer {} /*Configure template to be unusable*/

    /// @notice Configure loot - called by Baal on summon
    /// @dev initializer should prevent this from being called again
    /// @param name_ Name for ERC20 token trackers
    /// @param symbol_ Symbol for ERC20 token trackers
    function setUp(string memory name_, string memory symbol_)
        external
        initializer
    {
        baal = IBaal(msg.sender); /*Configure Baal to setup sender*/
        __name = name_;
        __symbol = symbol_;
    }

    /// @notice Returns the name of the token.
    function name() public view override(ERC20) returns (string memory) {
        return __name;
    }

    /// @notice Returns the symbol of this token
    function symbol() public view override(ERC20) returns (string memory) {
        return __symbol;
    }

    /// @notice Transfer `amount` tokens from `from` to `to`.
    /// @param from The address of the source account.
    /// @param to The address of the destination account.
    /// @param amount The number of `loot` tokens to transfer.
    /// @return success Whether or not the transfer succeeded.
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override(ERC20) returns (bool success) {
        _transfer(from, to, amount);

        uint256 currentAllowance = allowance(from, msg.sender);
        if (currentAllowance != type(uint256).max) {
            _approve(from, msg.sender, currentAllowance - amount);
        }

        return true;
    }

    /// @notice Baal-only function to mint loot.
    /// @param recipient Address to receive loot
    /// @param amount Amount to mint
    function mint(address recipient, uint256 amount) external baalOnly {
        unchecked {
            if (totalSupply() + amount <= type(uint256).max / 2) {
                _mint(recipient, amount);
            }
        }
    }

    /// @notice Baal-only function to burn loot.
    /// @param account Address to lose loot
    /// @param amount Amount to burn
    function burn(address account, uint256 amount) external baalOnly {
        _burn(account, amount);
    }

    /// @notice Internal hook to restrict token transfers unless allowed by baal
    /// @dev Allows transfers if msg.sender is Baal which enables minting and burning
    /// @param from The address of the source account.
    /// @param to The address of the destination account.
    /// @param amount The number of `loot` tokens to transfer.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20) {
        super._beforeTokenTransfer(from, to, amount);
        require(
            from == address(0) || /*Minting allowed*/
                (msg.sender == address(baal) && to == address(0)) || /*Burning by Baal allowed*/
                !baal.sharesPaused(),
            "!transferable"
        );
    }

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20Votes, ERC20)
    {
        super._afterTokenTransfer(from, to, amount);
        /*If recipient is receiving their first shares, auto-self delegate*/
        // TODO: should check that balance of 'to' was 0 before?
        if (numCheckpoints(to) == 0 && amount > 0) {
            _delegate(to, to);
        }

    }

    function _mint(address recipient, uint256 amount) internal override(ERC20Votes, ERC20) {
        super._mint(recipient, amount);
    }

    function _burn(address recipient, uint256 amount) internal override(ERC20Votes, ERC20) {
        super._burn(recipient, amount);
    }

}


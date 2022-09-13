pragma solidity 0.8.13;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "./utils/BaalVotes.sol";
import "./interfaces/IBaal.sol";

// import "hardhat/console.sol";

/// @title Shares
/// @notice Accounting for Baal non voting shares
contract Shares is BaalVotes {
    // ERC20 CONFIG
    string private __name; /*Name for ERC20 trackers*/
    string private __symbol; /*Symbol for ERC20 trackers*/

    // Baal Config
    IBaal public baal;

    modifier baalOnly() {
        require(msg.sender == address(baal), "!auth");
        _;
    }

    /// @notice Configure shares - called by Baal on summon
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
        __ERC20Permit_init(__name);
        __ERC20_init("Template", "T");
    }

    /// @notice Returns the name of the token.
    function name() public view override(ERC20Upgradeable) returns (string memory) {
        return __name;
    }

    /// @notice Returns the symbol of this token
    function symbol() public view override(ERC20Upgradeable) returns (string memory) {
        return __symbol;
    }

    /// @notice Baal-only function to mint shares.
    /// @param recipient Address to receive shares
    /// @param amount Amount to mint
    function mint(address recipient, uint256 amount) external baalOnly {
        unchecked {
            if (totalSupply() + amount <= type(uint256).max / 2) {
                _mint(recipient, amount);
            }
        }
    }

    /// @notice Baal-only function to burn shares.
    /// @param account Address to lose shares
    /// @param amount Amount to burn
    function burn(address account, uint256 amount) external baalOnly {
        _burn(account, amount);
    }

    /// @notice Internal hook to restrict token transfers unless allowed by baal
    /// @dev Allows transfers if msg.sender is Baal which enables minting and burning
    /// @param from The address of the source account.
    /// @param to The address of the destination account.
    /// @param amount The number of `shares` tokens to transfer.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(BaalVotes) {
        super._beforeTokenTransfer(from, to, amount);
        require(
            from == address(0) || /*Minting allowed*/
                (msg.sender == address(baal) && to == address(0)) || /*Burning by Baal allowed*/
                !baal.sharesPaused(),
            "!transferable"
        );
    }
}

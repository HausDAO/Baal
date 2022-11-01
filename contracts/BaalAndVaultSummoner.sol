// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.7;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

interface IBAALSUMMONER {
    function deployAndSetupSafe(address _moduleAddr, uint256 _saltNonce)
        external
        returns (address);

    function summonBaalFromReferrer(
        bytes calldata initializationParams,
        bytes[] calldata initializationActions,
        uint256 _saltNonce,
        bytes32 referrer
    ) external payable returns (address);
}

/*
Summon new 'non-ragequitable' treasury Safe (Vaults). 
Can summon a dao with a new Vault.
Can summon a vault for a dao after initial dao setup.
Acts as a register and the owner of the contract or DAO can deactivate
Owner of the contract can add new vaults, and set current vaults
Contract is upgradable and should be owned by a DAO
todo: should an existing Vault be able to be added to a dao (would require enableModule on Safe)
*/
contract BaalAndVaultSummoner is Initializable, OwnableUpgradeable, UUPSUpgradeable {

    IBAALSUMMONER _baalSummoner;
    uint256 vaultIdx = 0;

    struct Vault{
        uint256 id;
        bool active;
        address daoAddress;
        address vaultAddress;
    }
    mapping(uint256 => Vault) public vaults;
    mapping(address => address) public delegates;

    event SetVault(
        Vault vault
    );

    event SetDelegate(
        address daoAddress,
        address delegate
    );

    function initialize() initializer public {
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    function setSummonerAddr(
        address baalSummoner
    ) public onlyOwner {
        require(baalSummoner != address(0), "zero address");
        _baalSummoner = IBAALSUMMONER(baalSummoner);
    }

    /** Summon a new baal and add a Vault */
    function summonBaalAndVault(
        bytes calldata initializationParams,
        bytes[] calldata initializationActions,
        uint256 saltNonce,
        bytes32 referrer
    ) external returns (address _daoAddress, address _vaultAddress) {
        _daoAddress = _baalSummoner.summonBaalFromReferrer(
            initializationParams,
            initializationActions,
            saltNonce,
            referrer
        );
        _vaultAddress = _baalSummoner.deployAndSetupSafe(
            _daoAddress, 
            saltNonce + block.timestamp // todo better way to get new salt?
        );
        _setNewVault( _daoAddress, _vaultAddress);

    }

    /** create and add a Vault(safe) to an existing DAO */
    // TODO: should this be a permissioned function: owner, dao members?
    function summonVault(
        address daoAddress,
        uint256 saltNonce
    ) external returns (address _vaultAddress) {
        _vaultAddress = _baalSummoner.deployAndSetupSafe(
            daoAddress, 
            saltNonce + block.timestamp
        );
        _setNewVault(daoAddress, _vaultAddress);
    }

    /** set a Vault as active or not on existing dao (owner only) */
    function setVault(
        uint256 id,
        bool active
    ) public onlyOwner
    {
        _setVault(id, active);
    }

    /** set a new Vault as active on existing dao (owner only) */
    function setNewVault(
        address daoAddress, 
        address vaultAddress
    ) public onlyOwner
    {
        _setNewVault(daoAddress, vaultAddress);
    }

    /** 
    A DAO can set a Vault as inactive 
    Not allowing DAOs to add existing vaults because they could add bad data
    todo: let daos add existing vaults
    */
    function disableVaultAsDao(
        uint256 id,
        address daoAddress
    ) external
    {
        require(msg.sender == daoAddress || msg.sender == delegates[daoAddress], "not DAO or delegate");
        require(vaults[id].daoAddress == daoAddress,"!DAO vault");
        _setVault(id, false);
    }

    /** Allow a Dao to set a delegate that can manage vault enteries */
    function setDelegate(
        address daoAddress,
        address delegate
    ) external
    {
        require(msg.sender == daoAddress, "!DAO");
        delegates[daoAddress] = delegate;
        emit SetDelegate(daoAddress, delegate);
    }


    function _setVault(
        uint256 id, 
        bool active
    ) internal 
    {
        vaults[id].active = active;
        emit SetVault(vaults[id]);
    }

    function _setNewVault(
        address daoAddress, 
        address vaultAddress
    ) internal 
    {
        vaultIdx += 1;
        vaults[vaultIdx] = Vault(vaultIdx, true, daoAddress, vaultAddress);
        emit SetVault(vaults[vaultIdx]);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}
}

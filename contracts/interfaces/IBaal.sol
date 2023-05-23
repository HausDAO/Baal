//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface Interface {
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event AvatarSet(address indexed previousAvatar, address indexed newAvatar);
    event CancelProposal(uint256 indexed proposal);
    event ChangedGuard(address guard);
    event GovernanceConfigSet(
        uint32 voting, uint32 grace, uint256 newOffering, uint256 quorum, uint256 sponsor, uint256 minRetention
    );
    event Initialized(uint8 version);
    event LockAdmin(bool adminLock);
    event LockGovernor(bool governorLock);
    event LockManager(bool managerLock);
    event LootPaused(bool paused);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ProcessProposal(uint256 indexed proposal, bool passed, bool actionFailed);
    event Ragequit(
        address indexed member, address to, uint256 indexed lootToBurn, uint256 indexed sharesToBurn, address[] tokens
    );
    event SetTrustedForwarder(address indexed forwarder);
    event SetupComplete(
        bool lootPaused,
        bool sharesPaused,
        uint32 gracePeriod,
        uint32 votingPeriod,
        uint256 proposalOffering,
        uint256 quorumPercent,
        uint256 sponsorThreshold,
        uint256 minRetentionPercent,
        string name,
        string symbol,
        uint256 totalShares,
        uint256 totalLoot
    );
    event ShamanSet(address indexed shaman, uint256 permission);
    event SharesPaused(bool paused);
    event SponsorProposal(address indexed member, uint256 indexed proposal, uint256 indexed votingStarts);
    event SubmitProposal(
        uint256 indexed proposal,
        bytes32 indexed proposalDataHash,
        uint256 votingPeriod,
        bytes proposalData,
        uint256 expiration,
        uint256 baalGas,
        bool selfSponsor,
        uint256 timestamp,
        string details
    );
    event SubmitVote(address indexed member, uint256 balance, uint256 indexed proposal, bool indexed approved);
    event TargetSet(address indexed previousTarget, address indexed newTarget);

    function adminLock() external view returns (bool);
    function avatar() external view returns (address);
    function burnLoot(address[] calldata from, uint256[] calldata amount) external;
    function burnShares(address[] calldata from, uint256[] calldata amount) external;
    function cancelProposal(uint32 id) external;
    function encodeMultisend(bytes[] memory _calls, address _target)
        external
        pure
        returns (bytes memory encodedMultisend);
    function executeAsBaal(address _to, uint256 _value, bytes calldata _data) external;
    function getGuard() external view returns (address _guard);
    function getProposalStatus(uint32 id) external view returns (bool[4] memory);
    function governorLock() external view returns (bool);
    function gracePeriod() external view returns (uint32);
    function guard() external view returns (address);
    function hashOperation(bytes memory _transactions) external pure returns (bytes32 hash);
    function isAdmin(address shaman) external view returns (bool);
    function isGovernor(address shaman) external view returns (bool);
    function isManager(address shaman) external view returns (bool);
    function isTrustedForwarder(address forwarder) external view returns (bool);
    function latestSponsoredProposalId() external view returns (uint32);
    function lockAdmin() external;
    function lockGovernor() external;
    function lockManager() external;
    function lootToken() external view returns (address);
    function managerLock() external view returns (bool);
    function memberVoted(address, uint32) external view returns (bool);
    function minRetentionPercent() external view returns (uint256);
    function mintLoot(address[] calldata to, uint256[] calldata amount) external;
    function mintShares(address[] calldata to, uint256[] calldata amount) external;
    function multisendLibrary() external view returns (address);
    function owner() external view returns (address);
    function processProposal(uint32 id, bytes calldata proposalData) external;
    function proposalCount() external view returns (uint32);
    function proposalOffering() external view returns (uint256);
    function proposals(uint256)
        external
        view
        returns (
            uint32 id,
            uint32 prevProposalId,
            uint32 votingStarts,
            uint32 votingEnds,
            uint32 graceEnds,
            uint32 expiration,
            uint256 baalGas,
            uint256 yesVotes,
            uint256 noVotes,
            uint256 maxTotalSharesAndLootAtVote,
            uint256 maxTotalSharesAtSponsor,
            address sponsor,
            bytes32 proposalDataHash
        );
    function quorumPercent() external view returns (uint256);
    function ragequit(address to, uint256 sharesToBurn, uint256 lootToBurn, address[] calldata tokens) external;
    function renounceOwnership() external;
    function setAdminConfig(bool pauseShares, bool pauseLoot) external;
    function setAvatar(address _avatar) external;
    function setGovernanceConfig(bytes calldata _governanceConfig) external;
    function setGuard(address _guard) external;
    function setShamans(address[] calldata _shamans, uint256[] calldata _permissions) external;
    function setTarget(address _target) external;
    function setTrustedForwarder(address _trustedForwarderAddress) external;
    function setUp(bytes memory _initializationParams) external;
    function shamans(address) external view returns (uint256);
    function sharesToken() external view returns (address);
    function sponsorProposal(uint32 id) external;
    function sponsorThreshold() external view returns (uint256);
    function state(uint32 id) external view returns (uint8);
    function submitProposal(bytes calldata proposalData, uint32 expiration, uint256 baalGas, string calldata details)
        external
        payable
        returns (uint256);
    function submitVote(uint32 id, bool approved) external;
    function submitVoteWithSig(
        address voter,
        uint256 expiry,
        uint256 nonce,
        uint32 id,
        bool approved,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
    function target() external view returns (address);
    function totalLoot() external view returns (uint256);
    function totalShares() external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function transferOwnership(address newOwner) external;
    function trustedForwarder() external view returns (address);
    function versionRecipient() external view returns (string memory);
    function votingNonces(address) external view returns (uint256);
    function votingPeriod() external view returns (uint32);
}

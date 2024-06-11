//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IBaal {
    // DATA STRUCTURES
    struct Proposal {
        /*Baal proposal details*/
        uint32 id; /*id of this proposal, used in existence checks (increments from 1)*/
        uint32 prevProposalId; /* id of the previous proposal - set at sponsorship from latestSponsoredProposalId */
        uint32 votingStarts; /*starting time for proposal in seconds since unix epoch*/
        uint32 votingEnds; /*termination date for proposal in seconds since unix epoch - derived from `votingPeriod` set on proposal*/
        uint32 graceEnds; /*termination date for proposal in seconds since unix epoch - derived from `gracePeriod` set on proposal*/
        uint32 expiration; /*timestamp after which proposal should be considered invalid and skipped. */
        uint256 baalGas; /* gas needed to process proposal */
        uint256 yesVotes; /*counter for `members` `approved` 'votes' to calculate approval on processing*/
        uint256 noVotes; /*counter for `members` 'dis-approved' 'votes' to calculate approval on processing*/
        uint256 maxTotalSharesAndLootAtVote; /* highest share+loot count during any individual yes vote*/
        uint256 maxTotalSharesAtSponsor; /* highest share+loot count during any individual yes vote*/
        bool[4] status; /* [cancelled, processed, passed, actionFailed] */
        address sponsor; /* address of the sponsor - set at sponsor proposal - relevant for cancellation */
        bytes32 proposalDataHash; /*hash of raw data associated with state updates*/
    }

    /* Unborn -> Submitted -> Voting -> Grace -> Ready -> Processed
                              \-> Cancelled  \-> Defeated   */
    enum ProposalState {
        Unborn, /* 0 - can submit */
        Submitted, /* 1 - can sponsor -> voting */
        Voting, /* 2 - can be cancelled, otherwise proceeds to grace */
        Cancelled, /* 3 - terminal state, counts as processed */
        Grace, /* 4 - proceeds to ready/defeated */
        Ready, /* 5 - can be processed */
        Processed, /* 6 - terminal state */
        Defeated /* 7 - terminal state, yes votes <= no votes, counts as processed */
    }

    function lootToken() external view returns (address);
    function sharesToken() external view returns (address);
    function votingPeriod() external view returns (uint32);
    function gracePeriod() external view returns (uint32);
    function proposalCount() external view returns (uint32);
    function proposalOffering() external view returns (uint256);
    function quorumPercent() external view returns (uint256);
    function sponsorThreshold() external view returns (uint256);
    function minRetentionPercent() external view returns (uint256);
    function latestSponsoredProposalId() external view returns (uint32);
    function state(uint32 id) external view returns (ProposalState);
    function proposals(uint32 id) external view returns (Proposal memory);

    function setUp(bytes memory initializationParams) external;
    function multisendLibrary() external view returns (address);
    // Module
    function avatar() external view returns (address);
    function target() external view returns (address);
    function setAvatar(address avatar) external;
    function setTarget(address avatar) external;
    // BaseRelayRecipient
    function trustedForwarder() external view returns (address);
    function setTrustedForwarder(address trustedForwarderAddress) external;

    function mintLoot(address[] calldata to, uint256[] calldata amount) external;
    function burnLoot(address[] calldata from, uint256[] calldata amount) external;
    function mintShares(address[] calldata to, uint256[] calldata amount) external;
    function burnShares(address[] calldata from, uint256[] calldata amount) external;
    function totalLoot() external view returns (uint256);
    function totalShares() external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function lootPaused() external view returns (bool);
    function sharesPaused() external view returns (bool);
    
    function shamans(address shaman) external view returns (uint256);
    function setShamans(address[] calldata shamans, uint256[] calldata permissions) external;
    function isAdmin(address shaman) external view returns (bool);
    function isManager(address shaman) external view returns (bool);
    function isGovernor(address shaman) external view returns (bool);
    function lockAdmin() external;
    function lockManager() external;
    function lockGovernor() external;
    function adminLock() external view returns (bool);
    function managerLock() external view returns (bool);
    function governorLock() external view returns (bool);
    function setAdminConfig(bool pauseShares, bool pauseLoot) external;
    function setGovernanceConfig(bytes memory governanceConfig) external;

    function submitProposal(
        bytes calldata proposalData,
        uint32 expiration,
        uint256 baalGas,
        string calldata details
    ) external payable returns (uint256);
    function sponsorProposal(uint32 id) external;
    function processProposal(uint32 id, bytes calldata proposalData) external;
    function cancelProposal(uint32 id) external;
    function getProposalStatus(uint32 id) external returns (bool[4] memory);
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

    function executeAsBaal(address to, uint256 value, bytes calldata data) external;
    function ragequit(address to, uint256 sharesToBurn, uint256 lootToBurn, address[] calldata tokens) external;

    function hashOperation(bytes memory transactions) external pure returns (bytes32);
    function encodeMultisend(bytes[] memory calls, address target) external pure returns (bytes memory);
}

# Baal



> Baal &#39;;_;&#39;.

Flexible guild contract inspired by Moloch DAO framework.



## Methods

### adminLock

```solidity
function adminLock() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### allowance

```solidity
function allowance(address, address) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |
| _1 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### avatar

```solidity
function avatar() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### burnLoot

```solidity
function burnLoot(address[] from, uint256[] amount) external nonpayable
```

Baal-or-manager-only function to burn loot.



#### Parameters

| Name | Type | Description |
|---|---|---|
| from | address[] | Array of addresses to lose loot |
| amount | uint256[] | Array of amounts to burn |

### burnShares

```solidity
function burnShares(address[] from, uint256[] amount) external nonpayable
```

Baal-or-manager-only function to burn shares.



#### Parameters

| Name | Type | Description |
|---|---|---|
| from | address[] | Array of addresses to lose shares |
| amount | uint256[] | Array of amounts to burn |

### cancelProposal

```solidity
function cancelProposal(uint32 id) external nonpayable
```

Cancel proposal prior to execution

*Cancellable if proposal is during voting, sender is sponsor, governor, or if sponsor has fallen below threshold*

#### Parameters

| Name | Type | Description |
|---|---|---|
| id | uint32 | Number of proposal in `proposals` mapping to process for execution. |

### encodeMultisend

```solidity
function encodeMultisend(bytes[] _calls, address _target) external pure returns (bytes encodedMultisend)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _calls | bytes[] | undefined |
| _target | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| encodedMultisend | bytes | undefined |

### executeAsBaal

```solidity
function executeAsBaal(address _to, uint256 _value, bytes _data) external nonpayable
```

Can only be called by the avatar which means this can only be called if passed by another     proposal or by a delegated signer on the Safe

*Function to Execute arbitrary code as baal - useful if funds are accidentally sent here*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _to | address | address to call |
| _value | uint256 | value to include in wei |
| _data | bytes | arbitrary transaction data |

### getCurrentVotes

```solidity
function getCurrentVotes(address account) external view returns (uint256 votes)
```

Returns the current delegated `vote` balance for `account`.



#### Parameters

| Name | Type | Description |
|---|---|---|
| account | address | The user to check delegated `votes` for. |

#### Returns

| Name | Type | Description |
|---|---|---|
| votes | uint256 | Current `votes` delegated to `account`. |

### getGuard

```solidity
function getGuard() external view returns (address _guard)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _guard | address | undefined |

### getPriorVotes

```solidity
function getPriorVotes(address account, uint256 timeStamp) external view returns (uint256 votes)
```

Returns the prior number of `votes` for `account` as of `timeStamp`.



#### Parameters

| Name | Type | Description |
|---|---|---|
| account | address | The user to check `votes` for. |
| timeStamp | uint256 | The unix time to check `votes` for. |

#### Returns

| Name | Type | Description |
|---|---|---|
| votes | uint256 | Prior `votes` delegated to `account`. |

### getProposalStatus

```solidity
function getProposalStatus(uint32 id) external view returns (bool[4])
```

Helper to get recorded proposal flags



#### Parameters

| Name | Type | Description |
|---|---|---|
| id | uint32 | Number of proposal in proposals |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool[4] | [cancelled, processed, passed, actionFailed] |

### governorLock

```solidity
function governorLock() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### gracePeriod

```solidity
function gracePeriod() external view returns (uint32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint32 | undefined |

### guard

```solidity
function guard() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### hashOperation

```solidity
function hashOperation(bytes _transactions) external pure returns (bytes32 hash)
```

Returns the keccak256 hash of calldata



#### Parameters

| Name | Type | Description |
|---|---|---|
| _transactions | bytes | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| hash | bytes32 | undefined |

### isAdmin

```solidity
function isAdmin(address shaman) external view returns (bool)
```

Helper to check if shaman permission contains admin capabilities



#### Parameters

| Name | Type | Description |
|---|---|---|
| shaman | address | Address attempting to execute admin permissioned functions |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### isGovernor

```solidity
function isGovernor(address shaman) external view returns (bool)
```

Helper to check if shaman permission contains governor capabilities



#### Parameters

| Name | Type | Description |
|---|---|---|
| shaman | address | Address attempting to execute governor permissioned functions |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### isManager

```solidity
function isManager(address shaman) external view returns (bool)
```

Helper to check if shaman permission contains manager capabilities



#### Parameters

| Name | Type | Description |
|---|---|---|
| shaman | address | Address attempting to execute manager permissioned functions |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### latestSponsoredProposalId

```solidity
function latestSponsoredProposalId() external view returns (uint32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint32 | undefined |

### lockAdmin

```solidity
function lockAdmin() external nonpayable
```

Lock admin so setShamans cannot be called with admin changes




### lockGovernor

```solidity
function lockGovernor() external nonpayable
```

Lock governor so setShamans cannot be called with governor changes




### lockManager

```solidity
function lockManager() external nonpayable
```

Lock manager so setShamans cannot be called with manager changes




### lootPaused

```solidity
function lootPaused() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### lootToken

```solidity
function lootToken() external view returns (contract IBaalToken)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IBaalToken | undefined |

### managerLock

```solidity
function managerLock() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### memberVoted

```solidity
function memberVoted(address, uint32) external view returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |
| _1 | uint32 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### minRetentionPercent

```solidity
function minRetentionPercent() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### mintLoot

```solidity
function mintLoot(address[] to, uint256[] amount) external nonpayable
```

Baal-or-manager-only function to mint loot.



#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address[] | Array of addresses to mint loot |
| amount | uint256[] | Array of amounts to mint |

### mintShares

```solidity
function mintShares(address[] to, uint256[] amount) external nonpayable
```

Baal-or-manager-only function to mint shares.



#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address[] | Array of addresses to receive shares |
| amount | uint256[] | Array of amounts to mint |

### nonces

```solidity
function nonces(address) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### owner

```solidity
function owner() external view returns (address)
```



*Returns the address of the current owner.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### processProposal

```solidity
function processProposal(uint32 id, bytes proposalData) external nonpayable
```

Process `proposal` &amp; execute internal functions.

*Proposal must have succeeded, not been processed, not expired, retention threshold must be met*

#### Parameters

| Name | Type | Description |
|---|---|---|
| id | uint32 | Number of proposal in `proposals` mapping to process for execution. |
| proposalData | bytes | Packed multisend data to execute via Gnosis multisend library |

### proposalCount

```solidity
function proposalCount() external view returns (uint32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint32 | undefined |

### proposalOffering

```solidity
function proposalOffering() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### proposals

```solidity
function proposals(uint256) external view returns (uint32 id, uint32 prevProposalId, uint32 votingStarts, uint32 votingEnds, uint32 graceEnds, uint32 expiration, uint256 baalGas, uint256 yesVotes, uint256 noVotes, uint256 maxTotalSharesAndLootAtYesVote, address sponsor, bytes32 proposalDataHash, string details)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| id | uint32 | undefined |
| prevProposalId | uint32 | undefined |
| votingStarts | uint32 | undefined |
| votingEnds | uint32 | undefined |
| graceEnds | uint32 | undefined |
| expiration | uint32 | undefined |
| baalGas | uint256 | undefined |
| yesVotes | uint256 | undefined |
| noVotes | uint256 | undefined |
| maxTotalSharesAndLootAtYesVote | uint256 | undefined |
| sponsor | address | undefined |
| proposalDataHash | bytes32 | undefined |
| details | string | undefined |

### quorumPercent

```solidity
function quorumPercent() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### ragequit

```solidity
function ragequit(address to, uint256 sharesToBurn, uint256 lootToBurn, address[] tokens) external nonpayable
```

Process member burn of `shares` and/or `loot` to claim &#39;fair share&#39; of specified `tokens`



#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address | Account that receives &#39;fair share&#39;. |
| sharesToBurn | uint256 | Baal voting weight to burn. |
| lootToBurn | uint256 | Baal pure economic weight to burn. |
| tokens | address[] | Array of tokens to include in rage quit calculation |

### renounceOwnership

```solidity
function renounceOwnership() external nonpayable
```



*Leaves the contract without owner. It will not be possible to call `onlyOwner` functions anymore. Can only be called by the current owner. NOTE: Renouncing ownership will leave the contract without an owner, thereby removing any functionality that is only available to the owner.*


### setAdminConfig

```solidity
function setAdminConfig(bool pauseShares, bool pauseLoot) external nonpayable
```

Baal-or-admin-only function to set admin config (pause/unpause shares/loot)



#### Parameters

| Name | Type | Description |
|---|---|---|
| pauseShares | bool | Turn share transfers on or off |
| pauseLoot | bool | Turn loot transfers on or off |

### setAvatar

```solidity
function setAvatar(address _avatar) external nonpayable
```

Can only be called by the current owner.

*Sets the avatar to a new avatar (`newAvatar`).*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _avatar | address | undefined |

### setGovernanceConfig

```solidity
function setGovernanceConfig(bytes _governanceConfig) external nonpayable
```

Baal-or-governance-only function to change periods.



#### Parameters

| Name | Type | Description |
|---|---|---|
| _governanceConfig | bytes | Encoded configuration parameters voting, grace period, tribute, quorum, sponsor threshold, retention bound |

### setGuard

```solidity
function setGuard(address _guard) external nonpayable
```



*Set a guard that checks transactions before execution.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _guard | address | The address of the guard to be used or the 0 address to disable the guard. |

### setShamans

```solidity
function setShamans(address[] _shamans, uint256[] _permissions) external nonpayable
```

Baal-only function to set shaman status.



#### Parameters

| Name | Type | Description |
|---|---|---|
| _shamans | address[] | Addresses of shaman contracts |
| _permissions | uint256[] | Permission level of each shaman in _shamans |

### setTarget

```solidity
function setTarget(address _target) external nonpayable
```

Can only be called by the current owner.

*Sets the target to a new target (`newTarget`).*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _target | address | undefined |

### setUp

```solidity
function setUp(bytes _initializationParams) external nonpayable
```

Summon Baal with voting configuration &amp; initial array of `members` accounts with `shares` &amp; `loot` weights.



#### Parameters

| Name | Type | Description |
|---|---|---|
| _initializationParams | bytes | Encoded setup information. |

### shamans

```solidity
function shamans(address) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### sharesPaused

```solidity
function sharesPaused() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### sharesToken

```solidity
function sharesToken() external view returns (contract IBaalToken)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IBaalToken | undefined |

### sponsorProposal

```solidity
function sponsorProposal(uint32 id) external nonpayable
```

Sponsor proposal to Baal `members` for approval within voting period.



#### Parameters

| Name | Type | Description |
|---|---|---|
| id | uint32 | Number of proposal in `proposals` mapping to sponsor. |

### sponsorThreshold

```solidity
function sponsorThreshold() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### state

```solidity
function state(uint32 id) external view returns (enum Baal.ProposalState)
```

State helper to determine proposal state



#### Parameters

| Name | Type | Description |
|---|---|---|
| id | uint32 | Number of proposal in proposals |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | enum Baal.ProposalState | Unborn -&gt; Submitted -&gt; Voting -&gt; Grace -&gt; Ready -&gt; Processed         \-&gt; Cancelled  \-&gt; Defeated |

### submitProposal

```solidity
function submitProposal(bytes proposalData, uint32 expiration, uint256 baalGas, string details) external payable returns (uint256)
```

Submit proposal to Baal `members` for approval within given voting period.



#### Parameters

| Name | Type | Description |
|---|---|---|
| proposalData | bytes | Multisend encoded transactions or proposal data |
| expiration | uint32 | undefined |
| baalGas | uint256 | undefined |
| details | string | Context for proposal. |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | proposal Count for submitted proposal. |

### submitVote

```solidity
function submitVote(uint32 id, bool approved) external nonpayable
```

Submit vote - proposal must exist &amp; voting period must not have ended.



#### Parameters

| Name | Type | Description |
|---|---|---|
| id | uint32 | Number of proposal in `proposals` mapping to cast vote on. |
| approved | bool | If &#39;true&#39;, member will cast `yesVotes` onto proposal - if &#39;false&#39;, `noVotes` will be counted. |

### submitVoteWithSig

```solidity
function submitVoteWithSig(uint32 id, bool approved, bytes signature) external nonpayable
```

Submit vote with EIP-712 signature - proposal must exist &amp; voting period must not have ended.



#### Parameters

| Name | Type | Description |
|---|---|---|
| id | uint32 | Number of proposal in `proposals` mapping to cast vote on. |
| approved | bool | If &#39;true&#39;, member will cast `yesVotes` onto proposal - if &#39;false&#39;, `noVotes` will be counted. |
| signature | bytes | Concatenated signature |

### target

```solidity
function target() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### totalLoot

```solidity
function totalLoot() external view returns (uint256)
```

Helper to check total supply of child loot contract




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### totalShares

```solidity
function totalShares() external view returns (uint256)
```

Helper to check total supply of child shares contract




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

Helper to check total supply of loot and shares




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### transferOwnership

```solidity
function transferOwnership(address newOwner) external nonpayable
```



*Transfers ownership of the contract to a new account (`newOwner`). Can only be called by the current owner.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newOwner | address | undefined |

### votingPeriod

```solidity
function votingPeriod() external view returns (uint32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint32 | undefined |



## Events

### Approval

```solidity
event Approval(address indexed owner, address indexed spender, uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| spender `indexed` | address | undefined |
| amount  | uint256 | undefined |

### AvatarSet

```solidity
event AvatarSet(address indexed previousAvatar, address indexed newAvatar)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| previousAvatar `indexed` | address | undefined |
| newAvatar `indexed` | address | undefined |

### CancelProposal

```solidity
event CancelProposal(uint256 indexed proposal)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| proposal `indexed` | uint256 | undefined |

### ChangedGuard

```solidity
event ChangedGuard(address guard)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| guard  | address | undefined |

### GovernanceConfigSet

```solidity
event GovernanceConfigSet(uint32 voting, uint32 grace, uint256 newOffering, uint256 quorum, uint256 sponsor, uint256 minRetention)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| voting  | uint32 | undefined |
| grace  | uint32 | undefined |
| newOffering  | uint256 | undefined |
| quorum  | uint256 | undefined |
| sponsor  | uint256 | undefined |
| minRetention  | uint256 | undefined |

### Initialized

```solidity
event Initialized(uint8 version)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| version  | uint8 | undefined |

### LootPaused

```solidity
event LootPaused(bool paused)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| paused  | bool | undefined |

### OwnershipTransferred

```solidity
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| previousOwner `indexed` | address | undefined |
| newOwner `indexed` | address | undefined |

### ProcessProposal

```solidity
event ProcessProposal(uint256 indexed proposal, bool passed, bool actionFailed)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| proposal `indexed` | uint256 | undefined |
| passed  | bool | undefined |
| actionFailed  | bool | undefined |

### Ragequit

```solidity
event Ragequit(address indexed member, address to, uint256 indexed lootToBurn, uint256 indexed sharesToBurn, address[] tokens)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| member `indexed` | address | undefined |
| to  | address | undefined |
| lootToBurn `indexed` | uint256 | undefined |
| sharesToBurn `indexed` | uint256 | undefined |
| tokens  | address[] | undefined |

### SetupComplete

```solidity
event SetupComplete(bool lootPaused, bool sharesPaused, uint32 gracePeriod, uint32 votingPeriod, uint256 proposalOffering, uint256 quorumPercent, uint256 sponsorThreshold, uint256 minRetentionPercent, string name, string symbol, uint256 totalShares, uint256 totalLoot)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| lootPaused  | bool | undefined |
| sharesPaused  | bool | undefined |
| gracePeriod  | uint32 | undefined |
| votingPeriod  | uint32 | undefined |
| proposalOffering  | uint256 | undefined |
| quorumPercent  | uint256 | undefined |
| sponsorThreshold  | uint256 | undefined |
| minRetentionPercent  | uint256 | undefined |
| name  | string | undefined |
| symbol  | string | undefined |
| totalShares  | uint256 | undefined |
| totalLoot  | uint256 | undefined |

### ShamanSet

```solidity
event ShamanSet(address indexed shaman, uint256 permission)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| shaman `indexed` | address | undefined |
| permission  | uint256 | undefined |

### SharesPaused

```solidity
event SharesPaused(bool paused)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| paused  | bool | undefined |

### SponsorProposal

```solidity
event SponsorProposal(address indexed member, uint256 indexed proposal, uint256 indexed votingStarts)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| member `indexed` | address | undefined |
| proposal `indexed` | uint256 | undefined |
| votingStarts `indexed` | uint256 | undefined |

### SubmitProposal

```solidity
event SubmitProposal(uint256 indexed proposal, bytes32 indexed proposalDataHash, uint256 votingPeriod, bytes proposalData, uint256 expiration, uint256 baalGas, bool selfSponsor, uint256 timestamp, string details)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| proposal `indexed` | uint256 | undefined |
| proposalDataHash `indexed` | bytes32 | undefined |
| votingPeriod  | uint256 | undefined |
| proposalData  | bytes | undefined |
| expiration  | uint256 | undefined |
| baalGas  | uint256 | undefined |
| selfSponsor  | bool | undefined |
| timestamp  | uint256 | undefined |
| details  | string | undefined |

### SubmitVote

```solidity
event SubmitVote(address indexed member, uint256 balance, uint256 indexed proposal, bool indexed approved)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| member `indexed` | address | undefined |
| balance  | uint256 | undefined |
| proposal `indexed` | uint256 | undefined |
| approved `indexed` | bool | undefined |

### TargetSet

```solidity
event TargetSet(address indexed previousTarget, address indexed newTarget)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| previousTarget `indexed` | address | undefined |
| newTarget `indexed` | address | undefined |



## Errors

### NotIERC165Compliant

```solidity
error NotIERC165Compliant(address guard_)
```

`guard_` does not implement IERC165.



#### Parameters

| Name | Type | Description |
|---|---|---|
| guard_ | address | undefined |



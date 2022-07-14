# TributeMinion









## Methods

### encodeTributeProposal

```solidity
function encodeTributeProposal(address baal, uint256 shares, uint256 loot, address recipient, uint32 proposalId, address escrow) external pure returns (bytes)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| baal | address | undefined |
| shares | uint256 | undefined |
| loot | uint256 | undefined |
| recipient | address | undefined |
| proposalId | uint32 | undefined |
| escrow | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes | undefined |

### releaseEscrow

```solidity
function releaseEscrow(address _baal, uint32 _proposalId) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _baal | address | undefined |
| _proposalId | uint32 | undefined |

### submitTributeProposal

```solidity
function submitTributeProposal(contract Baal baal, address token, uint256 amount, uint256 shares, uint256 loot, uint32 expiration, string details) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| baal | contract Baal | undefined |
| token | address | undefined |
| amount | uint256 | undefined |
| shares | uint256 | undefined |
| loot | uint256 | undefined |
| expiration | uint32 | undefined |
| details | string | undefined |



## Events

### TributeProposal

```solidity
event TributeProposal(address indexed baal, address token, uint256 amount, address recipient, uint256 proposalId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| baal `indexed` | address | undefined |
| token  | address | undefined |
| amount  | uint256 | undefined |
| recipient  | address | undefined |
| proposalId  | uint256 | undefined |




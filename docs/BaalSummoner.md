# BaalSummoner









## Methods

### deployModule

```solidity
function deployModule(address masterCopy, bytes initializer, uint256 saltNonce) external nonpayable returns (address proxy)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| masterCopy | address | undefined |
| initializer | bytes | undefined |
| saltNonce | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| proxy | address | undefined |

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

### gnosisFallbackLibrary

```solidity
function gnosisFallbackLibrary() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### gnosisMultisendLibrary

```solidity
function gnosisMultisendLibrary() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### gnosisSingleton

```solidity
function gnosisSingleton() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### lootSingleton

```solidity
function lootSingleton() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### sharesSingleton

```solidity
function sharesSingleton() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### summonBaal

```solidity
function summonBaal(bytes initializationParams, bytes[] initializationActions, uint256 _saltNonce) external nonpayable returns (address)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| initializationParams | bytes | undefined |
| initializationActions | bytes[] | undefined |
| _saltNonce | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### summonBaalAndSafe

```solidity
function summonBaalAndSafe(bytes initializationParams, bytes[] initializationActions, uint256 _saltNonce) external nonpayable returns (address)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| initializationParams | bytes | undefined |
| initializationActions | bytes[] | undefined |
| _saltNonce | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### template

```solidity
function template() external view returns (address payable)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address payable | undefined |



## Events

### ModuleProxyCreation

```solidity
event ModuleProxyCreation(address indexed proxy, address indexed masterCopy)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| proxy `indexed` | address | undefined |
| masterCopy `indexed` | address | undefined |

### SummonBaal

```solidity
event SummonBaal(address indexed baal, address indexed loot, address indexed shares, address safe)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| baal `indexed` | address | undefined |
| loot `indexed` | address | undefined |
| shares `indexed` | address | undefined |
| safe  | address | undefined |



## Errors

### FailedInitialization

```solidity
error FailedInitialization()
```

Initialization failed.




### TakenAddress

```solidity
error TakenAddress(address address_)
```

`address_` is already taken.



#### Parameters

| Name | Type | Description |
|---|---|---|
| address_ | address | undefined |

### ZeroAddress

```solidity
error ZeroAddress(address target)
```

`target` can not be zero.



#### Parameters

| Name | Type | Description |
|---|---|---|
| target | address | undefined |



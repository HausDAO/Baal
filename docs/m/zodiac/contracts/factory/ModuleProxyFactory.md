# ModuleProxyFactory









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



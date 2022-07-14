# Guardable



> Guardable - A contract that manages fallback calls made to this contract





## Methods

### getGuard

```solidity
function getGuard() external view returns (address _guard)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _guard | address | undefined |

### guard

```solidity
function guard() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### owner

```solidity
function owner() external view returns (address)
```



*Returns the address of the current owner.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### renounceOwnership

```solidity
function renounceOwnership() external nonpayable
```



*Leaves the contract without owner. It will not be possible to call `onlyOwner` functions anymore. Can only be called by the current owner. NOTE: Renouncing ownership will leave the contract without an owner, thereby removing any functionality that is only available to the owner.*


### setGuard

```solidity
function setGuard(address _guard) external nonpayable
```



*Set a guard that checks transactions before execution.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _guard | address | The address of the guard to be used or the 0 address to disable the guard. |

### transferOwnership

```solidity
function transferOwnership(address newOwner) external nonpayable
```



*Transfers ownership of the contract to a new account (`newOwner`). Can only be called by the current owner.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newOwner | address | undefined |



## Events

### ChangedGuard

```solidity
event ChangedGuard(address guard)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| guard  | address | undefined |

### Initialized

```solidity
event Initialized(uint8 version)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| version  | uint8 | undefined |

### OwnershipTransferred

```solidity
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| previousOwner `indexed` | address | undefined |
| newOwner `indexed` | address | undefined |



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



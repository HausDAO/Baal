# Module









## Methods

### avatar

```solidity
function avatar() external view returns (address)
```



*Address that will ultimately execute function calls.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

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

### setGuard

```solidity
function setGuard(address _guard) external nonpayable
```



*Set a guard that checks transactions before execution.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _guard | address | The address of the guard to be used or the 0 address to disable the guard. |

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
function setUp(bytes initializeParams) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| initializeParams | bytes | undefined |

### target

```solidity
function target() external view returns (address)
```



*Address that this module will pass transactions to.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

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

### AvatarSet

```solidity
event AvatarSet(address indexed previousAvatar, address indexed newAvatar)
```



*Emitted each time the avatar is set.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| previousAvatar `indexed` | address | undefined |
| newAvatar `indexed` | address | undefined |

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

### TargetSet

```solidity
event TargetSet(address indexed previousTarget, address indexed newTarget)
```



*Emitted each time the Target is set.*

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



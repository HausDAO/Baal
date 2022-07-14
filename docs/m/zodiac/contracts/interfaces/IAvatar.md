# IAvatar









## Methods

### disableModule

```solidity
function disableModule(address prevModule, address module) external nonpayable
```

Can only be called by the avatar.Must emit DisabledModule(address module) if successful.

*Disables a module on the avatar.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| prevModule | address | Address that pointed to the module to be removed in the linked list |
| module | address | Module to be removed. |

### enableModule

```solidity
function enableModule(address module) external nonpayable
```

Can only be called by the avatar.Modules should be stored as a linked list.Must emit EnabledModule(address module) if successful.

*Enables a module on the avatar.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| module | address | Module to be enabled. |

### execTransactionFromModule

```solidity
function execTransactionFromModule(address to, uint256 value, bytes data, enum Enum.Operation operation) external nonpayable returns (bool success)
```

Can only be called by an enabled module.Must emit ExecutionFromModuleSuccess(address module) if successful.Must emit ExecutionFromModuleFailure(address module) if unsuccessful.

*Allows a Module to execute a transaction.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address | Destination address of module transaction. |
| value | uint256 | Ether value of module transaction. |
| data | bytes | Data payload of module transaction. |
| operation | enum Enum.Operation | Operation type of module transaction: 0 == call, 1 == delegate call. |

#### Returns

| Name | Type | Description |
|---|---|---|
| success | bool | undefined |

### execTransactionFromModuleReturnData

```solidity
function execTransactionFromModuleReturnData(address to, uint256 value, bytes data, enum Enum.Operation operation) external nonpayable returns (bool success, bytes returnData)
```

Can only be called by an enabled module.Must emit ExecutionFromModuleSuccess(address module) if successful.Must emit ExecutionFromModuleFailure(address module) if unsuccessful.

*Allows a Module to execute a transaction and return data*

#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address | Destination address of module transaction. |
| value | uint256 | Ether value of module transaction. |
| data | bytes | Data payload of module transaction. |
| operation | enum Enum.Operation | Operation type of module transaction: 0 == call, 1 == delegate call. |

#### Returns

| Name | Type | Description |
|---|---|---|
| success | bool | undefined |
| returnData | bytes | undefined |

### getModulesPaginated

```solidity
function getModulesPaginated(address start, uint256 pageSize) external view returns (address[] array, address next)
```



*Returns array of modules.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| start | address | Start of the page. |
| pageSize | uint256 | Maximum number of modules that should be returned. |

#### Returns

| Name | Type | Description |
|---|---|---|
| array | address[] | Array of modules. |
| next | address | Start of the next page. |

### isModuleEnabled

```solidity
function isModuleEnabled(address module) external view returns (bool)
```



*Returns if an module is enabled*

#### Parameters

| Name | Type | Description |
|---|---|---|
| module | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | True if the module is enabled |



## Events

### DisabledModule

```solidity
event DisabledModule(address module)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| module  | address | undefined |

### EnabledModule

```solidity
event EnabledModule(address module)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| module  | address | undefined |

### ExecutionFromModuleFailure

```solidity
event ExecutionFromModuleFailure(address indexed module)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| module `indexed` | address | undefined |

### ExecutionFromModuleSuccess

```solidity
event ExecutionFromModuleSuccess(address indexed module)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| module `indexed` | address | undefined |




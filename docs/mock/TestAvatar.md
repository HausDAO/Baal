# TestAvatar









## Methods

### disableModule

```solidity
function disableModule(address, address) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |
| _1 | address | undefined |

### enableModule

```solidity
function enableModule(address _module) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _module | address | undefined |

### execTransactionFromModule

```solidity
function execTransactionFromModule(address payable to, uint256 value, bytes data, uint8 operation) external nonpayable returns (bool success)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address payable | undefined |
| value | uint256 | undefined |
| data | bytes | undefined |
| operation | uint8 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| success | bool | undefined |

### execTransactionFromModuleReturnData

```solidity
function execTransactionFromModuleReturnData(address payable to, uint256 value, bytes data, uint8 operation) external nonpayable returns (bool success, bytes returnData)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address payable | undefined |
| value | uint256 | undefined |
| data | bytes | undefined |
| operation | uint8 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| success | bool | undefined |
| returnData | bytes | undefined |

### getModulesPaginated

```solidity
function getModulesPaginated(address, uint256 pageSize) external view returns (address[] array, address next)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |
| pageSize | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| array | address[] | undefined |
| next | address | undefined |

### isModuleEnabled

```solidity
function isModuleEnabled(address _module) external view returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _module | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### module

```solidity
function module() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |





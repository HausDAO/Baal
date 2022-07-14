# BaseGuard









## Methods

### checkAfterExecution

```solidity
function checkAfterExecution(bytes32 txHash, bool success) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| txHash | bytes32 | undefined |
| success | bool | undefined |

### checkTransaction

```solidity
function checkTransaction(address to, uint256 value, bytes data, enum Enum.Operation operation, uint256 safeTxGas, uint256 baseGas, uint256 gasPrice, address gasToken, address payable refundReceiver, bytes signatures, address msgSender) external nonpayable
```

This interface is used to maintain compatibilty with Gnosis Safe transaction guards.

*Module transactions only use the first four parameters: to, value, data, and operation. Module.sol hardcodes the remaining parameters as 0 since they are not used for module transactions.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address | undefined |
| value | uint256 | undefined |
| data | bytes | undefined |
| operation | enum Enum.Operation | undefined |
| safeTxGas | uint256 | undefined |
| baseGas | uint256 | undefined |
| gasPrice | uint256 | undefined |
| gasToken | address | undefined |
| refundReceiver | address payable | undefined |
| signatures | bytes | undefined |
| msgSender | address | undefined |

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) external pure returns (bool)
```



*Returns true if this contract implements the interface defined by `interfaceId`. See the corresponding https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section] to learn more about how these ids are created. This function call must use less than 30 000 gas.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| interfaceId | bytes4 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |





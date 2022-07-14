# SignMessageLib

*Richard Meissner - &lt;richard@gnosis.io&gt;*

> SignMessageLib - Allows to set an entry in the signedMessages





## Methods

### getMessageHash

```solidity
function getMessageHash(bytes message) external view returns (bytes32)
```



*Returns hash of a message that can be signed by owners.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| message | bytes | Message that should be hashed |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | Message hash. |

### signMessage

```solidity
function signMessage(bytes _data) external nonpayable
```

Marks a message (`_data`) as signed.

*Marks a message as signed, so that it can be used with EIP-1271*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _data | bytes | Arbitrary length data that should be marked as signed on the behalf of address(this) |



## Events

### SignMsg

```solidity
event SignMsg(bytes32 indexed msgHash)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| msgHash `indexed` | bytes32 | undefined |




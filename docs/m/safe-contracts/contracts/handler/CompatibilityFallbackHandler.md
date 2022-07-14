# CompatibilityFallbackHandler

*Richard Meissner - &lt;richard@gnosis.pm&gt;*

> Compatibility Fallback Handler - fallback handler to provider compatibility between pre 1.3.0 and 1.3.0+ Safe contracts





## Methods

### NAME

```solidity
function NAME() external view returns (string)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### VERSION

```solidity
function VERSION() external view returns (string)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

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

### getMessageHashForSafe

```solidity
function getMessageHashForSafe(contract GnosisSafe safe, bytes message) external view returns (bytes32)
```



*Returns hash of a message that can be signed by owners.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| safe | contract GnosisSafe | Safe to which the message is targeted |
| message | bytes | Message that should be hashed |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | Message hash. |

### getModules

```solidity
function getModules() external view returns (address[])
```



*Returns array of first 10 modules.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address[] | Array of modules. |

### isValidSignature

```solidity
function isValidSignature(bytes32 _dataHash, bytes _signature) external view returns (bytes4)
```

Implementation of updated EIP-1271See https://github.com/gnosis/util-contracts/blob/bb5fe5fb5df6d8400998094fb1b32a178a47c3a1/contracts/StorageAccessible.sol

*Should return whether the signature provided is valid for the provided data.       The save does not implement the interface since `checkSignatures` is not a view method.       The method will not perform any state changes (see parameters of `checkSignatures`)*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _dataHash | bytes32 | Hash of the data signed on the behalf of address(msg.sender) |
| _signature | bytes | Signature byte array associated with _dataHash |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes4 | a bool upon valid or invalid signature with corresponding _dataHash |

### isValidSignature

```solidity
function isValidSignature(bytes _data, bytes _signature) external view returns (bytes4)
```

Implementation of ISignatureValidator (see `interfaces/ISignatureValidator.sol`)

*Should return whether the signature provided is valid for the provided data.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _data | bytes | Arbitrary length data signed on the behalf of address(msg.sender) |
| _signature | bytes | Signature byte array associated with _data |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes4 | a bool upon valid or invalid signature with corresponding _data |

### onERC1155BatchReceived

```solidity
function onERC1155BatchReceived(address, address, uint256[], uint256[], bytes) external pure returns (bytes4)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |
| _1 | address | undefined |
| _2 | uint256[] | undefined |
| _3 | uint256[] | undefined |
| _4 | bytes | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes4 | undefined |

### onERC1155Received

```solidity
function onERC1155Received(address, address, uint256, uint256, bytes) external pure returns (bytes4)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |
| _1 | address | undefined |
| _2 | uint256 | undefined |
| _3 | uint256 | undefined |
| _4 | bytes | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes4 | undefined |

### onERC721Received

```solidity
function onERC721Received(address, address, uint256, bytes) external pure returns (bytes4)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |
| _1 | address | undefined |
| _2 | uint256 | undefined |
| _3 | bytes | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes4 | undefined |

### simulate

```solidity
function simulate(address targetContract, bytes calldataPayload) external nonpayable returns (bytes response)
```



*Performs a delegetecall on a targetContract in the context of self. Internally reverts execution to avoid side effects (making it static). Catches revert and returns encoded result as bytes.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| targetContract | address | Address of the contract containing the code to execute. |
| calldataPayload | bytes | Calldata that should be sent to the target contract (encoded method name and arguments). |

#### Returns

| Name | Type | Description |
|---|---|---|
| response | bytes | undefined |

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) external view returns (bool)
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

### tokensReceived

```solidity
function tokensReceived(address, address, address, uint256, bytes, bytes) external pure
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |
| _1 | address | undefined |
| _2 | address | undefined |
| _3 | uint256 | undefined |
| _4 | bytes | undefined |
| _5 | bytes | undefined |





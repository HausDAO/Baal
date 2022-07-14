# Shares



> Shares

Accounting for Baal non voting shares



## Methods

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```



*See {IERC20-allowance}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |
| spender | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### approve

```solidity
function approve(address spender, uint256 amount) external nonpayable returns (bool)
```



*See {IERC20-approve}. NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on `transferFrom`. This is semantically equivalent to an infinite approval. Requirements: - `spender` cannot be the zero address.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| spender | address | undefined |
| amount | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### baal

```solidity
function baal() external view returns (contract IBaal)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IBaal | undefined |

### balanceOf

```solidity
function balanceOf(address account) external view returns (uint256)
```



*See {IERC20-balanceOf}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| account | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### burn

```solidity
function burn(address account, uint256 amount) external nonpayable
```

Baal-only function to burn loot.



#### Parameters

| Name | Type | Description |
|---|---|---|
| account | address | Address to lose loot |
| amount | uint256 | Amount to burn |

### checkpoints

```solidity
function checkpoints(address, uint256) external view returns (uint32 fromTimeStamp, uint256 votes)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |
| _1 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| fromTimeStamp | uint32 | undefined |
| votes | uint256 | undefined |

### decimals

```solidity
function decimals() external view returns (uint8)
```



*Returns the number of decimals used to get its user representation. For example, if `decimals` equals `2`, a balance of `505` tokens should be displayed to a user as `5.05` (`505 / 10 ** 2`). Tokens usually opt for a value of 18, imitating the relationship between Ether and Wei. This is the value {ERC20} uses, unless this function is overridden; NOTE: This information is only used for _display_ purposes: it in no way affects any of the arithmetic of the contract, including {IERC20-balanceOf} and {IERC20-transfer}.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint8 | undefined |

### decreaseAllowance

```solidity
function decreaseAllowance(address spender, uint256 subtractedValue) external nonpayable returns (bool)
```



*Atomically decreases the allowance granted to `spender` by the caller. This is an alternative to {approve} that can be used as a mitigation for problems described in {IERC20-approve}. Emits an {Approval} event indicating the updated allowance. Requirements: - `spender` cannot be the zero address. - `spender` must have allowance for the caller of at least `subtractedValue`.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| spender | address | undefined |
| subtractedValue | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### delegate

```solidity
function delegate(address delegatee) external nonpayable
```

Delegate votes from user to `delegatee`.



#### Parameters

| Name | Type | Description |
|---|---|---|
| delegatee | address | The address to delegate votes to. |

### delegateBySig

```solidity
function delegateBySig(address delegatee, uint256 nonce, uint256 deadline, bytes signature) external nonpayable
```

Delegates votes from `signatory` to `delegatee` with EIP-712 signature.



#### Parameters

| Name | Type | Description |
|---|---|---|
| delegatee | address | The address to delegate &#39;votes&#39; to. |
| nonce | uint256 | The contract state required to match the signature. |
| deadline | uint256 | The time at which to expire the signature. |
| signature | bytes | The concatenated signature |

### delegates

```solidity
function delegates(address) external view returns (address)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### getCheckpoint

```solidity
function getCheckpoint(address delegatee, uint256 nCheckpoints) external view returns (struct Shares.Checkpoint)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| delegatee | address | undefined |
| nCheckpoints | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | Shares.Checkpoint | undefined |

### increaseAllowance

```solidity
function increaseAllowance(address spender, uint256 addedValue) external nonpayable returns (bool)
```



*Atomically increases the allowance granted to `spender` by the caller. This is an alternative to {approve} that can be used as a mitigation for problems described in {IERC20-approve}. Emits an {Approval} event indicating the updated allowance. Requirements: - `spender` cannot be the zero address.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| spender | address | undefined |
| addedValue | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### mint

```solidity
function mint(address recipient, uint256 amount) external nonpayable
```

Baal-only function to mint loot.



#### Parameters

| Name | Type | Description |
|---|---|---|
| recipient | address | Address to receive loot |
| amount | uint256 | Amount to mint |

### name

```solidity
function name() external view returns (string)
```

Returns the name of the token.




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### nonces

```solidity
function nonces(address) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### numCheckpoints

```solidity
function numCheckpoints(address) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### permit

```solidity
function permit(address owner, address spender, uint256 amount, uint256 deadline, bytes signature) external nonpayable
```

Triggers an approval from `owner` to `spender` with EIP-712 signature.



#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | The address to approve from. |
| spender | address | The address to be approved. |
| amount | uint256 | The number of `loot` tokens that are approved (2^256-1 means infinite). |
| deadline | uint256 | The time at which to expire the signature. |
| signature | bytes | Concatenated signature |

### setUp

```solidity
function setUp(string name_, string symbol_) external nonpayable
```

Configure loot - called by Baal on summon

*initializer should prevent this from being called again*

#### Parameters

| Name | Type | Description |
|---|---|---|
| name_ | string | Name for ERC20 token trackers |
| symbol_ | string | Symbol for ERC20 token trackers |

### symbol

```solidity
function symbol() external view returns (string)
```

Returns the symbol of this token




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```



*See {IERC20-totalSupply}.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### transfer

```solidity
function transfer(address to, uint256 amount) external nonpayable returns (bool)
```



*See {IERC20-transfer}. Requirements: - `to` cannot be the zero address. - the caller must have a balance of at least `amount`.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address | undefined |
| amount | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 amount) external nonpayable returns (bool success)
```

Transfer `amount` tokens from `from` to `to`.



#### Parameters

| Name | Type | Description |
|---|---|---|
| from | address | The address of the source account. |
| to | address | The address of the destination account. |
| amount | uint256 | The number of `loot` tokens to transfer. |

#### Returns

| Name | Type | Description |
|---|---|---|
| success | bool | Whether or not the transfer succeeded. |



## Events

### Approval

```solidity
event Approval(address indexed owner, address indexed spender, uint256 value)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| spender `indexed` | address | undefined |
| value  | uint256 | undefined |

### DelegateChanged

```solidity
event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| delegator `indexed` | address | undefined |
| fromDelegate `indexed` | address | undefined |
| toDelegate `indexed` | address | undefined |

### DelegateVotesChanged

```solidity
event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| delegate `indexed` | address | undefined |
| previousBalance  | uint256 | undefined |
| newBalance  | uint256 | undefined |

### Initialized

```solidity
event Initialized(uint8 version)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| version  | uint8 | undefined |

### Transfer

```solidity
event Transfer(address indexed from, address indexed to, uint256 value)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| from `indexed` | address | undefined |
| to `indexed` | address | undefined |
| value  | uint256 | undefined |




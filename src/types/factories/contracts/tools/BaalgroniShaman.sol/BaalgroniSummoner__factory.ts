/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../../common";
import type {
  BaalgroniSummoner,
  BaalgroniSummonerInterface,
} from "../../../../contracts/tools/BaalgroniShaman.sol/BaalgroniSummoner";

const _abi = [
  {
    inputs: [
      {
        internalType: "address payable",
        name: "_template",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "baalgroni",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "moloch",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "wrapper",
        type: "address",
      },
      {
        indexed: false,
        internalType: "bool",
        name: "shares",
        type: "bool",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "price",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "cap",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "tokensPerUnit",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "expiry",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address[]",
        name: "cuts",
        type: "address[]",
      },
      {
        indexed: false,
        internalType: "uint256[]",
        name: "amounts",
        type: "uint256[]",
      },
      {
        indexed: false,
        internalType: "bytes",
        name: "initializationParams",
        type: "bytes",
      },
    ],
    name: "SummonBaalgroniComplete",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "moloch",
        type: "address",
      },
      {
        internalType: "address",
        name: "wrapper",
        type: "address",
      },
      {
        internalType: "bool",
        name: "shares",
        type: "bool",
      },
      {
        internalType: "uint256",
        name: "price",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "cap",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "tokensPerUnit",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "expiry",
        type: "uint256",
      },
      {
        internalType: "address[]",
        name: "cuts",
        type: "address[]",
      },
      {
        internalType: "uint256[]",
        name: "amounts",
        type: "uint256[]",
      },
      {
        internalType: "bytes",
        name: "initializationParams",
        type: "bytes",
      },
    ],
    name: "summonBaalgroni",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "template",
    outputs: [
      {
        internalType: "address payable",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

const _bytecode =
  "0x608060405234801561001057600080fd5b5060405161071438038061071483398101604081905261002f91610054565b600080546001600160a01b0319166001600160a01b0392909216919091179055610084565b60006020828403121561006657600080fd5b81516001600160a01b038116811461007d57600080fd5b9392505050565b610681806100936000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c80636f2ddd931461003b578063db21b33a1461006a575b600080fd5b60005461004e906001600160a01b031681565b6040516001600160a01b03909116815260200160405180910390f35b61004e610078366004610324565b600080548190610090906001600160a01b031661015d565b604051639c2694b160e01b81529091506001600160a01b03821690639c2694b1906100d1908f908f908f908f908f908f908f908f908f908f90600401610559565b600060405180830381600087803b1580156100eb57600080fd5b505af11580156100ff573d6000803e3d6000fd5b505050507f46593c981ec79136ecb00ba8bc72decfd75af3de807e7fb02160ebd8f03b5d2f818d8d8d8d8d8d8d8d8d8d6040516101469b9a999897969594939291906104c8565b60405180910390a19b9a5050505050505050505050565b6000808260601b9050604051733d602d80600a3d3981f3363d3d373d3d3d363d7360601b81528160148201526e5af43d82803e903d91602b57fd5bf360881b60288201526037816000f0949350505050565b80356001600160a01b03811681146101c657600080fd5b919050565b600082601f8301126101dc57600080fd5b813560206101f16101ec83610611565b6105e0565b80838252828201915082860187848660051b890101111561021157600080fd5b60005b8581101561023757610225826101af565b84529284019290840190600101610214565b5090979650505050505050565b600082601f83011261025557600080fd5b813560206102656101ec83610611565b80838252828201915082860187848660051b890101111561028557600080fd5b60005b8581101561023757813584529284019290840190600101610288565b803580151581146101c657600080fd5b600082601f8301126102c557600080fd5b813567ffffffffffffffff8111156102df576102df610635565b6102f2601f8201601f19166020016105e0565b81815284602083860101111561030757600080fd5b816020850160208301376000918101602001919091529392505050565b6000806000806000806000806000806101408b8d03121561034457600080fd5b61034d8b6101af565b995061035b60208c016101af565b985061036960408c016102a4565b975060608b0135965060808b0135955060a08b0135945060c08b0135935060e08b013567ffffffffffffffff808211156103a257600080fd5b6103ae8e838f016101cb565b94506101008d01359150808211156103c557600080fd5b6103d18e838f01610244565b93506101208d01359150808211156103e857600080fd5b506103f58d828e016102b4565b9150509295989b9194979a5092959850565b600081518084526020808501945080840160005b838110156104405781516001600160a01b03168752958201959082019060010161041b565b509495945050505050565b600081518084526020808501945080840160005b838110156104405781518752958201959082019060010161045f565b6000815180845260005b818110156104a157602081850181015186830182015201610485565b818111156104b3576000602083870101525b50601f01601f19169290920160200192915050565b600061016060018060a01b03808f168452808e166020850152808d166040850152508a151560608401528960808401528860a08401528760c08401528660e08401528061010084015261051d81840187610407565b9050828103610120840152610532818661044b565b9050828103610140840152610547818561047b565b9e9d5050505050505050505050505050565b600061014060018060a01b03808e168452808d166020850152508a151560408401528960608401528860808401528760a08401528660c08401528060e08401526105a581840187610407565b90508281036101008401526105ba818661044b565b90508281036101208401526105cf818561047b565b9d9c50505050505050505050505050565b604051601f8201601f1916810167ffffffffffffffff8111828210171561060957610609610635565b604052919050565b600067ffffffffffffffff82111561062b5761062b610635565b5060051b60200190565b634e487b7160e01b600052604160045260246000fdfea26469706673582212208ae08f8722b33907ef461b2915bff96b62e93dad3ab6893fba31357b4852ba7564736f6c63430008070033";

type BaalgroniSummonerConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: BaalgroniSummonerConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class BaalgroniSummoner__factory extends ContractFactory {
  constructor(...args: BaalgroniSummonerConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    _template: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<BaalgroniSummoner> {
    return super.deploy(
      _template,
      overrides || {}
    ) as Promise<BaalgroniSummoner>;
  }
  override getDeployTransaction(
    _template: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(_template, overrides || {});
  }
  override attach(address: string): BaalgroniSummoner {
    return super.attach(address) as BaalgroniSummoner;
  }
  override connect(signer: Signer): BaalgroniSummoner__factory {
    return super.connect(signer) as BaalgroniSummoner__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): BaalgroniSummonerInterface {
    return new utils.Interface(_abi) as BaalgroniSummonerInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): BaalgroniSummoner {
    return new Contract(address, _abi, signerOrProvider) as BaalgroniSummoner;
  }
}

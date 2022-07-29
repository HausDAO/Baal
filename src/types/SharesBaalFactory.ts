/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Signer } from "ethers";
import { Provider, TransactionRequest } from "@ethersproject/providers";
import { Contract, ContractFactory, Overrides } from "@ethersproject/contracts";

import type { SharesBaal } from "./SharesBaal";

export class SharesBaalFactory extends ContractFactory {
  constructor(signer?: Signer) {
    super(_abi, _bytecode, signer);
  }

  deploy(overrides?: Overrides): Promise<SharesBaal> {
    return super.deploy(overrides || {}) as Promise<SharesBaal>;
  }
  getDeployTransaction(overrides?: Overrides): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  attach(address: string): SharesBaal {
    return super.attach(address) as SharesBaal;
  }
  connect(signer: Signer): SharesBaalFactory {
    return super.connect(signer) as SharesBaalFactory;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): SharesBaal {
    return new Contract(address, _abi, signerOrProvider) as SharesBaal;
  }
}

const _abi = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "Approval",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "delegator",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "fromDelegate",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "toDelegate",
        type: "address",
      },
    ],
    name: "DelegateChanged",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "delegate",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "previousBalance",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "newBalance",
        type: "uint256",
      },
    ],
    name: "DelegateVotesChanged",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "Transfer",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
    ],
    name: "allowance",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "approve",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "baal",
    outputs: [
      {
        internalType: "contract IBaal",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "balanceOf",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "burn",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "checkpoints",
    outputs: [
      {
        internalType: "uint32",
        name: "fromTimeStamp",
        type: "uint32",
      },
      {
        internalType: "uint256",
        name: "votes",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "decimals",
    outputs: [
      {
        internalType: "uint8",
        name: "",
        type: "uint8",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "subtractedValue",
        type: "uint256",
      },
    ],
    name: "decreaseAllowance",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "delegatee",
        type: "address",
      },
    ],
    name: "delegate",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "delegatee",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "nonce",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "deadline",
        type: "uint256",
      },
      {
        internalType: "bytes",
        name: "signature",
        type: "bytes",
      },
    ],
    name: "delegateBySig",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "delegates",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "delegatee",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "nCheckpoints",
        type: "uint256",
      },
    ],
    name: "getCheckpoint",
    outputs: [
      {
        components: [
          {
            internalType: "uint32",
            name: "fromTimeStamp",
            type: "uint32",
          },
          {
            internalType: "uint256",
            name: "votes",
            type: "uint256",
          },
        ],
        internalType: "struct SharesBaal.Checkpoint",
        name: "",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "addedValue",
        type: "uint256",
      },
    ],
    name: "increaseAllowance",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "recipient",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "mint",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "name",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "nonces",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "numCheckpoints",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "deadline",
        type: "uint256",
      },
      {
        internalType: "bytes",
        name: "signature",
        type: "bytes",
      },
    ],
    name: "permit",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "name_",
        type: "string",
      },
      {
        internalType: "string",
        name: "symbol_",
        type: "string",
      },
    ],
    name: "setUp",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "symbol",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "totalSupply",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "transfer",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "transferFrom",
    outputs: [
      {
        internalType: "bool",
        name: "success",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
];

const _bytecode =
  "0x60806040523480156200001157600080fd5b50604080518082018252600881526754656d706c61746560c01b6020808301918252835180850190945260018452601560fa1b9084015281519192916200005b916003916200016e565b508051620000719060049060208401906200016e565b5050600554610100900460ff169050620000925760055460ff16156200009c565b6200009c62000141565b620001045760405162461bcd60e51b815260206004820152602e60248201527f496e697469616c697a61626c653a20636f6e747261637420697320616c72656160448201526d191e481a5b9a5d1a585b1a5e995960921b606482015260840160405180910390fd5b600554610100900460ff1615801562000127576005805461ffff19166101011790555b80156200013a576005805461ff00191690555b5062000251565b600062000159306200015f60201b62000d141760201c565b15905090565b6001600160a01b03163b151590565b8280546200017c9062000214565b90600052602060002090601f016020900481019282620001a05760008555620001eb565b82601f10620001bb57805160ff1916838001178555620001eb565b82800160010185558215620001eb579182015b82811115620001eb578251825591602001919060010190620001ce565b50620001f9929150620001fd565b5090565b5b80821115620001f95760008155600101620001fe565b600181811c908216806200022957607f821691505b602082108114156200024b57634e487b7160e01b600052602260045260246000fd5b50919050565b611f8780620002616000396000f3fe608060405234801561001057600080fd5b506004361061014d5760003560e01c8063587cde1e116100c35780639dc29fac1161007c5780639dc29fac1461034f5780639fd5a6cf14610362578063a457c2d714610375578063a9059cbb14610388578063dd62ed3e1461039b578063e5a2a2a5146103ae57600080fd5b8063587cde1e146102a05780635c19a95c146102e15780636fcfff45146102f457806370a08231146103145780637ecebe001461032757806395d89b411461034757600080fd5b8063313ce56711610115578063313ce5671461020f578063395093511461021e57806340c10f191461023157806347f761f5146102465780634a9e3e131461027a578063562d190d1461028d57600080fd5b806306fdde0314610152578063095ea7b3146101705780630cdfebfa1461019357806318160ddd146101ea57806323b872dd146101fc575b600080fd5b61015a6103c1565b6040516101679190611dcc565b60405180910390f35b61018361017e366004611bd9565b610453565b6040519015158152602001610167565b6101ce6101a1366004611bd9565b60086020908152600092835260408084209091529082529020805460019091015463ffffffff9091169082565b6040805163ffffffff9093168352602083019190915201610167565b6002545b604051908152602001610167565b61018361020a366004611b25565b61046b565b60405160128152602001610167565b61018361022c366004611bd9565b6104ae565b61024461023f366004611bd9565b6104e8565b005b610259610254366004611bd9565b6105f9565b60408051825163ffffffff1681526020928301519281019290925201610167565b610244610288366004611c03565b61064b565b61024461029b366004611c8d565b61083c565b6102c96102ae366004611ad0565b600a602052600090815260409020546001600160a01b031681565b6040516001600160a01b039091168152602001610167565b6102446102ef366004611ad0565b610935565b6101ee610302366004611ad0565b60096020526000908152604090205481565b6101ee610322366004611ad0565b610942565b6101ee610335366004611ad0565b600b6020526000908152604090205481565b61015a61095d565b61024461035d366004611bd9565b61096c565b610244610370366004611b61565b6109f2565b610183610383366004611bd9565b610c49565b610183610396366004611bd9565b610cdb565b6101ee6103a9366004611af2565b610ce9565b600c546102c9906001600160a01b031681565b6060600680546103d090611eb4565b80601f01602080910402602001604051908101604052809291908181526020018280546103fc90611eb4565b80156104495780601f1061041e57610100808354040283529160200191610449565b820191906000526020600020905b81548152906001019060200180831161042c57829003601f168201915b5050505050905090565b600033610461818585610d23565b5060019392505050565b6000610478848484610e47565b60006104848533610ce9565b905060001981146104a3576104a3853361049e8685611e9d565b610d23565b506001949350505050565b3360008181526001602090815260408083206001600160a01b0387168452909152812054909190610461908290869061049e908790611e85565b600c546001600160a01b0316331461051b5760405162461bcd60e51b815260040161051290611e66565b60405180910390fd5b6002546001600160ff1b03908201116105f55761053782610942565b15801561055a57506001600160a01b038216600090815260096020526040902054155b80156105665750600081115b15610595576001600160a01b0382166000818152600a6020526040902080546001600160a01b03191690911790555b61059f828261100f565b6001600160a01b038083166000908152600a60205260408120546105c49216836110e8565b6040518181526001600160a01b03831690600090600080516020611f32833981519152906020015b60405180910390a35b5050565b604080518082018252600080825260209182018190526001600160a01b0394909416845260088152818420928452918252918290208251808401909352805463ffffffff168352600101549082015290565b60007f8cad95687ba82c2ce50e74f7b754645e5117c3a5bec8151c0726d5857980a866600660405161067d9190611cf1565b604051908190038120610697929146903090602001611da8565b60408051808303601f1901815282825280516020918201207f1ac861a6a8532f3704e1768564a53a32774f00d6cf20ccbbdf60ab61378302bc828501526001600160a01b038a16848401526060840189905260808085018990528351808603909101815260a085019093528251929091019190912090925090600090610723908490849060c001611d8d565b604051602081830303815290604052805190602001209050600061077f86868080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525086939250506111ca9050565b90506001600160a01b0381166107a75760405162461bcd60e51b815260040161051290611e42565b6001600160a01b0381166000908152600b6020526040902080546001810190915588146107ff5760405162461bcd60e51b8152602060048201526006602482015265216e6f6e636560d01b6044820152606401610512565b86158061080b57504287105b6108275760405162461bcd60e51b815260040161051290611e21565b610831818a6111ee565b505050505050505050565b600554610100900460ff166108575760055460ff161561085f565b61085f6112c0565b6108c25760405162461bcd60e51b815260206004820152602e60248201527f496e697469616c697a61626c653a20636f6e747261637420697320616c72656160448201526d191e481a5b9a5d1a585b1a5e995960921b6064820152608401610512565b600554610100900460ff161580156108e4576005805461ffff19166101011790555b600c80546001600160a01b03191633179055825161090990600690602086019061194c565b50815161091d90600790602085019061194c565b508015610930576005805461ff00191690555b505050565b61093f33826111ee565b50565b6001600160a01b031660009081526020819052604090205490565b6060600780546103d090611eb4565b600c546001600160a01b031633146109965760405162461bcd60e51b815260040161051290611e66565b6109a082826112d1565b6001600160a01b038083166000908152600a60205260408120546109c6921690836110e8565b6040518181526000906001600160a01b03841690600080516020611f32833981519152906020016105ec565b60007f8cad95687ba82c2ce50e74f7b754645e5117c3a5bec8151c0726d5857980a8666006604051610a249190611cf1565b604051908190038120610a3e929146903090602001611da8565b60408051808303601f1901815282825280516020918201206001600160a01b038b81166000818152600b85528581208054600181019091557f5fae9ec55a1e547936e0e74d606b44cd5f912f9adcd0bba561fea62d570259e995880195909552948601528a1660608501526080840189905260a084019190915260c0830187905292509060e00160405160208183030381529060405280519060200120905060008282604051602001610af2929190611d8d565b6040516020818303038152906040528051906020012090506000610b4e86868080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525086939250506111ca9050565b90506001600160a01b038116610b765760405162461bcd60e51b815260040161051290611e42565b896001600160a01b0316816001600160a01b031614610bc55760405162461bcd60e51b815260206004820152600b60248201526a08585d5d1a1bdc9a5e995960aa1b6044820152606401610512565b50505083421115610be85760405162461bcd60e51b815260040161051290611e21565b610bf3878787610d23565b856001600160a01b0316876001600160a01b03167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b92587604051610c3891815260200190565b60405180910390a350505050505050565b3360008181526001602090815260408083206001600160a01b038716845290915281205490919083811015610cce5760405162461bcd60e51b815260206004820152602560248201527f45524332303a2064656372656173656420616c6c6f77616e63652062656c6f77604482015264207a65726f60d81b6064820152608401610512565b6104a38286868403610d23565b600033610461818585610e47565b6001600160a01b03918216600090815260016020908152604080832093909416825291909152205490565b6001600160a01b03163b151590565b6001600160a01b038316610d855760405162461bcd60e51b8152602060048201526024808201527f45524332303a20617070726f76652066726f6d20746865207a65726f206164646044820152637265737360e01b6064820152608401610512565b6001600160a01b038216610de65760405162461bcd60e51b815260206004820152602260248201527f45524332303a20617070726f766520746f20746865207a65726f206164647265604482015261737360f01b6064820152608401610512565b6001600160a01b0383811660008181526001602090815260408083209487168084529482529182902085905590518481527f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925910160405180910390a3505050565b6001600160a01b038316610eab5760405162461bcd60e51b815260206004820152602560248201527f45524332303a207472616e736665722066726f6d20746865207a65726f206164604482015264647265737360d81b6064820152608401610512565b6001600160a01b038216610f0d5760405162461bcd60e51b815260206004820152602360248201527f45524332303a207472616e7366657220746f20746865207a65726f206164647260448201526265737360e81b6064820152608401610512565b610f18838383611419565b6001600160a01b03831660009081526020819052604090205481811015610f905760405162461bcd60e51b815260206004820152602660248201527f45524332303a207472616e7366657220616d6f756e7420657863656564732062604482015265616c616e636560d01b6064820152608401610512565b6001600160a01b03808516600090815260208190526040808220858503905591851681529081208054849290610fc7908490611e85565b92505081905550826001600160a01b0316846001600160a01b0316600080516020611f328339815191528460405161100191815260200190565b60405180910390a350505050565b6001600160a01b0382166110655760405162461bcd60e51b815260206004820152601f60248201527f45524332303a206d696e7420746f20746865207a65726f2061646472657373006044820152606401610512565b61107160008383611419565b80600260008282546110839190611e85565b90915550506001600160a01b038216600090815260208190526040812080548392906110b0908490611e85565b90915550506040518181526001600160a01b03831690600090600080516020611f328339815191529060200160405180910390a35050565b816001600160a01b0316836001600160a01b03161415801561110957508015155b15610930576001600160a01b0383161561116a576001600160a01b0383166000908152600960205260408120549081611143576000611155565b61115085600184036105f9565b602001515b905082810361116686848484611517565b5050505b6001600160a01b03821615610930576001600160a01b038216600090815260096020526040812054908161119f5760006111b1565b6111ac84600184036105f9565b602001515b90508281016111c285848484611517565b505050505050565b60008060006111d9858561160a565b915091506111e68161167a565b509392505050565b60006111f983610942565b116112305760405162461bcd60e51b81526020600482015260076024820152662173686172657360c81b6044820152606401610512565b6001600160a01b038083166000908152600a6020526040902080548383166001600160a01b031982161790915516611271818361126c86610942565b6110e8565b816001600160a01b0316816001600160a01b0316846001600160a01b03167f3134e8a2e6d97e929a7e54011ea5485d7d196dd5f0ba4d4ef95803e8e3fc257f60405160405180910390a4505050565b60006112cb30610d14565b15905090565b6001600160a01b0382166113315760405162461bcd60e51b815260206004820152602160248201527f45524332303a206275726e2066726f6d20746865207a65726f206164647265736044820152607360f81b6064820152608401610512565b61133d82600083611419565b6001600160a01b038216600090815260208190526040902054818110156113b15760405162461bcd60e51b815260206004820152602260248201527f45524332303a206275726e20616d6f756e7420657863656564732062616c616e604482015261636560f01b6064820152608401610512565b6001600160a01b03831660009081526020819052604081208383039055600280548492906113e0908490611e9d565b90915550506040518281526000906001600160a01b03851690600080516020611f328339815191529060200160405180910390a3505050565b6001600160a01b038316158061144b5750600c546001600160a01b03163314801561144b57506001600160a01b038216155b806114db5750600c60009054906101000a90046001600160a01b03166001600160a01b0316631c97cf3f6040518163ffffffff1660e01b8152600401602060405180830381600087803b1580156114a157600080fd5b505af11580156114b5573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906114d99190611c6b565b155b6109305760405162461bcd60e51b815260206004820152600d60248201526c217472616e7366657261626c6560981b6044820152606401610512565b42831580159061153f57508063ffffffff1661153686600187036105f9565b5163ffffffff16145b1561155b578161155286600187036105f9565b602001526115bf565b60408051808201825263ffffffff838116825260208083018681526001600160a01b038a166000818152600884528681208b825284528681209551865463ffffffff1916951694909417855590516001948501558252600990529190912090850190555b60408051848152602081018490526001600160a01b038716917fdec2bacdd2f05b59de34da9b523dff8be42e5e38e818c82fdb0bae774387a724910160405180910390a25050505050565b6000808251604114156116415760208301516040840151606085015160001a61163587828585611830565b94509450505050611673565b82516040141561166b5760208301516040840151611660868383611913565b935093505050611673565b506000905060025b9250929050565b600081600481111561168e5761168e611f05565b14156116975750565b60018160048111156116ab576116ab611f05565b14156116f45760405162461bcd60e51b815260206004820152601860248201527745434453413a20696e76616c6964207369676e617475726560401b6044820152606401610512565b600281600481111561170857611708611f05565b14156117565760405162461bcd60e51b815260206004820152601f60248201527f45434453413a20696e76616c6964207369676e6174757265206c656e677468006044820152606401610512565b600381600481111561176a5761176a611f05565b14156117c35760405162461bcd60e51b815260206004820152602260248201527f45434453413a20696e76616c6964207369676e6174757265202773272076616c604482015261756560f01b6064820152608401610512565b60048160048111156117d7576117d7611f05565b141561093f5760405162461bcd60e51b815260206004820152602260248201527f45434453413a20696e76616c6964207369676e6174757265202776272076616c604482015261756560f01b6064820152608401610512565b6000806fa2a8918ca85bafe22016d0b997e4df60600160ff1b0383111561185d575060009050600361190a565b8460ff16601b1415801561187557508460ff16601c14155b15611886575060009050600461190a565b6040805160008082526020820180845289905260ff881692820192909252606081018690526080810185905260019060a0016020604051602081039080840390855afa1580156118da573d6000803e3d6000fd5b5050604051601f1901519150506001600160a01b0381166119035760006001925092505061190a565b9150600090505b94509492505050565b6000806001600160ff1b0383168161193060ff86901c601b611e85565b905061193e87828885611830565b935093505050935093915050565b82805461195890611eb4565b90600052602060002090601f01602090048101928261197a57600085556119c0565b82601f1061199357805160ff19168380011785556119c0565b828001600101855582156119c0579182015b828111156119c05782518255916020019190600101906119a5565b506119cc9291506119d0565b5090565b5b808211156119cc57600081556001016119d1565b80356001600160a01b03811681146119fc57600080fd5b919050565b60008083601f840112611a1357600080fd5b50813567ffffffffffffffff811115611a2b57600080fd5b60208301915083602082850101111561167357600080fd5b600082601f830112611a5457600080fd5b813567ffffffffffffffff80821115611a6f57611a6f611f1b565b604051601f8301601f19908116603f01168101908282118183101715611a9757611a97611f1b565b81604052838152866020858801011115611ab057600080fd5b836020870160208301376000602085830101528094505050505092915050565b600060208284031215611ae257600080fd5b611aeb826119e5565b9392505050565b60008060408385031215611b0557600080fd5b611b0e836119e5565b9150611b1c602084016119e5565b90509250929050565b600080600060608486031215611b3a57600080fd5b611b43846119e5565b9250611b51602085016119e5565b9150604084013590509250925092565b60008060008060008060a08789031215611b7a57600080fd5b611b83876119e5565b9550611b91602088016119e5565b94506040870135935060608701359250608087013567ffffffffffffffff811115611bbb57600080fd5b611bc789828a01611a01565b979a9699509497509295939492505050565b60008060408385031215611bec57600080fd5b611bf5836119e5565b946020939093013593505050565b600080600080600060808688031215611c1b57600080fd5b611c24866119e5565b94506020860135935060408601359250606086013567ffffffffffffffff811115611c4e57600080fd5b611c5a88828901611a01565b969995985093965092949392505050565b600060208284031215611c7d57600080fd5b81518015158114611aeb57600080fd5b60008060408385031215611ca057600080fd5b823567ffffffffffffffff80821115611cb857600080fd5b611cc486838701611a43565b93506020850135915080821115611cda57600080fd5b50611ce785828601611a43565b9150509250929050565b600080835481600182811c915080831680611d0d57607f831692505b6020808410821415611d2d57634e487b7160e01b86526022600452602486fd5b818015611d415760018114611d5257611d7f565b60ff19861689528489019650611d7f565b60008a81526020902060005b86811015611d775781548b820152908501908301611d5e565b505084890196505b509498975050505050505050565b61190160f01b81526002810192909252602282015260420190565b938452602084019290925260408301526001600160a01b0316606082015260800190565b600060208083528351808285015260005b81811015611df957858101830151858201604001528201611ddd565b81811115611e0b576000604083870101525b50601f01601f1916929092016040019392505050565b602080825260079082015266195e1c1a5c995960ca1b604082015260600190565b6020808252600a9082015269217369676e61746f727960b01b604082015260600190565b602080825260059082015264042c2eae8d60db1b604082015260600190565b60008219821115611e9857611e98611eef565b500190565b600082821015611eaf57611eaf611eef565b500390565b600181811c90821680611ec857607f821691505b60208210811415611ee957634e487b7160e01b600052602260045260246000fd5b50919050565b634e487b7160e01b600052601160045260246000fd5b634e487b7160e01b600052602160045260246000fd5b634e487b7160e01b600052604160045260246000fdfeddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3efa2646970667358221220fd525273d88acce989ab29109e1045a01914cf5e5db20d02abbd91aee269a58a64736f6c63430008070033";

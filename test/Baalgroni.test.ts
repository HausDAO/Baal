import { ethers } from "hardhat";
import { solidity } from "ethereum-waffle";
import { use, expect } from "chai";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

import {
  BaalgroniShaman,
  BaalgroniSummoner,
  TributeMinion,
  TestERC20,
  Baal,
  Loot,
  CompatibilityFallbackHandler,
  BaalSummoner,
  GnosisSafe,
  Poster,
  Shares,
} from "../src/types";

import { decodeMultiAction, encodeMultiAction } from "../src/util";
import { BigNumber, BigNumberish } from "@ethersproject/bignumber";
import { buildContractCall } from "@gnosis.pm/safe-contracts";
import { MultiSend } from "../src/types/@gnosis.pm/safe-contracts/contracts/libraries/MultiSend";

import { ContractFactory, ContractReceipt, ContractTransaction } from "ethers";
import { ConfigExtender } from "hardhat/types";
import { Test } from "mocha";

import { Address } from "cluster";

use(solidity);

const revertMessages = {
  molochAlreadyInitialized: "Initializable: contract is already initialized",
  molochConstructorSharesCannotBe0: "shares cannot be 0",
  molochConstructorVotingPeriodCannotBe0: "votingPeriod cannot be 0",
  submitProposalExpired: "expired",
  submitProposalOffering: "Baal requires an offering",
  submitProposalVotingPeriod: "!votingPeriod",
  submitProposalArrays: "!array parity",
  submitProposalArrayMax: "array max",
  submitProposalFlag: "!flag",
  sponsorProposalExpired: "expired",
  sponsorProposalSponsor: "!sponsor",
  sponsorProposalExists: "!exist",
  sponsorProposalSponsored: "sponsored",
  submitVoteNotSponsored: "!sponsored",
  submitVoteTimeEnded: "ended",
  submitVoteVoted: "voted",
  submitVoteMember: "!member",
  submitVoteWithSigTimeEnded: "ended",
  submitVoteWithSigVoted: "voted",
  submitVoteWithSigMember: "!member",
  proposalMisnumbered: "!exist",
  unsetGuildTokensLastToken:
    "reverted with panic code 0x32 (Array accessed at an out-of-bounds or negative index)",
  sharesTransferPaused: "!transferable",
  sharesInsufficientBalance:
    "reverted with panic code 0x11 (Arithmetic operation underflowed or overflowed outside of an unchecked block)",
};

const zeroAddress = "0x0000000000000000000000000000000000000000";

async function blockTime() {
  const block = await ethers.provider.getBlock("latest");
  return block.timestamp;
}

async function blockNumber() {
  const block = await ethers.provider.getBlock("latest");
  return block.number;
}

async function moveForwardPeriods(periods: number, extra?: number) {
  const goToTime =
    (await blockTime()) +
    deploymentConfig.VOTING_PERIOD_IN_SECONDS * periods +
    (extra ? extra : 0);
  await ethers.provider.send("evm_mine", [goToTime]);
  return true;
}
const getNewBaalAddresses = async (
  tx: ContractTransaction
): Promise<{ baal: string; loot: string; safe: string }> => {
  const receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  // console.log({logs: receipt.logs})
  let baalSummonAbi = [
    "event SummonBaal(address indexed baal, address indexed loot, address indexed shares, address safe, bool existingSafe)",
  ];
  let iface = new ethers.utils.Interface(baalSummonAbi);
  let log = iface.parseLog(receipt.logs[receipt.logs.length - 1]);
  const { baal, loot, safe } = log.args;
  return { baal, loot, safe };
};

const deploymentConfig = {
  GRACE_PERIOD_IN_SECONDS: 43200,
  VOTING_PERIOD_IN_SECONDS: 432000,
  PROPOSAL_OFFERING: 0,
  SPONSOR_THRESHOLD: 1,
  MIN_RETENTION_PERCENT: 0,
  MIN_STAKING_PERCENT: 0,
  QUORUM_PERCENT: 0,
  TOKEN_NAME: "wrapped ETH",
  TOKEN_SYMBOL: "WETH",
};

const baalgroniConfig = {
  TOKENNAME: "baalgroni",
  TOKENSYMBOL: "bg",
  CORE: "core",
  PROPERTY: "prop",
  ATRIBUTE3: "attr3",
  ATRIBUTE2: "attr2",
  ATRIBUTE1: "attr1",
  ATRIBUTE0: "attr0",
  MOD: "mode",
  IMAGEHASH: "1234",
};

const metadataConfig = {
  CONTENT: '{"name":"test"}',
  TAG: "daohaus.summoner.daoProfile",
};

const abiCoder = ethers.utils.defaultAbiCoder;

const getBaalParams = async function (
  baal: Baal,
  poster: Poster,
  config: {
    PROPOSAL_OFFERING: any;
    GRACE_PERIOD_IN_SECONDS: any;
    VOTING_PERIOD_IN_SECONDS: any;
    QUORUM_PERCENT: any;
    SPONSOR_THRESHOLD: any;
    MIN_RETENTION_PERCENT: any;
    MIN_STAKING_PERCENT: any;
    TOKEN_NAME: any;
    TOKEN_SYMBOL: any;
  },
  adminConfig: [boolean, boolean],
  shamans: [string[], number[]],
  shares: [string[], number[]],
  loots: [string[], number[]]
) {
  const governanceConfig = abiCoder.encode(
    ["uint32", "uint32", "uint256", "uint256", "uint256", "uint256"],
    [
      config.VOTING_PERIOD_IN_SECONDS,
      config.GRACE_PERIOD_IN_SECONDS,
      config.PROPOSAL_OFFERING,
      config.QUORUM_PERCENT,
      config.SPONSOR_THRESHOLD,
      config.MIN_RETENTION_PERCENT,
    ]
  );

  const setAdminConfig = await baal.interface.encodeFunctionData(
    "setAdminConfig",
    adminConfig
  );
  const setGovernanceConfig = await baal.interface.encodeFunctionData(
    "setGovernanceConfig",
    [governanceConfig]
  );
  const setShaman = await baal.interface.encodeFunctionData(
    "setShamans",
    shamans
  );
  const mintShares = await baal.interface.encodeFunctionData(
    "mintShares",
    shares
  );
  const mintLoot = await baal.interface.encodeFunctionData("mintLoot", loots);
  const postMetaData = await poster.interface.encodeFunctionData("post", [
    metadataConfig.CONTENT,
    metadataConfig.TAG,
  ]);
  const posterFromBaal = await baal.interface.encodeFunctionData(
    "executeAsBaal",
    [poster.address, 0, postMetaData]
  );

  const initalizationActions = [
    setAdminConfig,
    setGovernanceConfig,
    setShaman,
    mintShares,
    mintLoot,
    posterFromBaal,
  ];

  return {
    initParams: abiCoder.encode(
      ["string", "string"],
      [config.TOKEN_NAME, config.TOKEN_SYMBOL]
    ),
    initalizationActions,
  };
};
const setShamanProposal = async function (
  baal: Baal,
  multisend: MultiSend,
  shaman: string,
  permission: BigNumberish
) {
  const setShaman = await baal.interface.encodeFunctionData("setShamans", [
    [shaman],
    [permission],
  ]);
  const setShamanAction = encodeMultiAction(
    multisend,
    [setShaman],
    [baal.address],
    [BigNumber.from(0)],
    [0]
  );
  await baal.submitProposal(setShamanAction, 0, 0, "");
  const proposalId = await baal.proposalCount();
  await baal.submitVote(proposalId, true);
  await moveForwardPeriods(2);
  await baal.processProposal(proposalId, setShamanAction);
  return proposalId;
};

describe("Baalgroni type", function () {
  let baal: Baal;
  let lootSingleton: Loot;
  let LootFactory: ContractFactory;
  let sharesSingleton: Shares;
  let SharesFactory: ContractFactory;
  let ERC20: ContractFactory;
  let lootToken: Loot;
  let sharesToken: Shares;
  let shamanLootToken: Loot;
  let shamanBaal: Baal;
  let applicantBaal: Baal;
  let weth: TestERC20;
  let applicantWeth: TestERC20;
  let multisend: MultiSend;
  let poster: Poster;

  let BaalFactory: ContractFactory;
  let baalSingleton: Baal;
  let baalSummoner: BaalSummoner;
  let gnosisSafeSingleton: GnosisSafe;
  let gnosisSafe: GnosisSafe;

  let Poster: ContractFactory;

  // shaman baals, to test permissions
  let s1Baal: Baal;
  let s2Baal: Baal;
  let s3Baal: Baal;
  let s4Baal: Baal;
  let s5Baal: Baal;
  let s6Baal: Baal;

  let applicant: SignerWithAddress;
  let summoner: SignerWithAddress;
  let shaman: SignerWithAddress;
  let s1: SignerWithAddress;
  let s2: SignerWithAddress;
  let s3: SignerWithAddress;
  let s4: SignerWithAddress;
  let s5: SignerWithAddress;
  let s6: SignerWithAddress;

  let proposal: { [key: string]: any };

  let encodedInitParams: any;

  let baalgroni: BaalgroniShaman;
  let baalgroniSummoner: BaalgroniSummoner;
  let baalgroniAddress: string;

  const loot = 500;
  const shares = 100;
  const sharesPaused = false;
  const lootPaused = false;

  const yes = true;
  const no = false;

  this.beforeAll(async function () {
    LootFactory = await ethers.getContractFactory("Loot");
    lootSingleton = (await LootFactory.deploy()) as Loot;
    SharesFactory = await ethers.getContractFactory("Shares");
    sharesSingleton = (await SharesFactory.deploy()) as Shares;
    BaalFactory = await ethers.getContractFactory("Baal");
    baalSingleton = (await BaalFactory.deploy()) as Baal;
    Poster = await ethers.getContractFactory("Poster");
    poster = (await Poster.deploy()) as Poster;
  });

  beforeEach(async function () {
    const GnosisSafe = await ethers.getContractFactory("GnosisSafe");
    const BaalSummoner = await ethers.getContractFactory("BaalSummoner");
    const CompatibilityFallbackHandler = await ethers.getContractFactory(
      "CompatibilityFallbackHandler"
    );
    const BaalContract = await ethers.getContractFactory("Baal");
    const MultisendContract = await ethers.getContractFactory("MultiSend");
    const GnosisSafeProxyFactory = await ethers.getContractFactory(
      "GnosisSafeProxyFactory"
    );
    const ModuleProxyFactory = await ethers.getContractFactory(
      "ModuleProxyFactory"
    );
    [summoner, applicant, shaman, s1, s2, s3, s4, s5, s6] =
      await ethers.getSigners();

    ERC20 = await ethers.getContractFactory("TestERC20");
    weth = (await ERC20.deploy("WETH", "WETH", 10000000)) as TestERC20;
    applicantWeth = weth.connect(applicant);

    await weth.transfer(applicant.address, 1000);

    multisend = (await MultisendContract.deploy()) as MultiSend;
    gnosisSafeSingleton = (await GnosisSafe.deploy()) as GnosisSafe;
    const handler =
      (await CompatibilityFallbackHandler.deploy()) as CompatibilityFallbackHandler;
    const proxy = await GnosisSafeProxyFactory.deploy();
    const moduleProxyFactory = await ModuleProxyFactory.deploy();

    const BaalgroniShamanContract = await ethers.getContractFactory(
      "BaalgroniShaman"
    );
    baalgroni = (await BaalgroniShamanContract.deploy()) as BaalgroniShaman;

    console.log("baalgroni template addr", baalgroni.address);

    const BaalgroniShamanSummonerContract = await ethers.getContractFactory(
      "BaalgroniSummoner"
    );
    baalgroniSummoner = (await BaalgroniShamanSummonerContract.deploy(
      baalgroni.address
    )) as BaalgroniSummoner;

    console.log("baalgroniSummoner addr", baalgroniSummoner.address);

    baalSummoner = (await BaalSummoner.deploy(
      baalSingleton.address,
      gnosisSafeSingleton.address,
      handler.address,
      multisend.address,
      proxy.address,
      moduleProxyFactory.address,
      lootSingleton.address,
      sharesSingleton.address
    )) as BaalSummoner;

    console.log("baalSummoner addr", baalSummoner.address);

    encodedInitParams = await getBaalParams(
      baalSingleton,
      poster,
      deploymentConfig,
      [sharesPaused, lootPaused],
      [[shaman.address], [7]],
      [
        [summoner.address, applicant.address],
        [shares, shares],
      ],
      [
        [summoner.address, applicant.address],
        [loot, loot],
      ]
    );
    const tx = await baalSummoner.summonBaalAndSafe(
      encodedInitParams.initParams,
      encodedInitParams.initalizationActions,
      101
    );
    const addresses = await getNewBaalAddresses(tx);
    console.log("addresses", addresses);

    baal = BaalFactory.attach(addresses.baal) as Baal;
    gnosisSafe = BaalFactory.attach(addresses.safe) as GnosisSafe;
    shamanBaal = baal.connect(shaman); // needed to send txns to baal as the shaman
    applicantBaal = baal.connect(applicant); // needed to send txns to baal as the shaman
    s1Baal = baal.connect(s1);
    s2Baal = baal.connect(s2);
    s3Baal = baal.connect(s3);
    s4Baal = baal.connect(s4);
    s5Baal = baal.connect(s5);
    s6Baal = baal.connect(s6);

    const lootTokenAddress = await baal.lootToken();

    lootToken = LootFactory.attach(lootTokenAddress) as Loot;
    shamanLootToken = lootToken.connect(shaman);

    const sharesTokenAddress = await baal.sharesToken();

    sharesToken = SharesFactory.attach(sharesTokenAddress) as Shares;
    shamanLootToken = lootToken.connect(shaman);

    const selfTransferAction = encodeMultiAction(
      multisend,
      ["0x"],
      [baal.address],
      [BigNumber.from(0)],
      [0]
    );

    proposal = {
      flag: 0,
      account: applicant.address,
      data: selfTransferAction,
      details: "all hail baal",
      expiration: 0,
    };

    const bconfig = abiCoder.encode(
      [
        "string",
        "string",
        "string",
        "string",
        "string",
        "string",
        "string",
        "string",
        "string",
        "string",
      ],
      [
        baalgroniConfig.TOKENNAME,
        baalgroniConfig.TOKENSYMBOL,
        baalgroniConfig.CORE,
        baalgroniConfig.PROPERTY,
        baalgroniConfig.ATRIBUTE3,
        baalgroniConfig.ATRIBUTE2,
        baalgroniConfig.ATRIBUTE1,
        baalgroniConfig.ATRIBUTE0,
        baalgroniConfig.MOD,
        baalgroniConfig.IMAGEHASH,
      ]
    );

    console.log("init params", bconfig);

    let summonBaalgroni;
    summonBaalgroni = await baalgroniSummoner.summonBaalgroni(
      baal.address, // baal
      weth.address, // wrapper
      ethers.utils.parseEther("1.0"), // price per unit
      200,
      100,
      3,
      bconfig
    );
    // console.log(summoner);

    let result = await summonBaalgroni.wait();
    if (
      result &&
      result.events &&
      result.events[1] &&
      result.events[1].args &&
      result.events[1].args.baalgroni
    ) {
      console.log("baalgroni event", result.events[1].args.baalgroni);
      baalgroniAddress = result.events[1].args.baalgroni;
    }
  });

  describe.only("baalgroni tribute", function () {
    it("allows external address to mint NFT with funds and get loot", async function () {
      const bgroni = baalgroni.attach(baalgroniAddress);

      const applicantBaalgroni = bgroni.connect(applicant);

      const id = await setShamanProposal(baal, multisend, baalgroniAddress, 7);
      const propStatus = await baal.getProposalStatus(id);

      console.log("propStatus", propStatus);

      console.log("receiver eth before", await applicant.getBalance());
      console.log(
        "receiver loot before",
        await lootToken.balanceOf(applicant.address)
      );
      console.log(
        "factory loot before",
        await lootToken.balanceOf(bgroni.factory())
      );
      console.log(
        "safe weth before ",
        await weth.balanceOf(gnosisSafe.address)
      );
      console.log("baal total before", await baal.totalSupply());
      console.log("baal total loot before", await baal.totalLoot());
      console.log(
        "safe weth balance before",
        await weth.balanceOf(gnosisSafe.address)
      );

      await applicantBaalgroni.mint(applicant.address, {
        value: ethers.utils.parseEther("1.0"),
      });

      console.log("receiver eth after", await applicant.getBalance());
      console.log(
        "receiver nft after",
        await bgroni.balanceOf(applicant.address)
      );
      console.log(
        "receiver loot after",
        await lootToken.balanceOf(applicant.address)
      );
      console.log(
        "factory loot after",
        await lootToken.balanceOf(baalgroniSummoner.address)
      );
      console.log("baal total after", await baal.totalSupply());
      console.log("baal total loot after", await baal.totalLoot());
      console.log(
        "safe new balance after",
        await weth.balanceOf(gnosisSafe.address)
      );

      await applicantBaalgroni.bind(1);

      console.log(
        "receiver loot after bind",
        await lootToken.balanceOf(applicant.address)
      );

      console.log("uri", await bgroni.tokenURI(1));

      await applicantBaalgroni.unbind(1);

      console.log(
        "receiver loot after unbind",
        await lootToken.balanceOf(applicant.address)
      );
    });
    it("allows external address to mint, bind and ragequit and fail to unbind", async function () {
      const bgroni = baalgroni.attach(baalgroniAddress);

      const applicantBaalgroni = bgroni.connect(applicant);

      const id = await setShamanProposal(baal, multisend, baalgroniAddress, 7);
      const propStatus = await baal.getProposalStatus(id);

      console.log("propStatus", propStatus);

      console.log("receiver eth before", await applicant.getBalance());
      console.log(
        "receiver loot before",
        await lootToken.balanceOf(applicant.address)
      );
      console.log(
        "factory loot before",
        await lootToken.balanceOf(bgroni.factory())
      );
      console.log(
        "safe weth before ",
        await weth.balanceOf(gnosisSafe.address)
      );
      console.log("baal total before", await baal.totalSupply());
      console.log("baal total loot before", await baal.totalLoot());
      console.log(
        "safe weth balance before",
        await weth.balanceOf(gnosisSafe.address)
      );

      await applicantBaalgroni.mint(applicant.address, {
        value: ethers.utils.parseEther("1.0"),
      });

      console.log("receiver eth after", await applicant.getBalance());
      console.log(
        "receiver nft after",
        await bgroni.balanceOf(applicant.address)
      );
      console.log(
        "receiver loot after",
        await lootToken.balanceOf(applicant.address)
      );
      console.log(
        "factory loot after",
        await lootToken.balanceOf(baalgroniSummoner.address)
      );
      console.log("baal total after", await baal.totalSupply());
      console.log("baal total loot after", await baal.totalLoot());
      console.log(
        "safe new balance after",
        await weth.balanceOf(gnosisSafe.address)
      );

      await applicantBaalgroni.bind(1);

      const applicantLoot = await lootToken.balanceOf(applicant.address);

      console.log("receiver loot after bind", applicantLoot);

      console.log("uri", await bgroni.tokenURI(1));

      await applicantBaal.ragequit(applicant.address, 0, applicantLoot, [
        weth.address,
      ]);

      console.log(
        "receiver loot after ragequit",
        await lootToken.balanceOf(applicant.address)
      );

      // could unbind if has loot
      // await applicantBaalgroni.mint(applicant.address, {
      //   value: ethers.utils.parseEther("1.0"),
      // });

      // await applicantBaalgroni.bind(2);

      await expect(applicantBaalgroni.unbind(1)).to.be.revertedWith(
        `OnlyLootHolderCanUnbind`
      );
    });
  });
});

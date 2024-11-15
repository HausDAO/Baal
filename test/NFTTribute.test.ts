import { expect } from 'chai';
import { BigNumber } from 'ethers';
import { ethers } from 'hardhat';

import {
  DAOSettings,
  defaultDAOSettings,
  defaultProposalSettings,
  revertMessages,
} from './utils/baal';
import { moveForwardPeriods } from './utils/evm';
import { baalSetup, ProposalHelpers, Signer } from './utils/fixtures';
import {
  Baal,
  TestERC20,
  TestNFT,
  TributeMinion,
  NFTTributeMinion,
  Loot,
  MultiSend,
  BaalSummoner,
  GnosisSafe,
  Shares,
} from '../src/types';
import { encodeMultiAction } from '../src/util';

describe("Tribute proposal type", function () {
  let baal: Baal;
  let lootToken: Loot;
  let sharesToken: Shares;
  let testNFT: TestNFT;
  let multisend: MultiSend;

  let baalSummoner: BaalSummoner;
  let gnosisSafe: GnosisSafe;

  let nftTributeMinion: NFTTributeMinion;
  let tributeMinion: TributeMinion;

  let users: {
    [key: string]: Signer;
  };

  const yes = true;
  const no = false;

  let proposalHelpers: ProposalHelpers;

  beforeEach(async () => {
    const {
      Baal,
      Loot,
      Shares,
      BaalSummoner,
      GnosisSafe,
      MultiSend,
      NFTTributeMinion,
      TributeMinion,
      WETH,
      TestNFT,
      signers,
      helpers,
    } = await baalSetup({});

    baal = Baal;
    lootToken = Loot;
    sharesToken = Shares;
    baalSummoner = BaalSummoner;
    gnosisSafe = GnosisSafe;
    multisend = MultiSend;
    testNFT = TestNFT;
    // poster = Poster;
    tributeMinion = TributeMinion;
    nftTributeMinion = NFTTributeMinion
    users = signers;

    proposalHelpers = helpers;
  });

  describe("Dangerous proposal tribute", () => {
    const tribute = 1;
    const requestedShares = 100;

    it("Allows applicant to tribute an NFT in exchange for shares", async () => {
      await users.applicant.testNft?.approve(gnosisSafe.address, tribute);


      const currentShares = await sharesToken.balanceOf(users.applicant.address);

      const mintShares = baal.interface.encodeFunctionData("mintShares", [
        [users.applicant.address],
        [requestedShares],
      ]);
      const sendTribute = testNFT.interface.encodeFunctionData(
        "transferFrom",
        [users.applicant.address, gnosisSafe.address, tribute]
      );

      const encodedProposal = encodeMultiAction(
        multisend,
        [mintShares, sendTribute],
        [baal.address, testNFT.address],
        [BigNumber.from(0), BigNumber.from(0)],
        [0, 0]
      );

      await users.applicant.baal?.submitProposal(
        encodedProposal,
        defaultProposalSettings.EXPIRATION,
        defaultProposalSettings.BAAL_GAS,
        ethers.utils.id(defaultProposalSettings.DETAILS),
        { value: defaultDAOSettings.PROPOSAL_OFFERING }
      );
      await baal.submitVote(1, yes);
      await moveForwardPeriods(defaultDAOSettings.VOTING_PERIOD_IN_SECONDS, 2);
      await baal.processProposal(1, encodedProposal);

      expect(await testNFT.balanceOf(gnosisSafe.address)).to.equal(1);
      expect(await sharesToken.balanceOf(users.applicant.address)).to.equal(
        currentShares.add(requestedShares) // current shares plus new shares
      );
    });

    it("EXPLOIT - Allows another proposal to spend tokens intended for tribute", async () => {
      await users.applicant.testNft?.approve(gnosisSafe.address, tribute);
      const currentShares = await sharesToken.balanceOf(users.applicant.address);

      const mintShares = baal.interface.encodeFunctionData("mintShares", [
        [users.applicant.address],
        [requestedShares],
      ]);
      const sendTribute = testNFT.interface.encodeFunctionData(
        "transferFrom",
        [users.applicant.address, gnosisSafe.address, tribute]
      );

      const encodedProposal = encodeMultiAction(
        multisend,
        [mintShares, sendTribute],
        [baal.address, testNFT.address],
        [BigNumber.from(0), BigNumber.from(0)],
        [0, 0]
      );
      const maliciousProposal = encodeMultiAction(
        multisend,
        [sendTribute],
        [testNFT.address],
        [BigNumber.from(0)],
        [0]
      );

      await users.applicant.baal?.submitProposal(
        encodedProposal,
        defaultProposalSettings.EXPIRATION,
        defaultProposalSettings.BAAL_GAS,
        ethers.utils.id(defaultProposalSettings.DETAILS),
        { value: defaultDAOSettings.PROPOSAL_OFFERING }
      );
      await users.applicant.baal?.submitProposal(
        maliciousProposal,
        defaultProposalSettings.EXPIRATION,
        defaultProposalSettings.BAAL_GAS,
        ethers.utils.id(defaultProposalSettings.DETAILS),
        { value: defaultDAOSettings.PROPOSAL_OFFERING }
      );
      await baal.submitVote(1, no);
      await baal.submitVote(2, yes);
      await moveForwardPeriods(defaultDAOSettings.VOTING_PERIOD_IN_SECONDS, 2);
      // await baal.processProposal(1, encodedProposal)
      await baal.processProposal(2, maliciousProposal);
      expect(await testNFT.balanceOf(gnosisSafe.address)).to.equal(1);
      expect(await testNFT.balanceOf(users.applicant.address)).to.equal(0);
      expect(await sharesToken.balanceOf(users.applicant.address)).to.equal(currentShares); // only current shares no new ones
    });
  });

  describe("Baal with NO proposal offering - Safe Tribute Proposal", () => {

    const tribute = 1;
    const requestedShares = 1234;
    const requestedLoot = 1007;

    it("allows external nft tribute minion to submit share proposal in exchange for and NFT", async () => {
      expect(await testNFT.balanceOf(gnosisSafe.address)).to.equal(0);
      expect(await testNFT.balanceOf(users.applicant.address)).to.equal(1);

      await users.applicant.testNft?.approve(nftTributeMinion.address, tribute);

      const currentShares = await sharesToken.balanceOf(users.applicant.address);

      users.applicant.nftTributeMinion && await proposalHelpers.submitAndProcessNFTTributeProposal({
        tributeMinion: users.applicant.nftTributeMinion,
        baal,
        applicantAddress: users.applicant.address,
        tributeToken: testNFT.address,
        tribute,
        requestedShares,
        requestedLoot,
      });

      expect(await sharesToken.balanceOf(users.applicant.address)).to.equal(
        requestedShares + parseInt(currentShares.toString())
      );
      expect(await testNFT.balanceOf(gnosisSafe.address)).to.equal(1);
      expect(await testNFT.balanceOf(users.applicant.address)).to.equal(0);
    });
  });

  describe("Baal with proposal offering - Safe Tribute Proposal", function () {
    let daoConfig: Partial<DAOSettings>;
    let baal: Baal;
    let gnosisSafe: GnosisSafe;
    let sharesToken: Shares;
    let tributeMinion: NFTTributeMinion;

    const tribute = 1;
    const requestedShares = 1234;
    const requestedLoot = 1007;

    this.beforeEach(async function () {
      daoConfig = {
        PROPOSAL_OFFERING: 69,
        SPONSOR_THRESHOLD: 101,
      };
      const {
        Baal,
        Shares,
        GnosisSafe,
        NFTTributeMinion,
      } = await baalSetup({
        daoSettings: daoConfig,
      });
      baal = Baal;
      gnosisSafe = GnosisSafe;
      sharesToken = Shares;
      tributeMinion = NFTTributeMinion;
    });

    it("allows external tribute minion to submit share proposal in exchange for an NFT", async () => {
      expect(await testNFT.balanceOf(gnosisSafe.address)).to.equal(0);
      expect(await testNFT.balanceOf(users.applicant.address)).to.equal(1);

      await users.applicant.testNft?.approve(tributeMinion.address, 1);

      const currentShares = await sharesToken.balanceOf(users.applicant.address);

      users.applicant.nftTributeMinion && await proposalHelpers.submitAndProcessNFTTributeProposal({
        tributeMinion: users.applicant.nftTributeMinion,
        baal,
        applicantAddress: users.applicant.address,
        tributeToken: testNFT.address,
        tribute,
        requestedShares,
        requestedLoot,
        proposalOffering: daoConfig.PROPOSAL_OFFERING
      });

      expect(await sharesToken.balanceOf(users.applicant.address)).to.equal(
        requestedShares + parseInt(currentShares.toString())
      );
      expect(await testNFT.balanceOf(gnosisSafe.address)).to.equal(1);
      expect(await testNFT.balanceOf(users.applicant.address)).to.equal(0);
    });

    it("fails to tribute without offering", async () => {
      const currentShares = await sharesToken.balanceOf(users.applicant.address);
      // CONDITION: Member should send tribute if shares < SPONSOR_THRESHOLD
      expect(currentShares.lt(BigNumber.from(daoConfig.SPONSOR_THRESHOLD)));

      expect(await testNFT.balanceOf(gnosisSafe.address)).to.equal(0);
      expect(await testNFT.balanceOf(users.applicant.address)).to.equal(1);

      await users.applicant.testNft?.approve(tributeMinion.address, 1);

      users.applicant.nftTributeMinion && await expect(users.applicant.nftTributeMinion.submitTributeProposal(
        baal.address,
        testNFT.address,
        tribute,
        requestedShares,
        requestedLoot,
        defaultProposalSettings.EXPIRATION,
        defaultProposalSettings.BAAL_GAS,
        "tribute"
      )).to.be.revertedWith(revertMessages.submitProposalOffering);   
    });
  });
});

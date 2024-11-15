import { DAOSettings, defaultDAOSettings } from './baal';
import { moveForwardPeriods } from './evm';
import { Baal, NFTTributeMinion } from '../../src/types';
import { BigNumber } from 'ethers';

const yes = true;

export type NFTTributeProposalParams = {
    tributeMinion: NFTTributeMinion,
    baal: Baal,
    applicantAddress: string,
    tributeToken: string,
    tribute: number,
    requestedShares: number,
    requestedLoot: number,
    sponsor?: boolean;
    proposalId?: number;
    proposalOffering?: number;
    proposalExpiration?: number;
    proposalBaalGas?: number;
    daoSettings?: DAOSettings;
    extraSeconds?: number;
};

export type NFTTributeProposalStatus = {
    spentInGas: BigNumber;
    state: number;
    propStatus: [boolean, boolean, boolean, boolean];
};

export const submitAndProcessNFTTributeProposal = async ({
    tributeMinion,
    baal,
    applicantAddress,
    tributeToken,
    tribute,
    requestedShares,
    requestedLoot,
    sponsor = true,
    proposalId = 1,
    proposalOffering = 0,
    proposalExpiration = 0,
    proposalBaalGas = 0,
    daoSettings = defaultDAOSettings,
    extraSeconds = 2,
}: NFTTributeProposalParams): Promise<NFTTributeProposalStatus> => {

    const tx_1 = await tributeMinion.submitTributeProposal(
        baal.address,
        tributeToken,
        tribute,
        requestedShares,
        requestedLoot,
        proposalExpiration,
        proposalBaalGas,
        "tribute",
        { value: proposalOffering },
    );
    const tx_1_r = await tx_1.wait();
    const tx_2 = sponsor ? await baal.sponsorProposal(proposalId) : undefined;
    const tx_2_r = tx_2 ? await tx_2.wait() : undefined;
    const tx_3 = await baal.submitVote(proposalId, yes);
    const tx_3_r = await tx_3.wait();
    await moveForwardPeriods(daoSettings.VOTING_PERIOD_IN_SECONDS, extraSeconds);

    const encodedProposal = await tributeMinion.encodeTributeProposal(
        baal.address,
        requestedShares,
        requestedLoot,
        applicantAddress,
        proposalId,
        tributeMinion.address,
    );

    const tx_4 = await baal.processProposal(proposalId, encodedProposal);
    const tx_4_r = await tx_4.wait();

    const state = await baal.state(proposalId);
    const propStatus = await baal.getProposalStatus(proposalId);
    
    return {
        spentInGas: tx_1_r.gasUsed.mul(tx_1_r.effectiveGasPrice)
            .add(tx_2_r ? tx_2_r.gasUsed.mul(tx_2_r.effectiveGasPrice) : BigNumber.from(0))
            .add(tx_3_r.gasUsed.mul(tx_3_r.effectiveGasPrice))
            .add(tx_4_r.gasUsed.mul(tx_4_r.effectiveGasPrice)),
        state,
        propStatus,
    };
};

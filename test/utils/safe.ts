import { ethers } from "hardhat";

import { GnosisSafeProxyFactory } from "../../src/types";

export const getSaltNonce = (length = 24) => {
  let text = '';
  const possible = '0123456789';
  for (let i = 0; i < length; i++) {
    text += possible.charAt(Math.floor(Math.random() * possible.length));
  }
  return text;
};

const getSafeAddressFromRevertMessage = (e: any): string => {
  if (e.error.data) {
    return ethers.utils.getAddress(e.error.data.slice(138, 178));
  }
  const messages: string[] = e.error.split(' ');
  return messages.find((m) => m.match(/^0x[a-fA-F0-9]{40,44}$/))?.replace(',', '') ?? ethers.constants.AddressZero;
};

export const calculateSafeProxyAddress = async ({
  gnosisSafeProxyFactory,
  initializer = "0x",
  masterCopyAddress,
  saltNonce,
} : {
  gnosisSafeProxyFactory: GnosisSafeProxyFactory;
  initializer?: string;
  masterCopyAddress: string;
  saltNonce: string;
}) => {
  
  const signer = await ethers.getSigner(gnosisSafeProxyFactory.address);

  let expectedSafeAddress = ethers.constants.AddressZero;
  try {
    await gnosisSafeProxyFactory.connect(signer).estimateGas.calculateCreateProxyWithNonceAddress(
      masterCopyAddress,
      initializer,
      saltNonce,
      { from: gnosisSafeProxyFactory.address }
    );
  } catch (e: unknown) {
    expectedSafeAddress = getSafeAddressFromRevertMessage(e);
  } finally {
    return expectedSafeAddress;
  }
};

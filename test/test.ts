import "@nomiclabs/hardhat-ethers";
import { ethers } from "hardhat";
import { Signer, BigNumber as BN } from "ethers";
import * as chai from "chai";
import { expect } from "chai";
import { CryptoGogos } from "../typechain/CryptoGogos";
import { solidity } from "ethereum-waffle";
chai.use(solidity);

describe("Test Token Converting", function () {
  let owner: Signer, account1: Signer, account2: Signer, account3: Signer;
  let cryptoGogo: CryptoGogos;

  beforeEach(async function () {
    [owner, account1, account2, account3] = await ethers.getSigners();
    const cryptoGogoFactory = await ethers.getContractFactory("CryptoGogos");
    cryptoGogo = (await cryptoGogoFactory.deploy("https://api.cryptogogos.com/api/metadata/")) as CryptoGogos;
  });
  it("Contracts deployed successfully", async function () {
    expect(await cryptoGogo.name()).to.equal("GOGOS");
  });
  
});

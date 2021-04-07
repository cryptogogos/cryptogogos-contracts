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
    cryptoGogo = (await cryptoGogoFactory.deploy()) as CryptoGogos;
  });
  it("Contracts deployed successfully", async function () {
    expect(await cryptoGogo.name()).to.equal("GOGOS");
  });
  it("Mint succeed", async function () {
    const minterAdd = await account1.getAddress();
    for (let i = 1; i <= 2; i++) {
      await cryptoGogo.connect(account1).mint(`https://test.com/add/${i}`, {
        value: await cryptoGogo.getNFTPrice(),
      });
    }
    expect(await cryptoGogo.ownerOf(1)).to.equal(minterAdd);
    expect(await cryptoGogo.ownerOf(2)).to.equal(minterAdd);
  });
  it("Mint succeed by admin", async function () {
    const ownerAdd = await owner.getAddress();
    for (let i = 1; i <= 100; i++) {
      await cryptoGogo.mintByAdmin(ownerAdd, `https://test.com/add/${i}`);
    }
    expect(await cryptoGogo.ownerOf(1)).to.equal(ownerAdd);
    expect(await cryptoGogo.ownerOf(2)).to.equal(ownerAdd);
  });
  it("Withdarw by admin working", async function () {
    let amount = BN.from(0);
    for (let i = 1; i <= 2; i++) {
      amount = amount.add(await cryptoGogo.getNFTPrice());
      await cryptoGogo.connect(account1).mint(`https://test.com/add/${i}`, {
        value: await cryptoGogo.getNFTPrice(),
      });
    }
    const initialBalance = await owner.getBalance();
    const tx = await cryptoGogo.withdraw({ gasPrice: 100 });
    const block = await ethers.provider.getBlock(tx.blockNumber);
    const afterBalance = await owner.getBalance();
    expect(
      initialBalance.add(amount).eq(afterBalance.add(block.gasUsed.mul(100)))
    ).to.be.true;
  });
  it("Get NFT pack price and mint pack", async function () {
    const ownerAdd = await owner.getAddress();
    const value = await cryptoGogo.getNFTPackPrice();
    await cryptoGogo.mintPack(
      [
        "https://test.com/add/1",
        "https://test.com/add/2",
        "https://test.com/add/3",
      ],
      { value: value }
    );
    expect(await cryptoGogo.ownerOf(1)).to.equal(ownerAdd);
    expect(await cryptoGogo.ownerOf(2)).to.equal(ownerAdd);
    expect(await cryptoGogo.ownerOf(3)).to.equal(ownerAdd);
    expect(await cryptoGogo.tokenURI(1)).to.equal("https://test.com/add/1");
    expect(await cryptoGogo.tokenURI(2)).to.equal("https://test.com/add/2");
    expect(await cryptoGogo.tokenURI(3)).to.equal("https://test.com/add/3");
  });
  it("Mint 3 tokens will not work for first 150 tokens", async function () {
    const minterAdd = await account1.getAddress();
    await cryptoGogo.connect(account1).mint(`https://test.com/add/${1}`, {
      value: await cryptoGogo.getNFTPrice(),
    });
    await cryptoGogo.connect(account1).mint(`https://test.com/add/${2}`, {
      value: await cryptoGogo.getNFTPrice(),
    });
    await expect(
      cryptoGogo.connect(account1).mint(`https://test.com/add/${3}`, {
        value: await cryptoGogo.getNFTPrice(),
      })
    ).to.be.reverted;
    expect(await cryptoGogo.ownerOf(1)).to.equal(minterAdd);
    expect(await cryptoGogo.ownerOf(2)).to.equal(minterAdd);
  });
});

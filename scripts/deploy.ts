import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  const deployerAddress = await deployer.getAddress();
  console.log("Deploying cryptoGogo with address:", deployerAddress);

  const cryptoGogoFactory = await ethers.getContractFactory("CryptoGogos");
  const cryptoGogo = await cryptoGogoFactory.deploy("https://api.cryptogogos.com/api/metadata/");

  await cryptoGogo.deployed();

  console.log("cryptoGogo deployed at", cryptoGogo.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

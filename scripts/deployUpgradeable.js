const hre = require("hardhat");

const constants = require("../constants");

async function main() {
  const [owner, address] = await hre.ethers.getSigners();
  const NftContract = await hre.ethers.getContractFactory(
    "NftContractUpgradeable"
  );

  const nftContract = await upgrades.deployProxy(NftContract, [
    constants.TOKEN_NAME,
    constants.TOKEN_SYMBOL,
    constants.MAX_SUPPLY,
  ]);
  console.log("txHash: ", nftContract.deployTransaction.hash);

  const contractInstance = await nftContract.deployed();

  const contractName = await contractInstance.name();
  const contractSymbol = await contractInstance.symbol();

  console.log(`Contract SimpleNft deployed to ${contractInstance.address}`);
  console.log(
    `Contract SimpleNft has Symbol: ${contractName} and Name: ${contractSymbol}`
  );
  // console.log('Receipt: ', contractInstance.deployTransaction);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

const hre = require("hardhat");

async function main() {
  const NftContract = await hre.ethers.getContractFactory("NftContract");
  const nftContract = await NftContract.deploy("NftContract", "NFT", 0, {
    gasPrice: 20000000000,
  });

  console.log("txHash: ", nftContract.deployTransaction.hash);

  const contractInstance = await nftContract.deployed();

  const contractName = await contractInstance.name();
  const contractSymbol = await contractInstance.symbol();

  console.log(`Contract SimpleNft deployed to ${contractInstance.address}`);
  console.log(
    `Contract NftContract has Symbol: ${contractName} and Name: ${contractSymbol}`
  );
  // console.log('Receipt: ', contractInstance.deployTransaction);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

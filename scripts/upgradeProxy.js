const hre = require("hardhat");

const constants = require("../constants");

async function main() {
  const [owner, address] = await hre.ethers.getSigners();

  const NftContract = await hre.ethers.getContractFactory(
    "NftContractUpgradeable"
  );

  let contractInstance;
  if (hre.network.name === "hardhat" || hre.network.name === "localhost") {
    const nftContract = await upgrades.deployProxy(NftContract, [
      constants.TOKEN_NAME,
      constants.TOKEN_SYMBOL,
      constants.MAX_SUPPLY,
    ]);
    console.log("txHash: ", nftContract.deployTransaction.hash);

    contractInstance = await nftContract.deployed();
  } else {
    const contractAddress = "0x6f63fc5860f550329f5ba069795ee568466b003d";
    console.log("contractAddress: ", contractAddress);
    const formattedAddress = hre.ethers.utils.getAddress(contractAddress);
    console.log("formattedAddress: ", formattedAddress);

    contractInstance = new hre.ethers.Contract(
      formattedAddress,
      NftContract.interface,
      owner
    );
    console.log("contract found at: ", contractInstance.address);
  }

  const contractName = await contractInstance.name();
  const contractSymbol = await contractInstance.symbol();

  console.log(`Contract SimpleNft deployed to ${contractInstance.address}`);
  console.log(
    `Contract SimpleNft has Symbol: ${contractName} and Name: ${contractSymbol}`
  );
  // console.log('Receipt: ', contractInstance.deployTransaction);

  // Before upgrage the contract
  try {
    const whoIsMasterOwner = await contractInstance.whoIsMasterOwner();
    console.log(`This should not happen`, whoIsMasterOwner);
  } catch (error) {
    console.log(`This should happen`);
  }

  // Upgrade the contract

  const SimpleNftV2 = await hre.ethers.getContractFactory(
    "SimpleNftUpgradeableV2"
  );
  contractInstance = await upgrades.upgradeProxy(
    contractInstance.address,
    SimpleNftV2
  );

  console.log(`Contract SimpleNft upgraded to ${contractInstance.address}`);

  await contractInstance.setMasterOwner("Bob");

  const whoIsMasterOwner = await contractInstance.whoIsMasterOwner();
  console.log(`whoIsMasterOwner`, whoIsMasterOwner);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

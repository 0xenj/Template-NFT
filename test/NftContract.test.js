const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

const Helper = require("./shared");
const { ethers } = require("hardhat");
let contract;

describe("Simple NFT", function () {
  before(async function () {
    [provider, owner, user1, user2, user3] =
      await Helper.setupProviderAndAccount();
  });

  beforeEach(async function () {
    contract = await Helper.setupContract([user1.address, user2.address]);
  });
});

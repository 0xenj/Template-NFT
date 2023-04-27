// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import './NftContract.sol';

contract NftContractFactory {
  event ContractCreated(address contractAddress);

  function deployNewContract(string memory name_, string memory symbol_, uint256 maxSupply_) external returns (address) {
    NftContract newContract = new NftContract(name_, symbol_, maxSupply_);

    newContract.transferOwnership(msg.sender);

    emit ContractCreated(address(newContract));

    return address(newContract);
  }
}
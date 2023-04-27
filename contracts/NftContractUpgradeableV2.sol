// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import '@openzeppelin/contracts/utils/Strings.sol';

import './NftContractUpgradeable.sol';

contract NftContractUpgradeableV2 is NftContractUpgradeable {
  string private _masterOwner;

  function setMasterOwner(string memory masterOwner_) public onlyOwner {
    _masterOwner = masterOwner_;
  }

  function whoIsMasterOwner() public view returns (string memory) {
    return _masterOwner;
  }
}
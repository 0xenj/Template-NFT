// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import '@openzeppelin/contracts/utils/Strings.sol';

import './abstracts/ControlableUpgradeable.sol';
import './abstracts/MintableUpgradeable.sol';
import './abstracts/WListableUpgradeable.sol';

contract NftContractUpgradeable is ControlableUpgradeable, WListableUpgradeable, MintableUpgradeable {
  using Strings for uint256;

  function initialize(string memory name_, string memory symbol_, uint256 maxSupply_) external initializer {
    __ControlableUpgradeable_init(name_, symbol_, maxSupply_);
  }

  function __ControlableUpgradeable_init(string memory name_, string memory symbol_, uint256 maxSupply_) internal onlyInitializing {
    __ControlableUpgradeable_init();
    __MintableUpgradeable_init(name_, symbol_, maxSupply_);
    __WListableUpgradeable_init();
  }

  modifier ownerOrMintStarted() {
    require(owner() == _msgSender() || isStarted(), 'SimpleNft: caller is not the owner or mint not started');
    _;
  }

  modifier whiteListMintStarted() {
    require(isWhiteListStarted(), 'SimpleNft: whiteList mint not started');
    _;
  }

  function mint(uint8 quantity) external payable ownerOrMintStarted {
    require(quantity > 0, 'SimpleNft: quantity must be greater than 0');
    require(msg.value >= 0.002 ether * quantity, 'SimpleNft: Transaction value below mint price');
    _mintPublic(_msgSender(), quantity);
  }

  function mintWhiteList(uint8 quantity, bytes32[] calldata proofs) external payable whiteListMintStarted {
    require(quantity > 0, 'SimpleNft: quantity must be greater than 0');
    require(_isWhitelistValid(proofs), 'SimpleNft: invalid proof');
    require(msg.value >= 0.0001 ether * quantity, 'SimpleNft: Transaction value below mint price');
    _mintWhitelist(_msgSender(), quantity);
  }

  function tokenURI(uint256 tokenId) public view override returns (string memory) {
    require(_exists(tokenId), 'SimpleNft: URI query for nonexistent token');
    string memory baseURI_ = baseURI();
    return bytes(baseURI_).length != 0 ? string(abi.encodePacked(baseURI_, tokenId, _extensionURI())) : '';
  }

  function updateWhitelistRoot(bytes32 newRoot) external onlyOwner {
    _updateWhitelistRoot(newRoot);
  }
}
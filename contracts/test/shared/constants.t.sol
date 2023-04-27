// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Constants {
  // Constants value specific to the contracts we are testing.
  string constant NAME_ERC721 = '';
  string constant SYMBOL_ERC721 = '';
  uint256 constant MAX_SUPPLY_ERC721 = 0;

  bytes32 constant WL_ROOT = 0x0000000000000000000000000000000000000000000000000000000000000000;

  string constant CONTRACT_URI = 'ipfs://test123456test.test/test123contractURI.json';
  string constant BASE_URI = 'ipfs://test123456test.test/';
  string constant EXTENSION_URI = '.json';

  uint256 constant MINT_WL_PRICE = 0 ether;
  uint256 constant MINT_REGULAR_PRICE = 0 ether;

  address[] public WL;

  uint256 DEFAULT_MINT_VALUE = 1;
  uint256 DEFAULT_BLOCKS_COUNT = 25;

  address ADMIN = address(42_000);

  constructor() {
    // WL
    for (uint160 i = 0; i < 42; ) {
      WL.push(address(i));
      unchecked {
        ++i;
      }
    }
  }
}
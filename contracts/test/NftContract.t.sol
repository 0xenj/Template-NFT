// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import 'foundry-test-utility/contracts/utils/console.sol';
import { Helper } from './shared/helper.t.sol';
import { Errors } from './shared/errors.t.sol';

contract NftContract_test is Helper {
  uint8 LOG_LEVEL = 0;

  function setUp() public {
    initialize_helper(LOG_LEVEL);
  }
}
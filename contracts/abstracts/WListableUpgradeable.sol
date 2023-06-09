// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import '@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/utils/cryptography/MerkleProofUpgradeable.sol';

abstract contract WListableUpgradeable is ContextUpgradeable {
  bytes32 private root;

  function __WListableUpgradeable_init() internal onlyInitializing {}

  /**
   * @dev Verify proofs against root for caller
   * @param proofs - Array of bytes32 hashes proofs
   * @return bool - True if proofs are valid
   */
  function isWhitelistValid(bytes32[] calldata proofs) external view virtual returns (bool) {
    return _isWhitelistValid(proofs);
  }

  /**
   * @dev Verify proofs against root for caller - Internal function
   * @param proofs - Array of bytes32 hashes proofs
   * @return bool - True if proofs are valid
   */
  function _isWhitelistValid(bytes32[] calldata proofs) internal view virtual returns (bool) {
    return MerkleProofUpgradeable.verifyCalldata(proofs, root, keccak256(abi.encodePacked(msg.sender)));
  }

  /**
   * @dev Update Whitelist Root - Internal function
   * @param _root - New root
   */
  function _updateWhitelistRoot(bytes32 _root) internal virtual {
    root = _root;
  }

  uint256[50] private __gap;
}
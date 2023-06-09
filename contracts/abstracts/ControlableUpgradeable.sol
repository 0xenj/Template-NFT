// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';

interface IERC20 {
  function balanceOf(address account) external returns (uint256);

  function transfer(address to, uint256 amount) external returns (bool);
}

abstract contract ControlableUpgradeable is OwnableUpgradeable {
  uint256 private _startTimestamp;
  uint256 private _startWhitelistTimestamp;
  string private _contractURI;
  string private _baseURI;

  function __ControlableUpgradeable_init() internal onlyInitializing {
    __Ownable_init();
  }

  /**
   * @dev Return contractURI
   */
  function contractURI() external view virtual returns (string memory) {
    return _contractURI;
  }

  /**
   * @dev Disable transferOwnership function
   */
  function transferOwnership(address newOwner) public override onlyOwner {
    // Disable this function
  }

  /**
   * @dev Return baseURI
   */
  function baseURI() public view virtual returns (string memory) {
    return _baseURI;
  }

  /**
   * @dev Verify if minting has started for whitelist
   */
  function isWhiteListStarted() public view virtual returns (bool) {
    return _startWhitelistTimestamp > 0 && _startWhitelistTimestamp <= block.timestamp;
  }

  /**
   * @dev Verify if minting has started
   */
  function isStarted() public view virtual returns (bool) {
    return _startTimestamp > 0 && _startTimestamp <= block.timestamp;
  }

  /**
   * @dev Set Public and Whitelist start Minting block timestamp
   *  - Verify that the caller is the owner
   */
  function startMinting(uint256 timestamp_, uint256 timestampWL_) external virtual onlyOwner {
    require(timestamp_ >= block.timestamp, "Controlable: Public minting can't start in the past");
    require(timestamp_ > timestampWL_, "Controlable: Public minting can't start before whitelist minting");
    _startTimestamp = timestamp_;
    _startWhitelistTimestamp = timestampWL_;
  }

  /**
   * @dev Allow to set contract URI - Internal function
   * @param newContractURI - IPFS pointing to the new contract URI file
   *  - Verify that the caller is the owner
   */
  function _setContractURI(string memory newContractURI) internal virtual {
    _contractURI = newContractURI;
  }

  /**
   * @dev Allow to set base URI - Internal function
   * @param newBaseURI - IPFS pointing to the new base URI file
   *  - Verify that the caller is the owner
   */
  function _setBaseURI(string memory newBaseURI) internal virtual {
    _baseURI = newBaseURI;
  }

  function _extensionURI() internal view virtual returns (string memory) {
    return '.json';
  }

  /**
   * @dev Allow to set contract URI
   * @param newContractURI - IPFS pointing to the new contract URI file
   *  - Verify that the caller is the owner
   */
  function setContractURI(string memory newContractURI) external virtual onlyOwner {
    _setContractURI(newContractURI);
  }

  /**
   * @dev Allow to set base URI
   * @param newBaseURI - IPFS pointing to the new base URI file
   *  - Verify that the caller is the owner
   */
  function setBaseURI(string memory newBaseURI) external virtual onlyOwner {
    _setBaseURI(newBaseURI);
  }

  /**
   * @dev Allow owner to withdraw any ether sent to this contract
   *  - Verify that the caller is the owner
   */
  function withdrawEther() external virtual onlyOwner returns (bool success) {
    (success, ) = payable(msg.sender).call{ value: address(this).balance }('');
  }

  /**
   * @dev Allow owner to withdraw any ERC20 Token sent to this contract
   *  - Verify that the caller is the owner
   */
  function withdrawERC20Token(address tokenAddres) external virtual onlyOwner returns (bool success) {
    IERC20 token = IERC20(tokenAddres);
    uint256 balance = token.balanceOf(address(this));
    require(token.transfer(msg.sender, balance), 'Controlable: Transfer failed');
    return true;
  }

  uint256[50] private __gap;
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

// import "../helpers/UpgradeableProxy-08.sol";
import "https://github.com/OpenZeppelin/ethernaut/blob/e2536a8072a72e146b3a22c6f021ae1ffc948288/contracts/contracts/helpers/UpgradeableProxy-08.sol";

contract PuzzleProxy is UpgradeableProxy {
  address public pendingAdmin;
  address public admin;

  // _implementation > logic contract location
  // initData > used for delegate call data passed from proxy contract (i.e. slot 0, 1)
  constructor(address _admin, address _implementation, bytes memory _initData) UpgradeableProxy(_implementation, _initData) {
      admin = _admin;
  }

  modifier onlyAdmin {
    require(msg.sender == admin, "Caller is not the admin");
    _;
  }

  // update pendingAdmin with input _newAdmin
  function proposeNewAdmin(address _newAdmin) external {
      pendingAdmin = _newAdmin;
  }

  // update new admin with pendingAdmin
  function approveNewAdmin(address _expectedAdmin) external onlyAdmin {
      require(pendingAdmin == _expectedAdmin, "Expected new admin by the current admin is not the pending admin");
      admin = pendingAdmin;
  }

  // upgreade new proxy contract
  function upgradeTo(address _newImplementation) external onlyAdmin {
      _upgradeTo(_newImplementation);
  }
}

contract PuzzleWallet {
  // we need to attack here with storage
  address public owner; // pendingAdmin = slot 0
  uint256 public maxBalance; // pendingAdmin = slot 1
  mapping(address => bool) public whitelisted;
  mapping(address => uint256) public balances;

  // Proxy contracts version of (contructor)
  function init(uint256 _maxBalance) public {
    // can't directly set maxBalance due to require statement
    require(maxBalance == 0, "Already initialized");
    maxBalance = _maxBalance;
    owner = msg.sender;
  }

  modifier onlyWhitelisted {
    require(whitelisted[msg.sender], "Not whitelisted");
    _;
  }

  function setMaxBalance(uint256 _maxBalance) external onlyWhitelisted {
    require(address(this).balance == 0, "Contract balance is not 0");
    maxBalance = _maxBalance;
  }

  function addToWhitelist(address addr) external {
    require(msg.sender == owner, "Not the owner");
    whitelisted[addr] = true;
  }

  function deposit() external payable onlyWhitelisted {
    require(address(this).balance <= maxBalance, "Max balance reached");
    balances[msg.sender] += msg.value;
  }

  function execute(address to, uint256 value, bytes calldata data) external payable onlyWhitelisted {
    require(balances[msg.sender] >= value, "Insufficient balance");
    balances[msg.sender] -= value;
    (bool success, ) = to.call{ value: value }(data);
    require(success, "Execution failed");
  }

  // Batching multi trx together to save on gas
  function multicall(bytes[] calldata data) external payable onlyWhitelisted {
    // prevent multi deposit call in a singel trx
    bool depositCalled = false;
    for (uint256 i = 0; i < data.length; i++) {
      bytes memory _data = data[i];
      bytes4 selector;
      assembly {
        selector := mload(add(_data, 32))
      }
      if (selector == this.deposit.selector) {
        require(!depositCalled, "Deposit can only be called once");
        // Protect against reusing msg.value
        depositCalled = true;
      }
      (bool success, ) = address(this).delegatecall(data[i]);
      require(success, "Error while delegating call");
    }
  }
}
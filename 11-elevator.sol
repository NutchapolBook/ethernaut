// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    // The problem is "external". We can modifie interface function that use exteranl
    function isLastFloor(uint) external returns (bool);
}

contract Elevator {
    bool public top;
    uint public floor;

    function goTo(uint _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "../helpers/Ownable-05.sol";

contract AlienCodex is Ownable {
    bool public contact;
    bytes32[] public codex;

    modifier contacted() {
        assert(contact);
        _;
    }

    function makeContact() public {
        contact = true;
    }

    function record(bytes32 _content) public contacted {
        codex.push(_content);
    }

    // pop last index of array
    function retract() public contacted {
        codex.length--;
    }

    // change value(_content) at index i
    function revise(uint i, bytes32 _content) public contacted {
        codex[i] = _content;
    }
}

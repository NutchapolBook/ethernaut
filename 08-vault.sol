// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
  bool public locked;
  bytes32 private password;

  constructor(bytes32 _password) {
    locked = true;
    password = _password;
  }

  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
  }
  
    /*
    get value from slot 1 > password

    contract.address => 0xB0d0dCE89630E441c4575A57de0CEbf124b18F65

    await web3.eth.getStorageAt('0xB0d0dCE89630E441c4575A57de0CEbf124b18F65',1)
    result = 0x412076657279207374726f6e67207365637265742070617373776f7264203a29

    or go to etherScan https://sepolia.etherscan.io/tx/0xdbe73c12a2dd76546a560a3d28fc6fd5ff011155b5d04081f886b597342add3f#statechange\
    and check in tap State > Storage (2) 
    > After: 0x412076657279207374726f6e67207365637265742070617373776f7264203a29

    cotract.unlock('0x412076657279207374726f6e67207365637265742070617373776f7264203a29')
    */

    /*
    Result
    It's important to remember that marking a variable as private only prevents other contracts from accessing it. 
    State variables marked as private and local variables are still publicly accessible.

    To ensure that data is private, it needs to be encrypted before being put onto the blockchain. 
    In this scenario, the decryption key should never be sent on-chain, 
    as it will then be visible to anyone who looks for it. 
    zk-SNARKs provide a way to determine whether someone possesses a secret parameter, without ever having to reveal the parameter.
    */
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MagicNum {
    address public solver;

    constructor() {}

    /*

    need to return 0x42 and Less than 10 bytes code at most.

    Solidity code (.sol) > bytecode > opcodes

    When deployed EVM compiles contract creation bytecode
    to 2 set of bytecode

    1. initialization code (contructor code) 
    2. runtime code (contract execuion logic)

    During contract creation, the EVM only executes the initialization code 
    until it reaches the first STOP or RETURN instruction in the stack. 
    During this stage, the contract’s constructor() function is run, and the contract has an address.

    After this initialization code is run, only the runtime code remains 
    on the stack. These opcodes are then copied into memory and returned to the EVM.

    Finally, the EVM stores this returned, surplus code in the state storage, 
    in association with the new contract address. 
    This is the runtime code that will be executed by the stack in all future calls to the new contract.

    We need bytecode that below than 10 opcode
    - Creation > 0 bytes
    - runtime > 10 bytes
    */

    function setSolver(address _solver) public {
        solver = _solver;
    }

    /*
    ____________/\\\_______/\\\\\\\\\_____        
     __________/\\\\\_____/\\\///////\\\___       
      ________/\\\/\\\____\///______\//\\\__      
       ______/\\\/\/\\\______________/\\\/___     
        ____/\\\/__\/\\\___________/\\\//_____    
         __/\\\\\\\\\\\\\\\\_____/\\\//________   
          _\///////////\\\//____/\\\/___________  
           ___________\/\\\_____/\\\\\\\\\\\\\\\_ 
            ___________\///_____\///////////////__
  */
}

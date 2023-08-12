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

We need to create bytecode that below than 10 opcode
- Creation > ? bytes
- runtime > 10 bytes

Console

```ruby
let initialization code = "600a600c600039600a6000f3"
let runtime code = "602a60505260206050f3";
let bytecode = "600a600c600039600a6000f3" + "602a60505260206050f3"
let bytecode = "600a600c600039600a6000f3602a60505260206050f3";

tx = await web3.eth.sendTransaction({ from: player, data: bytecode })
```

https://sepolia.etherscan.io/tx/0x533989742b64889c388a312162a167fa881e6da8122d76b96d928e5c31be27e6

tx
````json
{
    "blockHash":"0xb17847a027054345ff6fbc6dbab79654980ac653065a25b5c1ad933c52e56cff",
    "blockNumber":4073613,
    "contractAddress":"0xcd57C09fD3D6c0c07920510B5908BcdADEf02620",
    "cumulativeGasUsed":459613,
    "effectiveGasPrice":2703758264,
    " …"
}
````

```ruby
await contract.setSolver(tx.contractAddress);
```
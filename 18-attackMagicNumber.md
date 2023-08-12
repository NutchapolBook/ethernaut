We need to return 0x42 and Less than 10 bytes code at most.

Solidity code (.sol) > bytecode > opcodes

When deploy contract EVM compiles contract creation bytecode
to 2 set of bytecode

1. Initialization code (contructor code) 
2. Runtime code (contract execuion logic)

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

### Runtime code

Returning values is handled by the **RETURN** opcode, which takes in two arguments:
- p: the position where your value is stored in memory, i.e. 0x0, 0x40, 0x50 (see figure).
- s: the size of your stored data. Recall your value is 32 bytes long (or 0x20 in hex).

```
602a    // v: push1 0x2a in stack (2a value is 2*(16^1) + 10*(16^0) = 42)
6050    // p: push1 0x50 in stack (memory slot is 0x50)
52      // mstore, store, v=0x2a at p=50 in memory
6020    // s: push1 0x20 (value is 32 bytes in size) in stack
6050    // p: push1 0x50 (value was stored in slot 0x50)
f3      // return value, v=0x42 of size, s=0x20 (21 bytes)
```
Runtime code

```
602a60505260206050f3
```

### Initialization Opcodes

Copying code from one place to another is handled by the opcode **codecopy**, which takes in 3 arguments:
- s: size of the code, in bytes. Recall that 602a60505260206050f3 is 10 bytes long (or 0x0a in hex).
- f: the current position of the runtime opcodes, in reference to the entire bytecode. 
Remember that f starts after initialization opcodes end. This value is currently unknown.
- t: the destination position of the code, in memory. Let’s arbitrarily save the code to the 0x00 position.

``` 
600a    // s: push1 0x0a (10 bytes)
60??    // f: push1 0x?? (current position of runtime opcodes)
6000    // t: push1 0x00 (destination memory index 0)
39      // CODECOPY
600a    // s: push1 0x0a (runtime opcode length = 10 bytes)
6000    // p: push1 0x00 (access memory index 0)
f3      // return to EVM
```
Notice that in total, Initialization Opcodes take up 12 bytes, or 0x0c spaces. 
This means your runtime opcodes will start at index 0x0c, where f is now known to be 0x**0c**:

Initialization Opcodes

```
600a600c600039600a6000f3
```

### Byte code
Runtime code + Initialization Opcodes

```
600a600c600039600a6000f3602a60505260206050f3
```

### Console

```ruby
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
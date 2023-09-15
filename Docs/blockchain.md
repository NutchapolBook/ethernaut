# Blockchain
- [Hash function](#hash-function)
  - [SHA-256](#sha-256)
- [Coin vs Token](#coin-vs-token)

## Hash function

### SHA-256

## Consensus mechanism

- Proof of work (POW)
- Proof of Stake (POS)
- Proof of authentication (POA)
- Proof of history (POH)

## State finality 
State finality is an additional concern. Finality describes whether and when committed blocks with transactions can no longer be reverted/revoked. It is important to differentiate between probabilistic and absolute finality.

- Probabilistic finality
Probabilistic finality describes the finality of a transaction dependent on how probable reverting a block is, i.e. the probability of removing a transaction. The more blocks that come after the block containing a specific transaction, the less probable it is that a transaction may be reverted, as longest or heaviest chain rules apply in the case of forks.

- Absolute finality
Absolute finality is a trait of protocols based on Proof-of-Stake (PoS). Finality comes as soon as a transaction and block are verified. There are no scenarios in which a transaction can be revoked after it has been finalized.

- Absolute finality in PoW and PoS
Proof-of-Stake (PoS) networks can have absolute finality because the total staked amount is known at all times. It takes a public transaction to stake, and another to unstake. If some majority of the stakers agree on a block, then the block can be considered "final" because there is no process that could overturn the consensus.

This is different from PoW networks, where the total hashing capacity is unknown; it can only be estimated by a combination of the puzzle's difficulty and the speed at which new blocks are issued. Hashing capacity can be added or removed simply by turning machines on or off. When hashing capacity is removed too abruptly it results in a drop in the network transaction throughput, as blocks suddenly fail to be issued around the target interval.

Light Client
A light-client is a blockchain client that downloads only the headers of the blocks. A light-client verifies the result of its queries against these headers (see Merkle Proof) to gives users a lightweight alternative to full-nodes with good security guarantees.

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
SHA-256


Ref
https://tutorials.cosmos.network/academy/1-what-is-cosmos/1-blockchain-and-cosmos.html
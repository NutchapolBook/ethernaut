import { getContractAddress } from '@ethersproject/address'

const futureAddress = getContractAddress({
  //contract address
  from: '0x1Ad1eb72A993FBEDAadF3cD3fD451B70636D0E9A',
  nonce: 1
})

console.log(futureAddress)
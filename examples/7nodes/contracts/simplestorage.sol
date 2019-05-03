pragma solidity ^0.5.3;

contract simplestorage {
  string public storedData;

   constructor (string memory initVal) public {
    storedData = initVal;
  }

  function set(string calldata x) external {
    storedData = x;
  }

  function get() public view returns (string memory retVal) {
    return storedData;
  }
}

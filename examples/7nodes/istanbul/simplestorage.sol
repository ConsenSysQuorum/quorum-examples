pragma solidity ^0.4.15;

contract simplestorage {
  uint public storedData;
  event valueSet(uint);

  function simplestorage(uint initVal) {
    storedData = initVal;
  }

  function set(uint x) {
    storedData = x;
    emit valueSet(x);
  }

  function get() constant returns (uint retVal) {
    return storedData;
  }
}

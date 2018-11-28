pragma solidity ^0.4.21;

contract storec {
  function setc(uint x) public;
  function getc() public constant returns (uint);
}
contract storeb {
  uint public b;
  storec c;

  constructor (uint initVal, address _addrc) public {
    b = initVal;
    c = storec(_addrc);
  }

  function setb(uint x) public {
    uint mc = c.getc();
    b = x * mc;
  }

  function getb() public constant returns (uint retVal) {
    return b;
  }

  function setc(uint x) public {
    return c.setc(x);
  }

  function getc() public constant returns (uint retVal) {
    return c.getc();
  }
}

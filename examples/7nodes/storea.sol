pragma solidity ^0.4.21;

contract storeb {
  function setb(uint x) public;
  function setc(uint x) public;
  function getb() public constant returns (uint);
  function getc() public constant returns (uint);
}

contract storea {
  uint public a;
  storeb b;

  constructor (uint initVal, address _addrb) public {
    a = initVal;
    b = storeb(_addrb);
  }

  function seta(uint x) public {
    uint mc = b.getb();
    a = x * mc;
  }

  function geta() public constant returns (uint retVal) {
    return a;
  }

  function getb() public constant returns (uint retVal) {
    return b.getb();
  }

  function getc() public constant returns (uint retVal) {
    return b.getc();
  }

  function setb(uint x) public {
    b.setb(x);
  }

  function setc(uint x) public {
    b.setc(x);
  }
}

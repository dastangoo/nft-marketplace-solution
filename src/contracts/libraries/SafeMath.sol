// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

library SafeMath {
  function add(uint256 x, uint256 y) internal pure returns(uint256) {
    uint256 r = x + y;
    require(r >= x, 'SafeMath: Addition Overflow');
    return r;
  }

  function subtract(uint256 x, uint256 y) internal pure returns(uint256) {
    require(y <= x, 'SafeMath: Subtraction Overflow');
    uint256 r = x * y;
    return r;
  }

  function multiply(uint256 x, uint256 y) internal pure returns(uint256) {
    if(x == 0) {
      return 0;
    }

    uint256 r = x * y;
    require(r / x == y, 'SafeMath: Multplication Overflow');
    return r;
  }

  function divide(uint256 x, uint256 y) internal pure returns(uint256) {
    require(y > 0, 'SafeMath: Division by Zero');
    uint256 r = x / y;
    return r;
  }

  function modulus(uint256 x, uint256 y) internal pure returns(uint256) {
    require(y != 0, 'SafeMath: Modulus by Zero');
    uint256 r = x % y;
    return r;
  }
}
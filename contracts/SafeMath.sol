// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {
    function add100(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b + 100;        
    }
}
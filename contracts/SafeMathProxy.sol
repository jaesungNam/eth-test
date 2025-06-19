// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract SafeMathProxy {
    function add100(uint256 a, uint256 b) virtual public pure returns (uint256);
}

contract Calculator {
    SafeMathProxy safeMath;

    constructor(address _libraryAddress) {        
        safeMath = SafeMathProxy(_libraryAddress);
    }

    function calculateTheta(uint256 a, uint256 b) public returns (uint256) {
        uint256 delta = safeMath.add100(a, b);
        return delta;       
    }
}
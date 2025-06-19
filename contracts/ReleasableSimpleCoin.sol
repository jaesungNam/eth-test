// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./SimpleCoin.sol";
import "./Pausable.sol";
import "./Destructible.sol";

contract ReleasableSimpleCoin is SimpleCoin, Pausable, Destructible {
    bool public released = false;

    modifier isReleased() {
        if(!released) {
            revert();
        }
        _;
    }

    constructor(uint256 _initialSupply) SimpleCoin(_initialSupply) {}

    function release() onlyOwner public {
        released = true;
    }

    function transferFrom(address _from, address _to, uint256 _amount) override isReleased public returns (bool success) {
        return super.transferFrom(_from, _to, _amount);
    }
}
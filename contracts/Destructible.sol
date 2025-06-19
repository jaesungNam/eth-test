// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";

contract Destructible is Ownable {

    constructor() payable public {}

    function destroyAndSend(address _recipient) onlyOwner public {
        selfdestruct(payable(_recipient));
    }
}
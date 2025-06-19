// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ReleasableSimpleCoin.sol";
import "./Pausable.sol";
import "./Destructible.sol";
import "./SimpleCrowdSale.sol";

abstract contract FixedPricingCrowdSale is SimpleCrowdSale {
    constructor(
        uint256 _startTime, 
        uint256 _endTime, 
        uint256 _weiTokenPrice, 
        uint256 _etherInvestmentObjective
    ) SimpleCrowdSale(_startTime, _endTime, _weiTokenPrice, _etherInvestmentObjective) payable {} 

    function calculateNumberOfTokens(uint256 investment) override internal returns (uint256) {
        return investment / weiTokenPrice;
    }    
}
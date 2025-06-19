// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./FundingLimitStrategy.sol";
import "./FixedPricingCrowdsale.sol";
import "./TranchePricingCrowdsale.sol";

contract UnlimitedFixedPricingCrowdsale is FixedPricingCrowdSale {
    constructor(
        uint256 _startTime,
        uint256 _endTime,
        uint256 _weiTokenPrice,
        uint256 _etherInvestmentObjective
    ) FixedPricingCrowdSale(
        _startTime, _endTime, _weiTokenPrice, _etherInvestmentObjective
    ) payable {}

    function createFundingLimitStrategy() override internal returns (FundingLimitStrategy) {
        return new UnlimitedFundingStrategy();
    }
}

contract CappedFixedPricingCrowdsale is FixedPricingCrowdSale {
    constructor(
        uint256 _startTime,
        uint256 _endTime,
        uint256 _weiTokenPrice,
        uint256 _etherInvestmentObjective
    ) FixedPricingCrowdSale(
        _startTime, _endTime, _weiTokenPrice, _etherInvestmentObjective
    ) payable {}

    function createFundingLimitStrategy() override internal returns (FundingLimitStrategy) {
        return new CappedFundingStrategy(10000);
    }
}

contract UnlimitedTranchePricingCrowdsale is TranchePricingCrowdsale {
    constructor(
        uint256 _startTime,
        uint256 _endTime,        
        uint256 _etherInvestmentObjective
    ) TranchePricingCrowdsale(
        _startTime, _endTime, _etherInvestmentObjective
    ) payable {}

    function createFundingLimitStrategy() override internal returns (FundingLimitStrategy) {
        return new UnlimitedFundingStrategy();
    }
}

contract CappedTranchePricingCrowdsale is TranchePricingCrowdsale {
    constructor(
        uint256 _startTime,
        uint256 _endTime,        
        uint256 _etherInvestmentObjective
    ) TranchePricingCrowdsale(
        _startTime, _endTime, _etherInvestmentObjective
    ) payable {}

    function createFundingLimitStrategy() override internal returns (FundingLimitStrategy) {
        return new CappedFundingStrategy(10000);
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract FundingLimitStrategy {
    function isFullInvestmentWithinLimit(uint256 _investment, uint256 _fullInvestmentReceived) virtual public view returns (bool);
}

contract CappedFundingStrategy is FundingLimitStrategy {
    uint256 fundingCap;

    constructor(uint256 _fundingCap) {
        require(_fundingCap > 0);
        fundingCap = _fundingCap;
    }

    function isFullInvestmentWithinLimit(uint256 _investment, uint256 _fullInvestmentReceived) override public view returns (bool) {
        bool check = _fullInvestmentReceived + _investment < fundingCap;
        return check;
    }
}

contract UnlimitedFundingStrategy is FundingLimitStrategy {
    function isFullInvestmentWithinLimit(uint256 _investment, uint256 _fullInvestmentReceived) override public view returns (bool) {
        return true;
    }
}
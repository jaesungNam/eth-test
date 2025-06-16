// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleCrowdSale.sol";

contract TranchePricingCrowdsale is SimpleCrowdSale {
    
    struct Tranche {
        uint256 weiHighLimit;
        uint256 weiTokenPrice;
    }

    mapping(uint256 => Tranche) public trancheStructure;
    uint256 public currentTrancheLevel;

    constructor(uint256 _startTime, uint256 _endTime, uint256 _etherInvestmentObjective) 
        SimpleCrowdSale(_startTime, _endTime, 1, _etherInvestmentObjective) payable {
            trancheStructure[0] = Tranche(3 ether, 0.002 ether);
            trancheStructure[1] = Tranche(5 ether, 0.003 ether);
            trancheStructure[2] = Tranche(10 ether, 0.004 ether);
            trancheStructure[2] = Tranche(1000000000 ether, 0.005 ether);
            currentTrancheLevel = 0;
        }

        function calculateNumberOfTokens(uint256 investment) override internal returns (uint256) {
            updateCurrentTrancheAndPrice();
            return investment / weiTokenPrice;                
        }

        function updateCurrentTrancheAndPrice() internal {
            uint256 i = currentTrancheLevel;
            while(trancheStructure[i].weiHighLimit < investmentReceived) {
                ++i;
            }
            currentTrancheLevel = i;
            weiTokenPrice = trancheStructure[currentTrancheLevel].weiTokenPrice;
        }
        
}
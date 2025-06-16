// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ReleasableSimpleCoin.sol";
import "./Ownable.sol";

contract SimpleCrowdSale is Ownable {
    uint256 public startTime; // 크라우드세일 자금 조달 시작시간 (UNIX epoch)
    uint256 public endTime; // 크라우드세일 자금 조달 종료시간 (UNIX epoch)
    uint256 public weiTokenPrice; // 판매되는 토큰의 가격
    uint256 public weiInvestmentObjective; // 크라우드세일 성공 여부를 결정하는 최소 모집 금액 
    
    mapping (address => uint256) public inventmentAmountOf; // 투자자들에게 받은 이더금액
    uint256 public investmentReceived; // 투자자에게 받은 이더 총계;
    uint256 public investmentRefunded; // 투자자에게 환불된 이더 총계;

    bool public isFinalized; // 컨트랙트가 완료됐는지 나타내는 플래그 
    bool public isRefundingAllowed; // 환불 가능 여부를 나타내는 플래그
    
    ReleasableSimpleCoin public crowdsaleToken; // 판매되는 토큰 컨트랙트 

    constructor(uint256 _startTime, uint256 _endTime, uint256 _weiTokenPrice, uint256 _etherInvestmentObjective) {
        require(_startTime >= block.timestamp);
        require(_endTime >= _startTime);
        require(_weiTokenPrice != 0);
        require(_etherInvestmentObjective != 0);

        startTime = _startTime;
        endTime = _endTime;
        weiTokenPrice = _weiTokenPrice;
        weiInvestmentObjective = _etherInvestmentObjective * 1000000000000000000;

        crowdsaleToken = new ReleasableSimpleCoin(0);
        isFinalized = false;
        isRefundingAllowed = false;
        owner = msg.sender;
    }

    event LogInvestment(address indexed investor, uint256 value);
    event LogTokenAssignment(address indexed investor, uint256 numTokens);

    function invest(/* address _beneficiary */ ) public payable {
        require(isValidInvestment(msg.value));

        address investor = msg.sender;
        uint256 investment = msg.value;

        inventmentAmountOf[investor] += investment;
        investmentReceived += investment;

        // msg.sender 가 투자자가 msg.value 만큼 투자하면 토큰을 할당한다. 
        assignTokens(investor, investment);
        emit LogInvestment(investor, investment);
    }

    function isValidInvestment(uint256 _investment) internal view returns (bool) {
        bool nonZeroInvestment = _investment != 0;
        // bool withinCrowdsalePeroid = block.timestamp > startTime && block.timestamp < endTime;
        bool withinCrowdsalePeroid = true;

        return nonZeroInvestment && withinCrowdsalePeroid;
    }

    function assignTokens(address _beneficiary, uint256 _investment) internal {
        uint256 _numberOfTokens = calculateNumberOfTokens(_investment);

        // crowdsaleToken 인스턴스의 mint 는 owner 만 호출 할 수 있다.
        // assignToken 은 _beneficiary 는 투자자이지만 crowdsaleToken 의 인스턴스 소유자는 컨트랙트를 배포한 배포자임
        // 따라서 배포자가 투자자한테 토큰을 민팅해주는거라고 보면 됨
        crowdsaleToken.mint(_beneficiary, _numberOfTokens);
    }

    // weiTokenPrice 가 100 이면 100wei === 1 SimpleCoin 임 
    // 어떤 투자자가 1000wei 투자하면 10 SimpleCoin 을 민팅받음
    function calculateNumberOfTokens(uint256 _investment) virtual internal returns (uint256) {
        return _investment / weiTokenPrice;        
    }

    function finalize() onlyOwner public {
        if(isFinalized) revert();

        // bool isCrowdsaleComplete = block.timestamp > endTime;
        bool isCrowdsaleComplete = true;
        bool investmentObjectiveMet = investmentReceived >= weiInvestmentObjective;

        if(isCrowdsaleComplete) {
            if(investmentObjectiveMet) {
                crowdsaleToken.release();
            } else {
                isRefundingAllowed = true;
            }
            
            isFinalized = true;
        }
    }

    event Refund(address investor, uint256 value);

    function refund() public {
        if(!isRefundingAllowed) revert();

        address payable investor = payable(msg.sender);
        uint256 investment = inventmentAmountOf[investor]; // 투자자의 투자 금액
        if(investment == 0) revert();
        inventmentAmountOf[investor] = 0; // 투자금액을 0으로 만듦
        investmentRefunded += investment; // 환불할 투자금액을 더함
        emit Refund(msg.sender, investment);

        if(!investor.send(investment)) revert(); // 

    }    
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Ownable.sol";
import "./ERC20.sol";

contract SimpleCoin is Ownable, ERC20 {
    uint256 _totalSupply;
    mapping (address => uint256) public coinBalance;
    mapping (address => mapping (address => uint256)) internal allowances;
    mapping (address => bool) public frozenAccount;

    event FrozenAccount(address target, bool frozen);

    constructor(uint256 _initialSupply) {
        // coinBalance[0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C] = 10000;
        owner = msg.sender;        
        mint(owner, _initialSupply);
    }

    function balanceOf(address _account) public view returns (uint256 balance) {
        return coinBalance[_account];
    }

    function transfer(address _to, uint256 _amount) virtual public returns (bool) {
        require(coinBalance[msg.sender] >= _amount);
        require(coinBalance[_to] + _amount >= coinBalance[_to]);
        coinBalance[msg.sender] -= _amount;
        coinBalance[_to] += _amount;
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function approve(address _authorizedAccount, uint256 _allowance) public returns (bool success) {
        // _authorizedAccount 는 msg.sender (송금인) 의 _allowance 만큼 관리 가능 
        // msg.sender 이 호출할듯 
        // 즉 msg.sender 이 _authorizedAccount 만큼의 금액을 인출해가도록 허용 함
        allowances[msg.sender][_authorizedAccount] = _allowance;
        emit Approval(msg.sender, _authorizedAccount, _allowance);
        return true;
    }
    
    // transferFrom 은 수취인이 호출함 _from 은 송금인 계정이고 _to는 아무 계정이나 될수 있다. 
    function transferFrom(address _from, address _to, uint256 _amount) virtual public returns (bool success) {
        require(_to != address(0)); // 명시적으로 주소가 지정되지 않으면 기본값인 0x0 주소로 전송하는것을 방지
        require(coinBalance[_from] > _amount); // 송금인의 잔액은 _amount 보다 커야한다.
        require(coinBalance[_to] + _amount >= coinBalance[_to]); // 수취인의 잔액은 _amount를 더한것은 현재 수취인의 잔액보다 커야한다. 
        require(_amount <= allowances[_from][msg.sender]); // _from 이 송금인 msg.sender 가 수취인 됨, _from 송금인 은 msg.sender 수취인이 출금하도록 미리 authorize 했어야 함 

        coinBalance[_from] -= _amount;
        coinBalance[_to] += _amount;
        allowances[_from][msg.sender] -= _amount;

        emit Transfer(_from, _to, _amount);

        return true;
    }

    function allowance(address _authorizer, address _authorizedAccount) public view returns (uint256) {
        return allowances[_authorizer][_authorizedAccount];
    }

    function mint(address _recipient, uint256 _mintedAmount) onlyOwner public {        
        coinBalance[_recipient] += _mintedAmount;
        _totalSupply += _mintedAmount;
        emit Transfer(owner, _recipient, _mintedAmount);
    }

    function freezeAccount(address target, bool freeze) onlyOwner public {        
        frozenAccount[target] = freeze;
        emit FrozenAccount(target, freeze);
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }


    // 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 : 9600
    // 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 : 400
    // 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db : 0

    // 0x5의 계정에서 500을 0xA 에게 허가 msg.sender: 0x5, 
    // 0xA 는 300 을 0x4 로 송금한다. msg.sender: 0xA, from: 0x5, to: 0x4
}


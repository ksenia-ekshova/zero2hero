// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MyErc20 {
    address private owner;
    string private tokenName;
    string private tokenSymbol;
    uint8 private tokenDecimals = 18;
    uint256 private tokenTotalSupply;
    uint256 private taxPercent = 5;
    uint256 private minAmount = 20 wei;
    bool private paused = false;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint)) private allowances;

    event Transfer(address  _from, address _to, uint256 _amount, uint256 _tax, string _message);
    event Approval(address  _owner, address _spender, uint256 _amount);
    event Mint(address  _from, address _to, uint256 _amount, uint256 _tax, string _message);
    event Pause(bool paused, string _message);

    constructor(string memory _name, string memory _symbol) {
        owner = msg.sender;
        tokenName = _name;
        tokenSymbol = _symbol;
    }

    function name() public view returns(string memory) {
        return tokenName;
    }

    function symbol() public view returns(string memory) {
        return tokenSymbol;
    }

    function decimals() public view returns(uint8) {
        return tokenDecimals;
    }

    function totalSupply() public view returns(uint256) {
        return tokenTotalSupply;
    }

    function balanceOf(address account) public view returns(uint256) {
        return (balances[account]);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner of this contract");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Pausable: paused");
        _;
    }

    function taxSize(uint256 _amount) private view returns(uint256) {
        if (_amount >= minAmount) {
            return (_amount * taxPercent) / 100;
        } else if (_amount > 0) {
            return 1 wei;
        }        
        return 0;
    }

    function transfer(address _to, uint256 _amount) public whenNotPaused() returns(bool success) {
        uint256 tax = taxSize(_amount);
        uint256 totalFee = _amount + tax;
        require(balances[msg.sender] >= totalFee, "Not enough tokens to complete the transaction");
        balances[msg.sender] -= totalFee;
        balances[_to] += _amount;
        balances[owner] += tax;

        emit Transfer(msg.sender, _to, _amount, tax, "Tokens transferred");
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _amount) public whenNotPaused() returns(bool success) {
        uint256 tax = taxSize(_amount);
        uint256 totalFee = _amount + tax;
        require(allowances[_from][_to] >= totalFee, "Not allowance to transfer");
        allowances[_from][_to] -= totalFee;
        balances[_from] -= totalFee;
        balances[_to] += _amount;
        balances[owner] += tax;

        emit Transfer(msg.sender, _to, _amount, tax, "Tokens transferred");
        return true;
    }

    function approve(address _spender, uint256 _amount) public whenNotPaused() returns(bool success) {
        require(_spender != address(0), "approve to the zero address");

        allowances[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function allowance(address _owner, address spender) public view whenNotPaused() returns (uint256) {
        return allowances[_owner][spender];
    }

    function mint(address _to, uint256 _amount) public onlyOwner whenNotPaused() returns(bool success) {
        tokenTotalSupply += _amount;
        balances[_to] += _amount;
        emit Mint(address(0), _to, _amount, 0, "Tokens minted");
        return true;
    }

    function setTax(uint256 _taxPercent) public onlyOwner whenNotPaused() returns(bool success) {
        taxPercent = _taxPercent;
        return true;
    }

    function setMinAmount(uint256 _minAmount) public onlyOwner whenNotPaused() returns(bool success) {
        minAmount = _minAmount;
        return true;
    }

    function setPaused(bool _paused) public onlyOwner returns(bool success) {
        paused = _paused;
        emit Pause(paused, "Pause state changed");
        return true;
    }
}

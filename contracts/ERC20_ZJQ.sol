// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "./IERC20_ZJQ.sol";

contract ERC20_ZJQ is IERC20_ZJQ {
    uint256 public override totalSupply;
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    address public owner;  // 添加 owner 变量

    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;

    // 在构造函数中初始化 owner
    constructor(string memory _name, string memory _symbol, uint256 _totalSupply) {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply;
        owner = msg.sender;  // 合约部署者为 owner
        balanceOf[owner] = _totalSupply;  // 初始化 owner 的代币余额为 totalSupply
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        require(balanceOf[msg.sender] >= amount, "ERROR: Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        require(msg.sender != spender, "Error: Can't Approve Self");
        require(balanceOf[msg.sender] >= amount, "ERROR: Not Enough Amount");
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        require(balanceOf[sender] >= amount, "Error: Insufficient balance");
        require(allowance[sender][msg.sender] >= amount, "ERROR: Not Enough Allowance");
        balanceOf[sender] -= amount;
        allowance[sender][msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // mint 函数：只有 owner 可以铸造新的代币
    function mint(uint256 amount) external {
        require(owner == msg.sender, "Error: Only Owner Can Mint");
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    // burn 函数：只有 owner 可以销毁代币
    function burn(uint256 amount) external {
        require(owner == msg.sender, "Error: Only Owner Can Burn");
        require(balanceOf[msg.sender] >= amount, "Error: Insufficient balance to burn");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}

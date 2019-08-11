pragma solidity ^0.5.3;

interface IERC20{
    
    function TotalSupply() public view returns(uint256);
    
    function BalacneOf(address _owner) external view returns(uint256 balance);
    
    function Transfer(address _to , uint256 value) external returns(bool success);
    
    function Approve(address _spender, uint256 value) external returns(bool success);
    
    function TransferFrom(address _from , address _to, uint256 value) external returns (bool success);
    
    function Allowance(address _owner, address _spender)external view returns(uint256 remaining);
    
    event Transfer(address indexed _from,address indexed _to, uint256 value);
    event Approvel(address indexed _owner, address indexed _spender ,uint256 value);
    
}

contract ERC20Token is IERC20{
    
    mapping(address => uint256) public _balances;
    
    mapping(address = > mapping(address => uint256))public _allowed;
    
    string public Name = "Pankaj";
    string public Symbol = "SKY";
    uint256 public _totalSupply;
    
    address public creator;
    
    constructor() public{
        creator = msg.sender;
        _totalSupply = 100000;
        _balances[creator] = _totalSupply;
    }
    
    function TotalSupply()external view returns(uint256){
        return _totalSupply;
    } 
    
    
    function BalacneOf(address _owner) external view returns(uint256 balance){
        return _balances[_owner];
    }
    
    function Transfer(address _to , uint256 value) external returns(bool success){
    require(value > 0 && _balances[msg.sender] >= value);
    _balances[_to]+= value;
    _balances[msg.sender] -= value;
    
     emit Transfer(msg.sender,_to, value);
        return true;
    }
    function Approve(address _spender, uint256 value) external returns(bool success){
          require(value > 0 && _balances[msg.sender] >= value);
          
          _allowed[msg.sender][_spender] = value;
          emit Approvel(msg.sender, _spender ,value);
          
        
    }
    function TransferFrom(address _from , address _to, uint256 value) external returns (bool success){
        require(value > 0 && _balances[_from] >= value && _allowed[_from][_to] >= value);
    _balances[_to]+= value;
    _balances[_from] -= value;
    
    _allowed[_from][_to] -= value;
    
        return true;
    }
    function Allowance(address _owner, address _spender)external view returns(uint256 remaining){
        return _allowed[_owner][_spender];
    }
    
}

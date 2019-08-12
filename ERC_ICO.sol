pragma solidity ^0.5.3;

interface IERC20{
    
    function TotalSupply() external view returns(uint256);
    
    function BalacneOf(address _owner) external view returns(uint256 balance);
    
    function transfer(address _to , uint256 value) external returns(bool success);
    
    function Approve(address _spender, uint256 value) external returns(bool success);
    
    function TransferFrom(address _from , address _to, uint256 value) external returns (bool success);
    
    function Allowance(address _owner, address _spender)external view returns(uint256 remaining);
    
    event Transfer(address indexed _from,address indexed _to, uint256 value);
    event Approvel(address indexed _owner, address indexed _spender ,uint256 value);
    
}

contract ERC20Token is IERC20{
    
    mapping(address => uint256) public _balances;
    
    mapping(address => mapping(address => uint256))public _allowed;
    
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
    
    function transfer(address _to , uint256 value) public returns(bool success){
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
    function TransferFrom(address _from , address _to, uint256 value) public returns (bool success){
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

contract SKY is ERC20Token{
    
    //admin
    address public admin;
    //desopitAacount
    address payable recepient;
    
    //prince of token
    uint public TokenPrice = 1000000000000000;
    
    //hardcap
    uint public ICOTarget = 500000000000000000000;
    
    uint public RecivedFund;
    
    uint public MaxInvestment = 10000000000000000000;
    
    uint public MinInvestment = 1000000000000000000;
    
    enum Status {inactive , active ,stopped , completed}
    Status public icostatus;
    
    uint public icoStartTime = now;
    
    uint public icoEndTime = now + 43200;
    
    uint public StartTrading = icoEndTime;//can add time in seconds
    
    modifier OwnerOnly{
        if(msg.sender == admin){
            _;
        }
    }
    
    constructor(address payable _recipient)public{
        admin = msg.sender;
    recepient = _recipient;
    
    }
    
    function SetActiveStatus() public OwnerOnly{
        icostatus = Status.active;
    }
     function SetStopStatus() public OwnerOnly{
        icostatus = Status.stopped;
    }

    function GetIcoStatus() public view returns(Status){
        if(icostatus  == Status.stopped){
            return Status.stopped;
            
        }else if(block.timestamp >= icoStartTime && block.timestamp <= icoEndTime){
            return Status.active;
        }else if(block.timestamp <= icoStartTime){
            return Status.inactive;
        }else{
            return Status.completed;
        }
    }
   
    
    function Investing() payable public returns(bool){
        icostatus = GetIcoStatus();
        
        require(icostatus == Status.active,"INACTIVE");
        require(ICOTarget >= RecivedFund + msg.value , "Error");
        require(msg.value >= MinInvestment && msg.value <= MaxInvestment, "Error");
        uint Tokens = msg.value/TokenPrice;
        
         _balances[msg.sender] += Tokens;
         _balances[creator] -= Tokens;
         
         recepient.transfer(msg.value);
         
         RecivedFund += msg.value;
         
         return true;
         
    }
    function Burn() public returns (bool){
        icostatus = GetIcoStatus();
        
        require(icostatus == Status.completed,"ERROE");
        _balances[creator] = 0;
    }

    function transfer(address _to , uint256 value) public returns(bool success){
    require(block.timestamp > StartTrading, "not allowed");
    super.transfer(_to,value);
   
        return true;
    }
    
    function TransferFrom(address _from , address _to, uint256 value) public returns (bool success){
        require(block.timestamp > StartTrading, "not allowed");
    super.TransferFrom(_from,_to,value);
   
        return true;
    }


}


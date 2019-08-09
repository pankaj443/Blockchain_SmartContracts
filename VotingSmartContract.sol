pragma solidity ^0.5.3;

contract Voting{
    
    address public ContractOwner;
    
    address[] public CandidateList;
    
    mapping (address => uint8) public VotesReceived;
    
    address public winner;
    
    uint public WinnerVotes;
    
    
    constructor() public{
        
        ContractOwner = msg.sender;
    
    }
    
    modifier OnlyOwner{
        
        if(msg.sender == ContractOwner){
            _;
        }
    }
    
    function RegisteCandidate(address _candidate) OnlyOwner public{
        CandidateList.push(_candidate);
    }
    
    function Vote (address _candidate) public{
        VotesReceived[_candidate] += 1;
    }
     
}

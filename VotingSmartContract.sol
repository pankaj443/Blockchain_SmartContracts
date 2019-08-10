pragma solidity ^0.5.3;

contract Voting{
    
    address public ContractOwner;
    
    address[] public CandidateList;
    
    mapping (address => uint8) public VotesReceived;
    
    address public winner;
    
    uint public WinnerVotes;
    
    enum VotingStatus {NotStarted, Running, Completed}
    VotingStatus public status;
    
    constructor() public{
        
        ContractOwner = msg.sender;
    
    }
    
    modifier OnlyOwner{
        
        if(msg.sender == ContractOwner){
            _;
        }
    }
    
    function SetStatus() public{
        
        if(status != VotingStatus.Completed){
            status = VotingStatus.Running;
        }else{
            status = VotingStatus.Completed;
        }
        
    }
    
    function RegisteCandidate(address _candidate) OnlyOwner public{
        CandidateList.push(_candidate);
    }
    
    function Vote (address _candidate) public{
        require(Validate(_candidate),"INVALID CANDIDATE");
         require(status == VotingStatus.Running,"INVALID STATUS");
        VotesReceived[_candidate] += 1;
    }
    
   function Validate(address _candidate) public view returns(bool){
       for(uint  i =0;i< CandidateList.length ; i++){
           if(CandidateList[i] == _candidate){
               return true;
           }
       }
       return false;
   }
   
   function VoteCount(address _candidate) public view returns(uint){
         require(Validate(_candidate),"INVALID CANDIDATE");
         return VotesReceived[_candidate];
   }
   function Result() public{
       
       require(status == VotingStatus.Completed,"INVALID STATUS");
       
       for( uint i =0 ;i<CandidateList.length ;i++){
           if(VotesReceived [CandidateList[i]] > WinnerVotes){
               WinnerVotes = VotesReceived[CandidateList[i]];
               winner = CandidateList[i];
           }
       }
       
   }
   
   
     
}

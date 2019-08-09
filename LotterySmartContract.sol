pragma solidity ^0.5.3;

contract Lottery{
    
    address public owner;
    address payable [] public players;//payable coz we need to send winning player ethers

    constructor() public{
        owner = msg.sender;
    }
    
    modifier OwnerOnly{
        if(msg.sender == owner){
            _;
        }
        
    }
    
    function deposit() public payable{
        require(msg.value >= 1 ether);
        players.push(msg.sender);
    }
    
    function GenerateRandom() public view returns(uint){
        return uint(keccak256(abi.encodePacked(now,block.difficulty,players.length)));
    }
   

 function Winner() OwnerOnly public{
            uint randomNo = GenerateRandom();
            uint index = randomNo% players.length;
            
            address payable WinnerAddress;
            
            WinnerAddress = players[index];
            
            WinnerAddress.transfer(address(this).balance);
            
            players = new address payable[](0);
            
    }
    
}


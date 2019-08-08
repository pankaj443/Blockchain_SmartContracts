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
    
}

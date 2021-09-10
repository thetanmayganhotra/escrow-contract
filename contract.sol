pragma solidity ^0.7.0;

// SPDX-License-Identifier: MIT


contract Escrow {
    //variables
    
    enum state {NOT_INITIATED , AWAITING_PAYMENT , AWAITING_DELIVERY , COMPLETE }
    
    state public currstate;
    
    bool public isbuyerin;
    bool public issellerin;
    
    uint public price;
    
    address public buyer;
    address payable public seller;
    
    
    
    //modifiers
    
    modifier onlybuyer() {
        require(msg.sender == buyer ,"only buyer can call this function");
        _;
    }
    
    modifier escrownotstarted() {
        require(currstate == state.NOT_INITIATED,"contract has already started");
        _;
    }
    
    //functions
    
    constructor(address _buyer , address payable _seller , uint _price){
        buyer == _buyer;
        seller == _seller;
        price == _price * (1 ether);
        
        
    }

    function initcontract() escrownotstarted public {
        if(msg.sender == buyer){
            isbuyerin == true;
        }
        
        if(msg.sender == seller){
            issellerin == true;
        }
        if (isbuyerin && issellerin) {
            currstate = state.AWAITING_PAYMENT;
        }
        
        
    }
    
    function deposit() onlybuyer public payable{
        
        require(currstate == state.AWAITING_PAYMENT,"already paid");
        require(msg.value == price, "wrong deposit amount");
        currstate = state.AWAITING_DELIVERY;
        
        
    }

    function confirmdelivery() onlybuyer public payable{
        require(currstate == state.AWAITING_DELIVERY,"cannot confirm delivery");
        seller.transfer(price);
        currstate = state.COMPLETE;
        
        
         
    }

    
    function withdraw() onlybuyer public payable {
        require(currstate == state.AWAITING_DELIVERY,"cannot withdraw at this stage");
        payable(msg.sender).transfer(price);
        currstate = state.COMPLETE;
       
        
        
    }
}
pragma solidity ^0.6.12;

// SPDX-License-Identifier: GPL-3.0

import "./Ownable.sol";
import "./SafeMath.sol";

contract BallondOr is Ownable {

using SafeMath for uint256;

    struct Selectionnable {
        uint id;
        address ethadress;
        string name;
    }
    
    struct Selectionned {
        uint id;
        string name;
        uint voteCount;
    }
    
    struct Voters {
        uint id;
        bool hasVoted;
        address[] VoteContent;
    }
    
    uint public selectionnedCount;
    uint public selectionnableCount;
    uint public votersCount;

    bool public isVotingInSession;
    
    
    address[] Candidates = new address[](30);
    address[] VotersAddresses = new address[](30);
    
    mapping(uint => address) Results;
    mapping(address => Selectionnable) public selectionnable;
    mapping(address => Voters) public voters;
    mapping(address => Selectionned) public selectionned;
    
    event votedEvent (address _address, string confirm);

    function addVoter (address _address) public onlyOwner {
        require(!isVotingInSession, "Election has already started");
        
        votersCount++;
        voters[_address] = Voters(
                votersCount,
                false,
                new address[](5)
        );
    }
    
    function addSelectionnable (string memory _name, address _address) public onlyOwner {
        
        require(selectionnable[_address].id == 0, "Target already in the list");
        
        selectionnableCount++;
        selectionnable[_address] = Selectionnable(
            selectionnableCount,
            _address,
            _name
        );
    }
    
    function addSelectionned (address _address) public onlyOwner {
        require(!isVotingInSession, "Election has already started");
        
        require(selectionnable[_address].id != 0, "Target isn't in \"Selectionnable\" list.");
        
       selectionnedCount++;
        selectionned[_address] = Selectionned(
            selectionnedCount,
            selectionnable[_address].name,
            0
        );
        
        Candidates.push(_address);
    }
    
    /*function getVoter (address _address) public view returns (Voters){
        return voters[_address];
    }
    
    function getSelectionnable (address _address) public onlyOwner view returns (Selectionnable) {
        return selectionnable[_address];
    }
    
    function getSelectionned (address _address) public view returns (Selectionned){
        return selectionned[_address];
    }*/
    
    function remVoter (address _address) public onlyOwner {
        require(!isVotingInSession, "Election has already started");
        votersCount--;
        delete voters[_address];
    }
    
    function remSelectionnable (address _address) public onlyOwner {
        selectionnableCount--;
        delete selectionnable[_address];
    }
    
    function remSelectionned (address _address) public onlyOwner {
        require(!isVotingInSession, "Election has already started");
        selectionnedCount--;
        delete selectionned[_address];
    }
    
    function launchPoll () public onlyOwner {
        isVotingInSession = true;
    }
    

    function vote (address _firstChoice, address _secondChoice, address _thirdChoice, address _fourthChoice, address _fifthChoice) public {
        // require that they haven't voted before
        require(voters[msg.sender].id != 0, "You are not authorised to vote.");
        require(!voters[msg.sender].hasVoted, "You have already voted in this session.");

        // require a valid candidate
        require(selectionned[_firstChoice].id != 0 && selectionned[_secondChoice].id != 0 && selectionned[_thirdChoice].id != 0 
        && selectionned[_fourthChoice].id != 0 && selectionned[_fifthChoice].id != 0, "One or more of these address are not found.");

        selectionned[_firstChoice].voteCount += 5;
        selectionned[_secondChoice].voteCount += 4;
        selectionned[_thirdChoice].voteCount += 3;
        selectionned[_fourthChoice].voteCount += 2;
        selectionned[_fifthChoice].voteCount += 1;
        
        voters[msg.sender].VoteContent.push(_firstChoice);
        voters[msg.sender].VoteContent.push(_secondChoice);
        voters[msg.sender].VoteContent.push(_thirdChoice);
        voters[msg.sender].VoteContent.push(_fourthChoice);
        voters[msg.sender].VoteContent.push(_fifthChoice);

        // trigger voted event
        emit votedEvent (msg.sender, "Votre vote a été pris en compte");
    }
    
    /*function endPoll () public onlyOwner {
        isVotingInSession = false;
        
        address tempaddress;
        uint tempvotecount;
        for(uint i = 0; i < Candidates.length; i++){
            tempaddress = Candidates[i];
            tempvotecount = selectionned[tempaddress].voteCount;
            if(Results[tempvotecount]){
                
            }    
        }
    }*/
    
    function getResults() public {
        
    }
}

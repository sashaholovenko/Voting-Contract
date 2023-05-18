// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingContract {
    struct Candidate {
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public voters;

    uint public totalVotes;
    bool public votingOpen;
    address public owner;
    uint public candidatesCount;

    event VoteCast(address indexed voter, uint indexed candidateId);

    constructor(string[] memory candidateNames) {
        require(candidateNames.length > 0, "At least one candidate is required");

        for (uint i = 0; i < candidateNames.length; i++) {
            candidates[i + 1] = Candidate(candidateNames[i], 0);
            candidatesCount++;
        }

        votingOpen = true;
        owner = msg.sender; 
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can close voting");
        _;
    }

    function vote(uint candidateId) public {
        require(votingOpen, "Voting is closed");
        require(candidateId > 0 && candidateId <= candidatesCount, "Invalid candidate ID");
        require(!voters[msg.sender], "You have already voted");

        candidates[candidateId].voteCount++;
        voters[msg.sender] = true;
        totalVotes++;

        emit VoteCast(msg.sender, candidateId);
    }

    function getCandidatesCount() public view returns (uint) {
        return candidatesCount;
    }

    function closeVoting() public onlyOwner {
        votingOpen = false;
    }
}
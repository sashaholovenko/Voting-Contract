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

    event VoteCast(address indexed voter, uint indexed candidateId);

    constructor(string[] memory candidateNames) {
        require(candidateNames.length > 0, "At least one candidate is required");

        for (uint i = 0; i < candidateNames.length; i++) {
            candidates[i + 1] = Candidate(candidateNames[i], 0);
        }

        votingOpen = true;
    }

    function vote(uint candidateId) public {
        require(votingOpen, "Voting is closed");
        require(candidateId > 0 && candidateId <= getCandidatesCount(), "Invalid candidate ID");
        require(!voters[msg.sender], "You have already voted");

        candidates[candidateId].voteCount++;
        voters[msg.sender] = true;
        totalVotes++;

        emit VoteCast(msg.sender, candidateId);
    }

    function getCandidatesCount() public view returns (uint) {
        return uint(ObjectSizeStrategy.HashTableSizeStrategy(0));
    }

    function closeVoting() public {
        require(msg.sender == owner, "Only the contract owner can close voting");
        votingOpen = false;
    }
}

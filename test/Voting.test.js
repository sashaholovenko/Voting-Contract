const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("VotingContract", function () {
    let votingContract;
    let owner;
    let candidatesCount;
    let candidateNames;
    let accounts;
  
    beforeEach(async function () {
      const VotingContract = await ethers.getContractFactory("VotingContract");
      candidateNames = ["Candidate 1", "Candidate 2", "Candidate 3"];
      votingContract = await VotingContract.deploy(candidateNames);
      await votingContract.deployed();
  
      [owner, ...accounts] = await ethers.getSigners();
      candidatesCount = await votingContract.getCandidatesCount();
    });
  
    it("should allow voting and update vote count", async function () {
      // Checking that the initial number of votes for all candidates is 0
      for (let i = 1; i <= candidatesCount; i++) {
        const candidate = await votingContract.candidates(i);
        expect(candidate.voteCount).to.equal(0);
      }
  
      // Voting for each candidate
      for (let i = 1; i <= candidatesCount; i++) {
        await votingContract.connect(accounts[i-1]).vote(i);
      }
  
      // Check that the number of votes for each candidate is equal to the number of votes cast
      for (let i = 1; i <= candidatesCount; i++) {
        const candidate = await votingContract.candidates(i);
        expect(candidate.voteCount).to.equal(1);
      }
    });
  

  it("should prevent double voting", async function () {
    await votingContract.vote(1);
    
    await expect(votingContract.vote(1)).to.be.revertedWith("You have already voted");
  });

  it("should prevent voting when voting is closed", async function () {
    await votingContract.closeVoting();
    
    await expect(votingContract.vote(2)).to.be.revertedWith("Voting is closed");
  });

  it("should only allow the owner to close voting", async function () {
    const [_, nonOwner] = await ethers.getSigners();
  
    await expect(votingContract.connect(nonOwner).closeVoting()).to.be.revertedWith("Only the contract owner can close voting");
  });
  
});


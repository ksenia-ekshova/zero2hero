// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Voting {

    struct Voter {
        uint weight; // weight is accumulated by delegation
        bool voted;  // if true, that person already voted
        address delegate; // person delegated to
        uint vote;   // index of the voted proposal
    }

    struct Proposal {
        bytes32 name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }

    address public owner;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;

    //example for deploy ["0x6361747300000000000000000000000000000000000000000000000000000000", "0x646f677300000000000000000000000000000000000000000000000000000000"]

    constructor(bytes32[] memory proposalNames) {
        owner = msg.sender;
        voters[owner].weight = 1;

        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

     //only users from white list can voting
    function addToWiteList(address voter) public {
        require(
            msg.sender == owner,
            "Only owner can add to white list."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    //give your vote by proposal number (f.e. 0)
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        /* If 'proposal' is out of the range of the array,
        this will throw automatically and revert all changes.
        */
        proposals[proposal].voteCount += sender.weight;
    }

    /* 
     Computes the winning proposal taking all previous votes into account.
     return winningProposal_ index of winning proposal in the proposals array
     */
    function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    /** 
     Calls winningProposal() function to get the index of the winner contained in the proposals array and then
     return winnerName_ the name of the winner
     */
    function winnerName() public view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
}
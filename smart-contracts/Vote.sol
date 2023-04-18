// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Создайте контракт для системы голосования
Добавьте функцию для создания новой сессии голосования, включая тему и варианты для голосования.
Добавьте функцию позволяющую избирателям отдать свой голос за определенный вариант.
Добавьте функцию для извлечения результатов голосования.
*/

contract Vote {
    struct Proposal {
        string topic;
        uint256 option1;
        uint256 option2;
        bool completed;
    }
    mapping(uint8 => Proposal) public proposalStatus;

    function createProposal(string memory _topic, uint8 _id) public {
        Proposal storage proposal = proposalStatus[_id];
        proposal.topic = _topic;
    }

    function vote(uint8 _option, uint8 _id) public {
        Proposal storage proposal = proposalStatus[_id];
        require(!proposal.completed);

        if (_option == 0) {
            proposal.option1++;
        }
        if (_option == 1) {
            proposal.option2++;
        }
        if (proposal.option1 + proposal.option2 == 10) {
            proposal.completed = true;
        }
    }

    function getResults(
        uint8 _id
    )
        public
        view
        returns (
            string memory topic,
            uint256 option1,
            uint256 option2,
            bool completed
        )
    {
        Proposal storage proposal = proposalStatus[_id];
        return (
            proposal.topic,
            proposal.option1,
            proposal.option1,
            proposal.completed
        );
    }
}

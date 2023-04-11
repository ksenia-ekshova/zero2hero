// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Transmitter is Ownable {
    uint public roundCounter;
    uint public currentRound;
    address public sequencer;
    address[] public signers;
    address[] public submittedSigners;
    uint private constant MAX_PRICE_DIFF_PERCENT = 1;
    uint private constant MIN_NODES = 2;
    uint private savedPrice = 0;
    uint private startRoundTimestamp;
    uint private endRoundTimestamp;
    uint private submittedDataByNodeCount;

    struct Data {
        uint price;
        uint timestamp;
    }

    mapping(address => Data) private dataByNode;

    event round(uint roundId, uint timestamp, string message);
    event dataByNodeSaved(uint roundId, uint timestamp, uint price, string message);
    event roundResultLog(uint roundId, uint timestamp, uint price, string message);
    event getPrice (uint roundId, uint price, string message);
    event signerSubmitted (address signer, uint submittedSigners, string message);

    constructor(address _sequencer) {
        sequencer = _sequencer;
        roundCounter = 0;
    }

    modifier onlySequencer() {
        require(msg.sender == sequencer, "Wrong transaction initiator");
        _;
    }

    function startRound() external onlySequencer {
        require(currentRound == 0, "Round already in progress");

        clearData();   
        roundCounter++;    
        currentRound = roundCounter;
        startRoundTimestamp = block.timestamp;
        emit round(currentRound, block.timestamp, "Round started");
    }

    function transmit(uint timestamp, uint price, uint8 v, bytes32 r, bytes32 s) external {
        require(currentRound == roundCounter, "Old round ended, new round not started");
        
        bytes32 payloadHash = keccak256(abi.encode(currentRound, timestamp, price));
        bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", payloadHash));
        address signer = ecrecover(messageHash, v, r, s);

        signers.push(signer);
        dataByNode[signer].timestamp = timestamp;
        dataByNode[signer].price = price;

        emit dataByNodeSaved(currentRound, timestamp, price, "Data by Node saved");
    }

    function stopRound() external onlySequencer {
        require(currentRound != 0, "New round is not started");
        endRoundTimestamp = block.timestamp;
        emit round(currentRound, block.timestamp, "Round ended");

        require(savedPrice != 0, "Reference price not set in the first round");
        //require(submittedDataByNodeCount >= MIN_NODES, "Not enough nodes have transmitted their price data");

        if (dataValidation() == false){
            emit roundResultLog(currentRound, endRoundTimestamp, savedPrice, "Round result - not enough valid data from nodes, price not changed");
            currentRound = 0;
        } else {
            savedPrice = averagePrice();
            emit roundResultLog(currentRound, endRoundTimestamp, savedPrice, "Round result - new changed saved");
            currentRound = 0;
        }
    }

    function averagePrice() private returns (uint) {
        uint totalPrice = 0;
        uint numSigners = 0;

        for (uint i = 0; i < submittedSigners.length; i++) {
            address signer = submittedSigners[i];
            totalPrice += dataByNode[signer].price;
            numSigners++;
            emit signerSubmitted (signer, numSigners, "signer submitted");
        }

        return (totalPrice / numSigners);
    }

    function dataValidation() private returns(bool) {
        uint maxAllowedDiff = (savedPrice * MAX_PRICE_DIFF_PERCENT) / 100;
        for (uint i = 0; i < signers.length; i++) {
            address signer = signers[i];
            uint price = dataByNode[signer].price;
            uint timestamp = dataByNode[signer].timestamp;
            uint priceDifference = price > savedPrice ? price - savedPrice : savedPrice - price;
            if (priceDifference > maxAllowedDiff) {
                delete dataByNode[signer];
            } else if (timestamp < startRoundTimestamp || timestamp > endRoundTimestamp) {
                delete dataByNode[signer];
            } else {
                submittedSigners.push(signer);
                submittedDataByNodeCount++;
                emit signerSubmitted (signer, submittedDataByNodeCount, "signer submitted");
            }
        }
        if (submittedDataByNodeCount < MIN_NODES) {
            return false;
        }
        return true;
    }

    function roundResult() public returns (uint, uint) {
        emit getPrice (roundCounter, savedPrice, "Round and price");
        return (roundCounter, savedPrice);
    }

    function setSavedPrice(uint _savedPrice) public onlyOwner {
        savedPrice = _savedPrice;
    }

    function clearData() internal {
        for (uint i = 0; i < submittedSigners.length; i++) {
            delete dataByNode[submittedSigners[i]];
        }
        delete submittedSigners;
        delete signers;
        submittedDataByNodeCount = 0;
    }
}


//ex uint timestamp, uint price, uint8 v, bytes32 r, bytes32 s
//good data for test (change timestamp to actual)
//1681245554, 98, 27, 0x45d70fbf22732c0c156f02605a897bac77d52b98dbf2eb0c1a6d61d6fb26b6e2, 0x67a1f6af51d419f1b7d259ef70ab20dc7f9d473050b2a2bc24a3f3c184e51bc6
//1681245554, 101, 27, 0x45d70fbf22732c0c156f02605a894bac77d62b98dbf2eb0c1a6d61d6fb26b6e2, 0x67a1f6af51d419f1b7d243ef70ab20dc7f9d473050b2a2bc24a3f3c184e51bc6
//1681245554, 92, 27, 0x45d70fbf22732c0c156f02705a894bac77d62b98dbf2eb0c1a6d61d6fb26b6e2, 0x67a1f6af51d419f1b7d443ef70ab20dc7f9d473050b2a2bc24a3f3c184e51bc6



// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract PCS is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _tokenIdCounter;
    uint256 private constant MAX_SUPPLY = 7;
    uint256 private constant MIN_COST = 0.001 ether;
    string private constant BASE_URI = "ipfs://QmZ3Bjzh59mARTHi458osN2cVKMW5LFrXBAEss85Gy4Y6s/";
    mapping (uint256 => uint256) private tokenPrice;

    constructor() ERC721("Pixel Cats and Sunset", "PCS") {
    }

    function _baseURI() internal pure override returns (string memory) {
        return BASE_URI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return string(abi.encodePacked(BASE_URI, tokenId.toString(), ".json"));
    }

    function safeMint(address to) public payable onlyOwner {
        require(_tokenIdCounter.current() < MAX_SUPPLY, "Max supply reached");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function createItem() external payable onlyOwner {
        require(_tokenIdCounter.current() < MAX_SUPPLY, "Max supply reached");
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(msg.sender, tokenId);
    }

    function listItem(uint256 tokenId, uint256 cost) external onlyOwner {
        require(cost >= MIN_COST, "Cost value must be greater than or equal to MIN_COST");
        tokenPrice[tokenId] = cost;
    }

    function buyItem(uint256 tokenId) external payable {
        require(_exists(tokenId), "Token does not exist");
        require(msg.value >= tokenPrice[tokenId], "Insufficient payment");
        require(tokenPrice[tokenId] > 0, "Token doesn't have price");
        uint256 cost = tokenPrice[tokenId];
        _safeTransfer(owner(), msg.sender, tokenId, "");
        payable(owner()).transfer(cost);
        cancel(tokenId);
    }

    function cancel(uint256 tokenId) public onlyOwner {
        delete tokenPrice[tokenId];
    }
}

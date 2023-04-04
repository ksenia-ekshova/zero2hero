//describe("NFT", () => {}}) - alternative function declaration

const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("NFT", function () {
  let NFT;
  let nft;

  const BaseURI = "ipfs://QmVsqkH7KmsRg8tyFp7Dv31VSjA1iNLWPSMkeSz22igiN1/";

  beforeEach(async () => {
    NFT = await ethers.getContractFactory("NFT");
    nft = await NFT.deploy();
    await nft.deployed();
  });

  it("Should deploy the contract", async function() {
  expect(nft.address).to.be.properAddress;
  })

  it("Should update baseURI", async function() {
  await expect(nft.changeBaseURI(BaseURI)).to.be.not.reverted;
  })

  it("Should return the correct name and symbol", async function () {
    assert.equal(await nft.name(), "PixelCats");
    assert.equal(await nft.symbol(), "PXLC");
  })

  it("Should have a total supply of 0 at deployment", async function () {
    expect(await nft.totalSupply()).to.equal(0);
  });

  it("Should mint an NFT to the owner", async function () {
    const [owner, user] = await ethers.getSigners();
    await nft.safeMint(owner.address, { value: ethers.utils.parseEther("0.001") });
    expect(await nft.totalSupply()).to.equal(1);
    expect(await nft.ownerOf(0)).to.equal(owner.address);
  });

  it("Should not mint an NFT if the cost is not paid", async function () {
    const [owner, user] = await ethers.getSigners();
    await expect(nft.safeMint(owner.address, { value: ethers.utils.parseEther("0.0001") })).to.be.revertedWith(
      "Please add valid amount of ETH"
    );
    expect(await nft.totalSupply()).to.equal(0);
  });

  it("Should not mint more than the maximum supply", async function () {
    const [owner, user] = await ethers.getSigners();
    const amount = ethers.utils.parseEther("0.001");
    for (let i = 0; i < 5; i++) {
      await nft.safeMint(owner.address, { value: amount });
    }
    await expect(nft.safeMint(owner.address, { value: amount })).to.be.revertedWith("You reached max supply");
    expect(await nft.totalSupply()).to.equal(5);
  });
});



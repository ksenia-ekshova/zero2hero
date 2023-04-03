const hre = require("hardhat");
	
	async function main() {
	  const [owner] = await ethers.getSigners();
	
	  const Token = await hre.ethers.getContractFactory("NFT");
	  const token = await Token.deploy();
	  await token.deployed();
	
	  console.log(`owner address: ${owner.address}`);
	  
	  /*
	  await token.safeMint(owner.address, {
	    value: ethers.utils.parseEther("0.001"),
	  });
	  */

	  //заминтить NFT
	  //можно указать, сколько NFT нужно заминтить при деплое
	  for (let i = 0; i < 5; i++) {
		await token.safeMint(owner.address, {
			value: ethers.utils.parseEther("0.001"),
		  });
	  }

	  console.log(`Deployed token address: ${token.address}`);
	
	  const WAIT_BLOCK_CONFIRMATIONS = 6;
	  await token.deployTransaction.wait(WAIT_BLOCK_CONFIRMATIONS);
	
	  console.log(`Contract deployed to ${token.address} on ${network.name}`);
	
	  console.log(`Verifying contract on Etherscan...`);
	
	  await run(`verify:verify`, {
	    address: token.address,
	    constructorArguments: [],
	  });
	}
	
	// We recommend this pattern to be able to use async/await everywhere
	// and properly handle errors.
	main().catch((error) => {
	  console.error(error);
	  process.exitCode = 1;
	});
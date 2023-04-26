require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();
require("solidity-coverage");
require("hardhat-gas-reporter");

const BNBT_PRIVATE_KEY = process.env.BNBT_PRIVATE_KEY;
const BNBT_RPC_URL = process.env.BNBT_RPC_URL;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

	
	/** @type import('hardhat/config').HardhatUserConfig */
	module.exports = {
	  solidity: "0.8.18",
    defaultNetwork: "hardhat",
	  networks: {
	    bnbtestnet: {
	      url: BNBT_RPC_URL,
	      accounts: [BNBT_PRIVATE_KEY],
	    },
	  },
	  gasReporter: {
		enabled: true,
	  },
	  etherscan: {
	    apiKey: ETHERSCAN_API_KEY, // Your Etherscan API key
	  },
	};
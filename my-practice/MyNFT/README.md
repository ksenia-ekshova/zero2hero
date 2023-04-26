# Sample Hardhat Project

# Commands

# Need to set .env (see .env.example)

BNBT_RPC_URL
BNBT_PRIVATE_KEY
ETHERSCAN_API_KEY

## Local deploy
```console
npx hardhat node
npx hardhat run scripts/deploy.js
```

## Compile
```console
npx hardhat clean && npx hardhat compile
```

## Tests
```console
npx hardhat test
npx hardhat coverage
```

## Deploy (with mint)
```console
npx hardhat run scripts/deploy.js --network bnbtestnet
```

## Other
This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```
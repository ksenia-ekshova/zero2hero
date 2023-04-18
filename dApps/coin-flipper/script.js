const contractAddress = "0x0afDe43aD80366CA3BA140eDc1264417ce771d59";
const abi = [
	{
		"inputs": [],
		"stateMutability": "payable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "player",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isWinner",
				"type": "bool"
			}
		],
		"name": "GamePlayed",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint8",
				"name": "_option",
				"type": "uint8"
			}
		],
		"name": "playGame",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"stateMutability": "payable",
		"type": "receive"
	}
];
const provider = new ethers.providers.Web3Provider(window.ethereum, 97); //bnbchain testnet
let signer;
let contract;

//Нужно будет создать функцию
provider.send("eth_requestAccounts", []).then(() => {
  provider.listAccounts().then((accounts) => {
    signer = provider.getSigner(accounts[0]);
    contract = new ethers.Contract(contractAddress, abi, signer);
  });
});

async function play(option) {
  //let amountInWei = ethers.utils.parseEther((0.001).toString());
  let amountInEth = document.getElementById("bet").value;
  //document.getElementById("amountInEth").value;
  let amountInWei = ethers.utils.parseEther(amountInEth.toString());
  console.log(amountInEth);

  await contract.playGame(option, { value: amountInWei });
}

async function getGamePlayed() {
  let response = await contract.playGame(num,  {value: amountInWei});
    // console.log(response);
    const res = await response.wait();
    let result = res.events[0].args.isWinner;
    let resultLogs = `result: ${result == "false" ? "LOSE 😥" : "WIN 🎉"}`;
    // console.log(res);
    let message = res.events[0].args.message;

    // let resultLog = document.getElementById("resultLog");
    // let newLog = resultLog.value + "You choose " + choice + ". You " + message + " ";
    // resultLog.innerText = newLog;

    let resultLog = document.getElementById("result");
    resultLog.innerText = resultLogs;
    console.log(resultLog);
}

const constractAddress = "0xcE8e24940C2C1aBb806278f6F3F0B6539F690d0c";
const abi = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "noteSender",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "addedNote",
				"type": "string"
			}
		],
		"name": "NoteAdded",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_note",
				"type": "string"
			}
		],
		"name": "setNote",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"stateMutability": "payable",
		"type": "receive"
	},
	{
		"inputs": [],
		"name": "getNote",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
];

const provider = new ethers.providers.Web3provider(window.etherium, 97);

let signer;
let contract;

//запрашиваем аккаунты
//тогда получаем лист аккаунтов
//тогда мы запрашиваем через провайдера лист акаунтов и берем оттуда самый первый и записываем в signer
//signer - самый первый активный аккаунт
provider.send("eth_requestAccounts", []).then(() => {
    provider.listAccounts().then((accounts) => {
        signer = provider.getSigner(accounts[0]);
        contract = new ethers.Contract(constractAddress, abi, signer);
        console.log;
    });
});
//так подключаемся к Web3

async function setNote(){
	const note = document.getElementsById("note").value;
    await contract.setNote(note);
}//вызываем наши функции из контракта?

async function getNote(){
	const note = await contract.getNote();

	note = document.getElementsById("result").innerText;
}
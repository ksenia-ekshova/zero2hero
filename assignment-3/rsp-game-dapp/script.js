const contractAddress = "0x6Af798bC579519f7fA07A9DfdD466EF593c7089e";

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
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "opponentResult",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "message",
				"type": "string"
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

// Подключаемся к web3 провайдеру (метамаск)
const provider = new ethers.providers.Web3Provider(window.ethereum, 97);

let signer;
let contract;

const choicesMap = {
    0: "Rock",
    1: "Scissors",
    2: "Paper",
};

let userScoreCount = 0;
let compScoreCount = 0;


//Запрашиваем аккаунты пользователя и подключаемся к первому аккаунту
provider.send("eth_requestAccounts", []).then(() => {
  provider.listAccounts().then((accounts) => {
    signer = provider.getSigner(accounts[0]);
    //Создаем объект контракта
    contract = new ethers.Contract(contractAddress, abi, signer);
    console.log(contract);

  });
});


async function playGame(num) {
    //let response = await contract.playGame(1);
    //console.log(response);
    //const options = {
      //  value: ethers.prototype.toNumber(1),
        //gasLimit: 0.0001,
        //}
console.log(num);
        let amountInEth = document.getElementById("bet").value;
        //document.getElementById("amountInEth").value;
        let amountInWei = ethers.utils.parseEther(amountInEth.toString());

    let response = await contract.playGame(num,  {value: amountInWei});
    // console.log(response);
    const res = await response.wait();
    // console.log(res);
    let choice = choicesMap[num];
    let message = res.events[0].args.message;

    // let resultLog = document.getElementById("resultLog");
    // let newLog = resultLog.value + "You choose " + choice + ". You " + message + " ";
    // resultLog.innerText = newLog;

    let resultLog = document.getElementById("result");
    let newLog = "You have chosen " + choice + " - " + message;
    resultLog.innerText = newLog;

    if (message === "win!"){
        userScoreCount++;
    }
    else if (message === "fail") {
        compScoreCount++;
    }

    let computerScoreSpan = document.getElementById('computer-score');
    computerScoreSpan.innerHTML = compScoreCount;

    let userScoreSpan = document.getElementById('user-score');
    userScoreSpan.innerHTML = userScoreCount;




    //<span id="user-score">0</span>:<span id="computer-score">0</span>

    handleEvent();
}




/*
async function handleEvent(){
const receipt = await ethers.provider.getTransactionReceipt("0xfbf4c6cba67cdd8527cf8acf925f641669ce6aa9b8d7dd09dc292e93515cb7d3");
let abi = [ "event GamePlayed(address player, bool isWinner, uint256 opponentResult, string message)" ];
let iface = new ethers.utils.Interface(abi);
let log = iface.parseLog(receipt.logs[1]); // here you can add your own logic to find the correct log
const {player, isWinner, opponentResult, message} = log.args;
console.log(log.args);
}

handleEvent();*/




async function handleEvent(){

    //console.log(await contract.filters.CoinFlipped());
    let queryResult =  await contract.queryFilter('GamePlayed', await provider.getBlockNumber() -5000, await provider.getBlockNumber());
    //добавить условие, если queryResult.length ===0
    let queryResultRecent = queryResult[queryResult.length-1]
    let player = await queryResultRecent.args.player.toString();
    let isWinner = await queryResultRecent.args.isWinner.toString();
    let opponentResult = await queryResultRecent.args.opponentResult.toString();
    let message = await queryResultRecent.args.message.toString();

    let resultLogs = `
    player: ${player}, 
    isWinner: ${isWinner},
    opponentResult: ${opponentResult}, 
    message: ${message}`;
    console.log(resultLogs);

    let resultLog = document.getElementById("resultLog");
    resultLog.innerText = resultLogs;
    
}


































let userScore = 0;
let computerScore = 0;

const userScore_span = document.getElementById('user-score');
const computerScore_span = document.getElementById('computer-score');
const result_p = document.querySelector('.result > p');
//querySelector - чтобы выбирать элементы не по id
const rock_div = document.getElementById('r');
const paper_div = document.getElementById('p');
const scissors_div = document.getElementById('s');



function getComputerChoice(){
    const choices = ['r', 'p', 's'];
    const randomNumber = Math.floor(Math.random()*3);
    return choices[randomNumber];
}

function convertToWord(letter){
    if(letter === 'r') return 'Rock';
    if(letter === 'p') return 'Paper';
    return 'Scissors';
}

function win(userChoice, computerChoice) {
    userScore++;
    userScore_span.innerHTML = userScore;
    computerScore_span.innerHTML = computerScore;
    result_p.innerHTML = `${convertToWord(userChoice)} beats ${convertToWord(computerChoice)}. You win!`;
    //alternative 
    //result_p.innerHTML = convertToWord(userChoice) + "beats" + convertToWord(computerChoice) + "You win!"";
}

function lose(userChoice, computerChoice) {
    computerScore++;
    userScore_span.innerHTML = userScore;
    computerScore_span.innerHTML = computerScore;
    result_p.innerHTML = `${convertToWord(userChoice)} loses to ${convertToWord(computerChoice)}. You lost...`;
}

function draw(userChoice, computerChoice) {
    result_p.innerHTML = `${convertToWord(userChoice)} equals to ${convertToWord(computerChoice)}. It's a draw`;
}


/*
function game(userChoice){
    const computerChoice = getComputerChoice();

    switch(userChoice + computerChoice){
        case 'pr':
        case 'rs':
        case 'sp':
            win(userChoice, computerChoice);
            break;
        
        case 'rp':
        case 'ps':
        case 'sr':
            lose(userChoice, computerChoice);
            break;

        case 'rr':
        case 'pp':
        case 'ss':
            draw(userChoice, computerChoice);
            break;
             
    }
}*/




function main(){

    rock_div.addEventListener('click', function(){
        playGame(0);
    })

    scissors_div.addEventListener('click', function(){
        playGame(1);
    })

    paper_div.addEventListener('click', function(){
        playGame(2);
    })

    
    
}

main();


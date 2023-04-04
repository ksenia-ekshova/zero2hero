// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0; 
 
contract StoneScissorsPaper{
 
    constructor() payable { 
    } 
    //0.0001 BNB = 100000 gwei 

    //0 - stone
    //1 - scissors
    //2 - paper

    event GamePlayed(address player, bool isWinner, uint256 opponentResult, string message); 
 
    function playGame(uint8 _option) payable public returns (bool){ 
        require(_option <=2, "You can choose only 0 (stone), 1 (scissors) or 2 (paper)"); 
        require(address(this).balance >= msg.value*2, "Smart-contract run out of funds"); 
        //В данном смарт-контракте должна быть возможность играть на сумму от 0.0001 tBNB        
        require(msg.value >= 0.0001 ether, "Bet should to be 0.0001 BNB or more");//0.0001 BNB = 100000 gwei 

        uint256 _output = block.timestamp%3;//pseudorandom 
 
        if (_option == _output){ 
            //ничья, ставка возвращается игроку
            payable(msg.sender).transfer(msg.value);  
            emit GamePlayed(msg.sender, false, _output, "no one won"); 
            return false; 
            }
            else if  (((_option == 0) && (_output==1))||((_option == 1) && (_output==2))||((_option == 2) && (_output==0))){
                //камень и бумага/ножницы и камень/бумага и ножницы - победа (ставка*2 отправляется игроку)
                payable(msg.sender).transfer(msg.value*2);  
                emit GamePlayed(msg.sender, true, _output, "win!"); 
                return true; 
            }
            emit GamePlayed(msg.sender, false, _output, "fail"); 
            return false;
            //проигрыш
        } 
 
    receive () external payable {} 
    
}

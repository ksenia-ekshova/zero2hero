// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//openzeepelin => secure standarts
//ERC = Ethereum Request for Comments
//ERC20 = token

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20{

    constructor() ERC20("MyToken","MTKN"){
        _mint(msg.sender, 100*10**18);
    }
    
}

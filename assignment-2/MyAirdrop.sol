// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface MyToken{
    function transfer(address _to, uint256 _amount) external;
    function transferFrom(address _from, address _to, uint256 _amount) external;
    //в интерфейсах всегда external
}

contract AirdropToken{
    
    //мы должны депонировать монеты в смарт-контракт AirdropToken
    function airdropWithTransfer(
        MyToken _token, 
        address[] memory _addressArray, 
        uint256[] memory _amountArray) public {

            for (uint8 i = 0; i<_addressArray.length; i++) 
            {
                 _token.transfer(_addressArray[i], _amountArray[i]);
            }
        
    }

    //мы должны сделать appprove() монет для адресса смарт-контракта AirdropToken
    function airdropWithTransferFrom(
        MyToken _token, 
        address[] memory _addressArray, 
        uint256[] memory _amountArray) public {

            for (uint8 i = 0; i<_addressArray.length; i++) 
            {
                 _token.transferFrom(msg.sender, _addressArray[i], _amountArray[i]);
            }
        
    }


}

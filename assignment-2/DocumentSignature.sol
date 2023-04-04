// SPDX-License-Identifier: GPL-3.0 
 
pragma solidity >=0.7.0 <0.9.0; 
 
 contract DocumentSignature { 
    address[] public whitelist; 
 
    event AddressAdded(address indexed account, string message); 
    event ProtocolSigned(address indexed account, string message); 
 
   // Добавляет address в белый список 
    function addToWhitelist(address account)  public { 
        require(!isWhitelisted(account), "Address is already whitelisted"); 
        whitelist.push(account); 
        emit AddressAdded(account, "Address added to white list"); 
    } 
 
   // Проверяет, есть ли address в белом списке, если есть - возвращает true
    function isWhitelisted(address account) public view returns (bool) { 
        for (uint256 i = 0; i < whitelist.length; i++) { 
            if (whitelist[i] == account) { 
                return true; 
            } 
        } 
        return false; 
    } 
 
    function proposal() public { 
    // Проверка, есть ли address в белом списке 
        require(isWhitelisted(msg.sender), "Only whitelisted addresses can sign the proposal"); 
        emit ProtocolSigned(msg.sender, "Document signed"); 
    } 
}
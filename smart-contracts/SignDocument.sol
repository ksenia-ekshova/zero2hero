/*Задача 1 - Подпись документа (group)

Разработать смарт-контракт “подпись документа”
Добавить 2 или более адресов в “белый список” 
Адреса из белого списка могут подписать документ (подписать функцию)
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SignDocument {
    struct Document {
        address signer1;
        address signer2;
        bool signed;
    }

    mapping(address => bool) public whitelstiedAddresses;
    Document[] public document;

    constructor(address[] memory addressWhite) {
        for (uint256 i = 0; i < addressWhite.length; i++) {
            whitelstiedAddresses[addressWhite[i]] = true;
        }
    }

    function sign() public {
        require(
            whitelstiedAddresses[msg.sender],
            "Address is not in whitelist"
        );
        document.push(Document(msg.sender, address(0), false));
        //null => non existing value
    }

    function signSecond() public {
        Document storage doc = document[document.length - 1];

        require(
            whitelstiedAddresses[msg.sender],
            "Address is not in whitelist"
        );
        require(doc.signer1 != msg.sender, "You can not sign document again");

        doc.signer2 = msg.sender;
        doc.signed = true;
    }
}

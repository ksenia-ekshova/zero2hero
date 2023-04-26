// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./MyERC20.sol";

contract MyToken is MyErc20 {
    constructor() MyErc20("My Token", "MTKN") {
    }
}
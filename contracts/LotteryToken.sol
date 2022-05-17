// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract LotteryToken is ERC20, ERC20Burnable {
    constructor(uint256 initialSupply) public ERC20("LOTTERY", "LOT") {
        _mint(msg.sender, initialSupply);
    }
}
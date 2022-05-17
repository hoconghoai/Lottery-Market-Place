// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./LotteryToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MarketPlace is Ownable {
    address constant LOTTERY_TOKEN_ADDRESS = address(0);
    bool running = false;
    struct Ticket {
        uint256 Number;
        uint256 Time;
    }
    address[] buyerAddesses;
    mapping(address => Ticket[]) buyers;
    uint256[] numbers;
    mapping(uint256 => address[]) lotteryNumbers;
    uint256 luckyNumber;
    uint256 minLotteryNumber;
    uint256 maxLotteryNumber;

    function startLotterySession(uint256 _minLotteryNumber, uint256 _maxLotteryNumber) public onlyOwner {
        require(running, "Lottery session is running.");
        minLotteryNumber = _minLotteryNumber;
        maxLotteryNumber = _maxLotteryNumber;
        luckyNumber = 0;
        _clearBuyers();
        running = true;
    }

    function _clearBuyers() internal {
        for(uint256 i = 0; i < buyerAddesses.length; i++) {
            address buyerAddress = buyerAddesses[i];
            delete buyers[buyerAddress];
        }
    }

    function finishLotterySession() public  onlyOwner {
        require(running, "Lottery session was ended.");
        running = false;
    }

    function _burnToken(uint256 amount) internal {
        (bool success, ) = LOTTERY_TOKEN_ADDRESS.call(abi.encodeWithSignature("burn(uint256)", amount));
        require (success, "Error when burn.");
    }
}
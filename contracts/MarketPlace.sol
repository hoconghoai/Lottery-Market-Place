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
    uint256 price;

    event StartLotterySession(uint256 minLotteryNumber, uint256 maxLotteryNumber);
    event FinishLotterySession();

    function buyTicket() public {
        _pay(price);
        _burnToken(price * 1 / 10);
    }

    function _pay(uint256 _amount) internal {
        (bool success, ) = LOTTERY_TOKEN_ADDRESS.call(abi.encodeWithSignature("approve(address, uint256)", address(this), _amount));
        require(success, "User don't allow to withdraw.");
        (bool success1, ) = LOTTERY_TOKEN_ADDRESS.call(abi.encodeWithSignature("transferFrom(address, address, uint256)", msg.sender, address(this), _amount * 9 / 10));
        require(success1, "Error when withdraw.");
    }

    function balanceOfReward() public returns(uint256) {
        (bool success, bytes memory result) = LOTTERY_TOKEN_ADDRESS.call(abi.encodeWithSignature("balanceOf(address)", address(this)));
        require(success, "Error when get balance of reward.");
        uint256 amount = abi.decode(result, (uint256));
        return amount;
    }

    function startLotterySession(uint256 _minLotteryNumber, uint256 _maxLotteryNumber) public onlyOwner {
        require(running, "Lottery session is running.");
        minLotteryNumber = _minLotteryNumber;
        maxLotteryNumber = _maxLotteryNumber;
        luckyNumber = 0;
        _clearBuyers();
        _clearNumbers();
        running = true;
    }

    function _clearBuyers() internal {
        for(uint256 i = 0; i < buyerAddesses.length; i++) {
            address buyerAddress = buyerAddesses[i];
            delete buyers[buyerAddress];
        }
        delete buyerAddesses;
    }

    function _clearNumbers() internal {
        for(uint256 i = 0; i < numbers.length; i++) {
            uint256 number = numbers[i];
            delete lotteryNumbers[number];
        }
        delete numbers;
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
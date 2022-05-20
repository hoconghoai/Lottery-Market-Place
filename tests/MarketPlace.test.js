const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MarketPlace", function(){
    it("test init value", async function(){
        const MarketPlace = await ethers.getContractFactory("MarketPlace");
        const marketPlace = await MarketPlace.deploy();
        await marketPlace.deployed();
        console.log('Deployed at: ' + marketPlace.address);
    });
});
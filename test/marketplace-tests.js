const chai = require("chai");
const { BigNumber } = require("ethers");
const { solidity } = require("ethereum-waffle");
const { ethers } = require("hardhat");
const { expect } = chai;

let NFT;
let nft;
let Marketplace;
let marketplace;
let Token;
let token;
let owner;
let account1;
let account2;
let account3;
let account4;

let address1 = "0x8626f6940e2eb28930efb4cef49b2d1f2c9c1199";

// const impersonateAccount = async (address) => {
//   await network.provider.send("hardhat_impersonateAccount", [address]);
//   const signer = await ethers.getSigner(address);
//   return signer;
// };

describe("Marketplace", () => {
  beforeEach(async () => {
    NFT = await ethers.getContractFactory("NFT");
    nft = await NFT.deploy();
    Token = await ethers.getContractFactory("Token");
    token = await Token.deploy();
    Marketplace = await ethers.getContractFactory("Marketplace");
    marketplace = await Marketplace.deploy(
      nft.address,
      token.address,
      address1
    );
    console.log("Marketplace address: ", marketplace.address);
    await marketplace.deployed();
    [owner, account1, account2, account3, account4, _] =
      await ethers.getSigners();
    console.log(account1.address);
  });

  describe("Create Market Item", () => {
    it("will allow sender to put the NFT on sale if all the params are correct", async () => {
      const tokenId = "1";
      const price = "1000";
      const amount = "5";
      const params = [amount, account1.address, price, amount];
      console.log("params: ", params[1]);
      await nft.connect(account1).mint(tokenId, "100");
      const balance = await nft.balanceOf(marketplace.address, "1");

      await nft.connect(account1).setApprovalForAll(marketplace.address, true);
      console.log("balance: ", balance);
      const result = await marketplace
        .connect(account1)
        .createItem(tokenId, price, amount);
      await expect(result)
        .to.emit(marketplace, "ItemCreated")
        .withArgs(account1.address, tokenId, price, amount);
    });
  });

  describe("Buy NFT from marketplace", () => {
    it("will allow sender to buy the NFT if all the params are correct", async () => {
      const tokenId = "1";
      const amount = "5";
      const balance = await nft.balanceOf(marketplace.address, "1");
      console.log("balance: ", balance);

      await nft.connect(account1).setApprovalForAll(marketplace.address, true);
      await token
        .connect(account1)
        .setApprovalForAll(marketplace.address, true);

      const result = await marketplace.connect(account1).buy(tokenId, amount);
      await expect(result)
        .to.emit(marketplace, "Buy")
        .withArgs(account1.address, tokenId, amount);
    });
  });
});

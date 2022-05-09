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

const impersonateAccount = async (address) => {
  await network.provider.send("hardhat_impersonateAccount", [address]);
  const signer = await ethers.getSigner(address);
  return signer;
};

describe("Marketplace", () => {
  beforeEach(async () => {
    [owner, account1, account2] = await ethers.getSigners();
    NFT = await ethers.getContractFactory("NFT");
    nft = await NFT.deploy();
    Token = await ethers.getContractFactory("Token");
    token = await Token.deploy();
    Marketplace = await ethers.getContractFactory("Marketplace");
    marketplace = await Marketplace.deploy();
    await marketplace.deployed();
  });

  it("should not deploy", async () => {
    it("cannot deploy if token address is zero", async () => {
      Marketplace = await ethers.getContractFactory("Marketplace");
      await expect(
        Marketplace.deploy(
          "0x0000000000000000000000000000000000000000",
          token.address
        )
      ).to.be.revertedWith("Token address cannot be zero");
    });
    it("cannot deploy if nft address is zero", async () => {
      Marketplace = await ethers.getContractFactory("Marketplace");
      await expect(
        Marketplace.deploy(
          "0x0000000000000000000000000000000000000000",
          nft.address
        )
      ).to.be.revertedWith("Token address cannot be zero");
    });
  });
});

describe("Create Market Item", () => {
  it("will allow sender to put the NFT on sale if all the params are correct", async () => {
    const tokenId = "1";
    const royalty = "5";
    const params = [account1.address, true, "1", "100", royalty];
    await nft.connect(account1).mint(tokenId, 10, "0x00");
    await nft.connect(account1).setApprovalForAll(marketplace.address, true);
    const result = await marketplace
      .connect(account1)
      .createMarketItem(1, 10, 1000);
    await expect(result)
      .to.emit(marketplace, "createMarketItem")
      .withArgs("1", 100, account1.address, params);
  });
});

describe("Buy NFT from marketplace", () => {
  it("will allow sender to buy the NFT if all the params are correct", async () => {
    const tokenId = "1";
    const royalty = "5";
    const partnerRoyalty = "2";
    const price = 1000;

    const creatorReward = price.mul(royalty).div(100);
    const partnerReward = price.mul(partnerRoyalty).div(100);
    await nft.connect(account1).mint(tokenId, 10, "0x00");
    await nft.connect(account1).setApprovalForAll(marketplace.address, true);
    await marketplace.connect(account1).createMarketItem(1, 10, 1000);
    await marketplace.connect(signer).buyToken(1, 10, account2.address);
    expect(await marketplace.creatorRewards(account1.address)).to.be.equal(
      BigNumber.from(creatorReward)
    );
    expect(await marketplace.partnerRewards(account2.address)).to.be.equal(
      partnerReward
    );
  });
});

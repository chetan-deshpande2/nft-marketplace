const chai = require("chai");
const { BigNumber } = require("ethers");
const { solidity } = require("ethereum-waffle");

let NFT;
let Token;
let cks;
let nft;
let MarketPlace;
let marketplace;
let token;
let owner;
let seller1;
let seller2;
let partner1;
let partner2;

describe("MarketPlace", () => {
  beforeEach(async () => {
    [owner, seller1, seller2, partner1, partner2, _] =
      await ethers.getSigners();

    Token = await ethers.getContractFactory("Token");
    token = await Token.deploy();

    NFT = await ethers.getContractFactory("ERC115NFT");
    nft = await NFT.deploy(token.address);

    CryptoKiddiesMarketPlace = await ethers.getContractFactory(
      "CryptoKiddiesMarketPlace"
    );
    marketplace = await CryptoKiddiesMarketPlace.deploy(USDC, cks.address);
  });
});

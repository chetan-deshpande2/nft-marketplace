
# NFT Marketplace

 ## Overview

 NFT marketplace contract allows user to put their
NFT's on sale and buy NFT'sale


## Documentation



* List the NFT on marketplace . Only admin can execute this function
```bash 
function createMarketItem() external onlyOwner{}

```

* Anyone can buy NFT's from marketplace
```bash 
function buyToken() external {}

```

* To add the partners for royalties. Only Admin can add Partners
```bash 
function addPartners() external onlyOwner{}

```
* To Claim platform fees . Only admin can execute this function
```bash 
function claimPlatformFees() external onlyOwner {}


```

## Smart Contracts

*  Token contract [0x75FE1cc2b877788C8e7327D7055DFFf1ddFd4D4f](https://rinkeby.etherscan.io/address/0x75fe1cc2b877788c8e7327d7055dfff1ddfd4d4f#code)

*  NFT contract [0x695efcae1636aeb1f75af6a4540cca3bc08412ab](https://rinkeby.etherscan.io/address/0x695efcae1636aeb1f75af6a4540cca3bc08412ab#code)

*  Marketplace  contract [0xae5e62aaa848a768d6ef65452d9cbe5a2227c17f](https://rinkeby.etherscan.io/address/0xae5e62aaa848a768d6ef65452d9cbe5a2227c17f#code)


## Features

- Create Fungible Tokes with ERC1155 Standard
- Create Non-Fungible Tokens ERC1155 Standard
- Need to add 2.5% of Sell Price/Token(s) to Platform Fees.
- Users can set Fractional Royalties of Multiple Owner(s) for the NFT’s Selling Price.
- Users can Buy & Sell NFT using Fungible Token generated as mentioned above (Marketplace)
Generalized solution to set Frational Royalties : Solidity do not accept the fractional number so if we have to pass 2.5% then we have to pass it like 25 / 1000

Formula to set Fractional Royalties : n : number of digits of the number d : decimal point O : output

O = n / 10n-d

For Example :

n = 2 d = 1 O = 25 / 102-1 O = 2.5

NOTE : In smart contract it may happen that one has bought the nft but the owner of nft did not pass the nft and ownership of nft to the one who bought it. So to solve this issue we may use Escrow system or any alternative solutions.


##  Project Setup

Clone the project

```bash
  git clone https://github.com/chetan-deshpande2/nft-marketplace.git

```

Go to the project directory

```bash
  cd nft-marketplace
```

Install dependencies

```bash
  npm install
```



##  Running Tests

1. To Compile
```bash 
npx hardhat compile
npx hardhat clean
```

2. To run tests, run the following command

```bash
  npx hardhat test
  
```
3. To deploy on Test Network

* create .env file

 * See .env.example and fill the values in .env file

* Run

```bash 
npx hardhat run scripts/deploy.js --network rinkeby
```



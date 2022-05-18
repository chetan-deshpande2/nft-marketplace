
# NFT Marketplace

 ## Overview

 NFT marketplace contract allows user to put their
NFT's on sale and buy NFT'sale


## Documentation



* List the NFT on marketplace . Only admin can execute this function
```bash 
function createItem() external onlyOwner{}

```

* Anyone can buy NFT's from marketplace
```bash 
function buy() external {}

```

* To add the partners for royalties. Only Admin can add Partners
```bash 
function addPartners() external onlyOwner{}

```


## Smart Contracts

*  Token contract [0x723087448039b0e79c7428f6134465d65a2c7347](https://rinkeby.etherscan.io/address/0x723087448039b0e79c7428f6134465d65a2c7347#code)

*  NFT contract [0xe7aceba828126b404098865f6015e66696efd819](https://rinkeby.etherscan.io/address/0xe7aceba828126b404098865f6015e66696efd819#code)

*  Marketplace  contract [0xf6ca21a098e7d0b18ff7dfd2ac6dee9f3dc46319](https://rinkeby.etherscan.io/address/0xf6ca21a098e7d0b18ff7dfd2ac6dee9f3dc46319#code)


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



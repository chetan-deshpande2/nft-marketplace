
# NFT Marketplace

A brief description of what this project does and who it's for


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


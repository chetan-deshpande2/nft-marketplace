require("dotenv").config();

require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("solidity-coverage");

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.4",
      },
    ],
  },
  networks: {
    rinkeby: {
      url: process.env.RINKEBY_RPC_URL,
      accounts: [
        process.env.RINKEBY_PRIVATE_KEY_ACCOUNT1,
        process.env.RINKEBY_PRIVATE_KEY_ACCOUNT3,
      ],
      gasPrice: 3000000000,
    },
  },

  etherscan: {
    apiKey: process.env.API_KEY,
  },
};

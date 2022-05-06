// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Token is ERC1155 {
    uint256 public constant COIN = 1;

    constructor() ERC1155("") {
        _mint(msg.sender, COIN, 10000 * 10**18, "");
    }
}

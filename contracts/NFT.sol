// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract NFT is ERC1155 {
    constructor() ERC1155("") {}

    function mint(uint256 id, uint256 amount) external {
        _mint(msg.sender, id, amount, "");
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ERC115NFT is ERC1155 {
    using Counters for Counters.Counter;
    Counters.Counter private _nftID;

    constructor() ERC1155("") {}

    function mint(bytes memory data) public returns (uint256 NFTId) {
        _nftID.increment();
        uint256 tokenID = _nftID.current();
        super._mint(msg.sender, tokenID, 1, data);
        return tokenID;
    }

    function burn(
        address from,
        uint256 id,
        uint256 amount
    ) public {
        super._burn(from, id, amount);
    }
}
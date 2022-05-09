// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract NFT is ERC1155 {


    mapping(uint256 => address) public creator;
    mapping(uint256 => string) private _tokenURIs;

    event Mint(
        address indexed owner,
        uint256 id,
        uint256 amount,
        string tokenURI

    );

    constructor() ERC1155("") {}

    function mint(uint256 id,uint256 amount,string memory _tokenURI) external {
        creator[id] = msg.sender;
      
        _mint(msg.sender,id,amount,"");
      
        emit Mint(msg.sender,id, amount,_tokenURI);
     


    }



    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        _tokenURIs[tokenId] = uri;
    }

     function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

       


}

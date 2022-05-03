// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

contract MarketPlace is ERC1155, ERC2981, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;
    uint256 private platformFee = 25;
    address marketwallet;
    address marketOwner;

    IERC1155  public nftContract;
    IERC1155 public token ;
    

    //EVENTS//
    event NewItemCreated(
        uint256 indexed id,
        address creator,
        address owner,
        uint256 price,
        uint256 _amount
    );

    struct Item {
        uint256 id;
        address payable creator;
        //address payable owner;
        uint256 price;
        uint256 amount;
    }

    mapping(uint256 => Item) public idToItem;
    mapping(address => uint256) public users;
    mapping(uint256 => bool) private itemIds;
    mapping(uint256 => bool) private soldOut;

    uint256 public nextItemId;

    constructor(address _nftContract, address _token )ERC1155("") {
        nftContract = IERC1155(_nftContract);
        token = IERC1155(_token);
        
    }


    function createMarketItem(
        uint256 _id,
        uint256 _amount,
        uint256 _price
    ) external payable virtual returns (uint256) {
        require(_amount <= 50, "Can't mint more than 50 Items");
        require(_price > 0, "Must be at least 1 Wei");
        _setDefaultRoyalty(_msgSender(), 500);

        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _mint(msg.sender, _id, _amount, "");

        _createMarketItem(_id, _price, _amount);
        return newTokenId;
    }

    function _createMarketItem(
        uint256 _id,
        uint256 _amount,
        uint256 _price
    ) internal {
        require(itemIds[_id] == false, "This ID is already taken");
        require(_price > 0, "Price must be at least 1 wei");

        idToItem[_id] = Item(
            _id,
            payable(msg.sender),
            _amount,
            _price
        );

        _safeTransferFrom(msg.sender, address(this), _id, _amount, "");

        emit NewItemCreated(_id, msg.sender, address(this), _price, _amount);

        nextItemId++;
    }

    function buyNFT(uint256 _id ,uint256 _amount) external {
        uint256 price = idToItem[_id].price;
        uint256 tokenId = idToItem[_id].id;
         require(idToItem[_id].amount >= 1, "Item Sold out");
        require(_amount == 1, "Amount too high, Select 1");
         uint256 fees = price - (platformFee) / 1000;
        price = price - fees;
        idToItem[_id].creator.transfer(price);
        safeTransferFrom(address(this), msg.sender, tokenId, _amount, "");
        token.safeTransferFrom(msg.sender, address(this), 0, fees, "0x00");

      
     
    }


    /* Creates the sale of a marketplace item */
    /* Transfers ownership of the item, as well as funds between parties */
    function saleNFT(uint256 _id, uint256 _amount) public payable {
        uint256 price = idToItem[_id].price;
        uint256 tokenId = idToItem[_id].id;
        require(idToItem[_id].amount >= 1, "Item Sold out");
        require(_amount == 1, "Amount too high, Select 1");
        uint256 fees = price - (platformFee) / 1000;
        price = price - fees;
        idToItem[_id].creator.transfer(msg.value);
        safeTransferFrom(address(this), msg.sender, tokenId, _amount, "");
        token.safeTransferFrom(msg.sender, address(this), 0, fees, "0x00");


        idToItem[_id].amount = idToItem[_id].amount - 1;
        if (idToItem[_id].amount == 0) {
            soldOut[_id] = true;
        }
    }





    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public virtual returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }
}

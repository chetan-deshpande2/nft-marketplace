// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "hardhat/console.sol";

contract Market is ERC2981, Ownable {
    address[] public partners;

    uint256 platFormFee = 25;
    address platFormFeesAddress;

    IERC1155 public nftContract;
    IERC1155 public token;

    struct Item {
        uint256 id;
        address owner;
        uint256 price;
        uint256 amount;
    }

    mapping(uint256 => Item) public idToItem;
    mapping(address => uint256) public partnerRoyalty;

    constructor(
        address _nftContract,
        address _token,
        address _platFormFeesAddress
    ) {
        nftContract = IERC1155(_nftContract);
        token = IERC1155(_token);
        platFormFeesAddress = _platFormFeesAddress;
    }

    function addPartners(address _partners, uint256 _royalty)
        external
        onlyOwner
    {
        require(_partners != address(0), "Partners address cannot be zero");
        require(_royalty != 0, "Royalty cannot be zero");
        partners.push(_partners);
        partnerRoyalty[_partners] = _royalty;
    }

    function createItem(
        uint256 _id,
        uint256 _price,
        uint256 _amount
    ) external {
        require(_price > 0, "Must be greater than 0 ");
        idToItem[_id] = Item(_id, msg.sender, _price, _amount);
        nftContract.safeTransferFrom(
            msg.sender,
            address(this),
            _id,
            _amount,
            ""
        );
    }

    function buy(uint256 _id, uint256 _amount) external {
        uint256 price = (idToItem[_id].price) * _amount;

        uint256 tokenId = idToItem[_id].id;
        address owner = idToItem[_id].owner;

        uint256 fees = (price * (platFormFee)) / 1000;
        console.log("fees", fees);
        price = price - fees;
        nftContract.safeTransferFrom(
            address(this),
            msg.sender,
            tokenId,
            _amount,
            ""
        );
        token.safeTransferFrom(msg.sender, address(this), 1, price, "");
        token.safeTransferFrom(address(this), platFormFeesAddress, 1, fees, "");
        address partnersAddress;
        uint256 _royalty;
        for (uint256 i = 0; i < partners.length; i++) {
            partnersAddress = partners[i];
            _royalty = (price * partnerRoyalty[partnersAddress]) / 100;
            token.safeTransferFrom(
                address(this),
                partnersAddress,
                1,
                _royalty,
                ""
            );
        }
        _royalty += _royalty;
        uint256 remeaningAmount = price - _royalty;
        token.safeTransferFrom(address(this), owner, 1, remeaningAmount, "");
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC2981)
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
}

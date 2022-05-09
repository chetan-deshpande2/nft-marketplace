// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./NFT.sol";
import "./Token.sol";
import "hardhat/console.sol";

/// @title  ERC1155 NFT Marketplace Contract
/// @notice You can use this contract for Listing and Buying NFT's

contract Marketplace is ERC1155Holder, Ownable {
    NFT public nft;
    Token public token;
    address[] public partners;

    uint256 private platFormFee = 25;

    /*
    * @dev  to create Item for Marketplace
    * @param owner of the nft
    * @param tokenAmount is nft amount
    * @param  price  per nft
    * @param onSale to check nft is on sale or not
    * @param royalty percentage for partners and creator

    */

    struct Item {
        address owner;
        uint256 tokenAmount;
        uint256 price;
        bool onSale;
        uint256 royalty;
    }

    /*
     * @notice to store order details
     * @param buyer is adress of buyer
     * @param seller is address of seller
     * @param amount is  nft count
     */
    struct Order {
        address buyer;
        address seller;
        uint256 amount;
    }

    mapping(uint256 => Item) public item;
    mapping(uint256 => Order) public orderItems;
    mapping(address => uint256) public partnerRoyalty;
    mapping(address => uint256) public creatorRewards;
    mapping(address => uint256) public partnerRewards;

    event ItemDetails(
        uint256 tokenId,
        uint256 price,
        uint256 amount,
        address tokenOwner,
        Item newItem
    );

    constructor(address _NFT, address _token) {
        require(
            _NFT != address(0),
            "NFT Contract Address cannot be zero address"
        );
        require(
            _token != address(0),
            "Purchasing Token Address cannot be zero address"
        );
        token = Token(_token);
        nft = NFT(_NFT);
    }

    /*
     * @notice to add partners for splitting royalties
     * @param _partners is address of partners
     * @param _royalty is to add royalty percentage
     */
    function addPartners(address _partners, uint256 _royalty)
        external
        onlyOwner
    {
        require(_partners != address(0), "Partners address cannot be zero");
        require(_royalty != 0, "Royalty cannot be zero");
        partners.push(_partners);
        partnerRoyalty[_partners] = _royalty;
    }

    /*
     * @notice list the NFT on the marketplace
     * @param _tokenId is tokenId for NFT from ERC1155 contract
     * @param  _tokenAmount is amount user putting for sale
     * @param _price is price  per nft
     */

    function createMarketItem(
        uint256 _tokenId,
        uint256 _tokenAmount,
        uint256 _price
    ) external returns (Item memory) {
        require(
            nft.balanceOf(msg.sender, _tokenId) >= _tokenAmount,
            "Not enough NFT token to list"
        );
        require(_price > 0, "Price must be greater than 0  ");
        Item memory newItem = Item({
            owner: msg.sender,
            tokenAmount: _tokenAmount,
            price: _price,
            onSale: true,
            royalty: 5
        });
        item[_tokenId] = newItem;
        nft.safeTransferFrom(
            msg.sender,
            address(this),
            _tokenId,
            _tokenAmount,
            ""
        );
        emit ItemDetails(_tokenId, _price, _tokenAmount, msg.sender, newItem);
        return newItem;
    }

    /*
     * @notice buy function for buying the nft's
     * @param _tokenId of nft's for buying
     * @param _tokenAmount to amount willing to bought by user
     * @param _buyer address of user
     * @returns the data of perticular item which user has bought
     */

    function buyToken(
        uint256 _tokenId,
        uint256 _tokenAmount,
        address _buyer
    ) external returns (Order memory) {
        Item storage itemDetails = item[_tokenId];
        uint256 price = itemDetails.price * _tokenAmount;
        require(
            itemDetails.tokenAmount >= _tokenAmount,
            "Not Enough Tokens on sale"
        );
        require(token.balanceOf(_buyer, 1) >= price, "Not Enough tokens ");
        Order memory newOrder = Order({
            buyer: _buyer,
            seller: itemDetails.owner,
            amount: _tokenAmount
        });
        uint256 royalty = itemDetails.royalty;
        uint256 fees = (price * (platFormFee)) / 1000;
        price = price - fees;

        address creator = nft.creator(_tokenId);
        address owner = newOrder.seller;
        _splitRoyalties(price, creator, royalty, _buyer, owner);

        nft.safeTransferFrom(address(this), _buyer, _tokenId, _tokenAmount, "");

        itemDetails.tokenAmount -= _tokenAmount;

        if (itemDetails.tokenAmount == 0) {
            delete item[_tokenId];
        }
        token.safeTransferFrom(_buyer, address(this), 1, fees, "");
        return newOrder;
    }

    function claimRoyalties() external {
        uint256 creatorReward = creatorRewards[msg.sender];

        uint256 partnerReward = partnerRewards[msg.sender];

        uint256 finalReward = creatorReward + partnerReward;

        token.safeTransferFrom(address(this), msg.sender, 1, finalReward, "");
    }

    /*
     * @notice  to split the royalty percentage
     * @param price is total price of token
     * @param creator is the  nft created by user
     * @param royalty percentage
     * @param buyer is buyer of nft
     * @param  _tokenId of nft
     */
    function _splitRoyalties(
        uint256 price,
        address creator,
        uint256 royalty,
        address buyer,
        address owner
    ) internal {
        uint256 totalPartnerRoyalty = 0;
        for (uint256 i = 0; i < partners.length; i++) {
            address _partners = partners[i];
            uint256 _royalty = partnerRoyalty[_partners];
            uint256 _reward = (price * _royalty) / 100;
            partnerRewards[_partners] += _reward;
            totalPartnerRoyalty += _reward;
        }
        uint256 tokenAmountForCreator = (price * royalty) / 100;

        uint256 tokenAmountForOwner = price -
            tokenAmountForCreator -
            totalPartnerRoyalty;

        creatorRewards[creator] += tokenAmountForCreator;

        token.safeTransferFrom(buyer, owner, 1, tokenAmountForOwner, "");
        token.safeTransferFrom(
            buyer,
            address(this),
            1,
            tokenAmountForCreator + totalPartnerRoyalty,
            ""
        );
    }

    /// *@notice to claim the total token amount of platform genrated

    function claimPlatformFees() external {
        uint256 platformBalance = token.balanceOf(address(this), 1);

        token.safeTransferFrom(
            address(this),
            msg.sender,
            1,
            platformBalance,
            ""
        );
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155Receiver)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

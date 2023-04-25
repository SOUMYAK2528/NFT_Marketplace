// SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.4 ;

import "@openzeppelin/contracts/utils/counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";
 
contract NFTMarketplace is ERC721URIStorage{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;

    uint256 listingPrice==0.0025 ether;

    address payable owner;

    struct MarketItem{
        uint256 tokenIds;
        address payable seller;
        address payable  owner;
        uint256 price;
        bool sold;
    }
    mapping(uint256 => MarketItem ) private idMarketItem;

    modifier  onlyOwner {
        require(
            msg.sender==owner ,
            "Only owner of the marketplace can change price"
            );
            _;
        
    }

    event idMarketItemCreated(
        uint256 indexed tokenIds,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    constructor() ERC721("NFT Metaverse Token", "MYNFT"){
        owner == payable(msg.sender);
    }

    function updateListingPrice(uint256 _listingPrice) 
    public 
    payable
    onlyOwner
    {
        listingPrice=_listingPrice;
    }

    function getListingPrice() public view returns(uint256){
        return listingPrice;
    }

    //create NFT token function

    function createToken(
        string memory tokenURL,
        uint256 price
        ) 
        public
        payable
        returns(uint256)
           {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _mint(msg.sender,newTokenId);
        _setTokenURL(newTokenId,tokenURL);

        createMarketItem(newTokenId,price);

        return newTokenId;
    }

    function createMarketItem(uint256 tokenId, uint256 price) private{
        require(price >0 ,"price must be atleast one");
        require(msg.value == listingPrice, "price must be equal to listing price");

        idMarketItem[tokenId] = MarketItem(
            tokenId,
            payable(msg.sender),
            payable(address(this)),
            price,
            false
        );

        _transfer(msg.sender,address(this),tokenId);

        emit idMarketItemCreated(tokenId,msg.sender,address(this),price,false);
    }

    //Function for Resale Token


} 
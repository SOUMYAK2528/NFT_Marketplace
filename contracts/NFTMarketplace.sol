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

    mapping(uint256 => MarketItem ) private idMarketItem;

    struct MarketItem{
        uint256 tokenIds;
        address payable seller;
        address payable  owner;
        uint256 price;
        bool sold;
    }
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


} 
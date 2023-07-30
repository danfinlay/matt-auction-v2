// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleNFT is ERC721Enumerable, Ownable {
    IERC20 public AUCTION_CURRENCY;

    constructor(address auctionCurrencyAddress) ERC721("SimpleNFT", "SNFT") {
        AUCTION_CURRENCY = IERC20(auctionCurrencyAddress);
    }

    function mint(uint256 price, address[] calldata buyers) external onlyOwner {
        for (uint256 i = 0; i < buyers.length; i++) {
            address buyer = buyers[i];
            require(buyer != address(0), "Invalid buyer address");

            // Perform ERC20 transfer for the price
            bool transferSuccessful = AUCTION_CURRENCY.transferFrom(buyer, address(this), price);
            require(transferSuccessful, "Token transfer failed");

            // Issue the NFT to the buyer
            _mint(buyer, totalSupply() + 1);
        }
    }
}

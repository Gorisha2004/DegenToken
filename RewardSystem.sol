// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract Reward is ERC20, Ownable, ERC20Burnable {

    // Event emitted when a player redeems tokens for an event or item
    event Redeem(address indexed player, uint256 amount);

    // Structure to define an item in the marketplace
    struct Item {
        uint256 id;      // Unique ID of the item
        address seller;  // Address of the seller
        uint256 price;   // Price of the item in tokens
    }

    // Mapping of item ID to Item details in the marketplace
    mapping(uint256 => Item) public marketplace;

    // Constructor to initialize the token with a name, symbol, and mint initial tokens to the owner
    constructor() ERC20("Reward", "RWD") Ownable(msg.sender) {
        // Initial mint for the owner (could be used for initial reward distribution)
        _mint(msg.sender, 10000 * 10 ** decimals());
    }

    // Function to mint tokens to reward players (only the owner can mint tokens)
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // Function to get the balance of the caller's tokens
    function getbalance() external view returns(uint256){
        return this.balanceOf(msg.sender);
    }

    // Players can transfer tokens to other players
    function transferToken(address _receiver, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "You do not have enough tokens");
        approve(msg.sender, _value);
        transferFrom(msg.sender, _receiver, _value);
    }

    // Players redeem tokens for in-game rewards, with tokens being burned in exchange for items or services
    function purchaseItem(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to redeem tokens");
        _burn(msg.sender, amount);
        emit Redeem(msg.sender, amount);
    }

    // Players can burn tokens voluntarily if they no longer need them
    function burnTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to burn tokens");
        _burn(msg.sender, amount);
    }

    // Sellers can list an item on the marketplace with a price
    function listItem(uint256 itemId, uint256 price) public {
        marketplace[itemId] = Item(itemId, msg.sender, price);
    }

    // Players can buy an item from the marketplace using tokens
    function buyItem(uint256 itemId) public {
        require(balanceOf(msg.sender) >= marketplace[itemId].price, "Insufficient tokens");
        transfer(marketplace[itemId].seller, marketplace[itemId].price);
        // Additional logic can be added here to transfer item ownership to the buyer
    }
}

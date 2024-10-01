// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract Reward is ERC20, Ownable, ERC20Burnable {

    // Event emitted when a player redeems tokens for an item
    event Redeem(address indexed player, uint256 amount, string itemName);
    event ItemAdded(uint256 itemId, uint256 price, address seller);
    event ItemPurchased(address indexed buyer, uint256 itemId, uint256 price);

    // Structure to define an item in the marketplace
    struct Item {
        uint256 id;
        address seller;
        uint256 price;
        string itemName;

    }

    // Marketplace mapping for items listed by sellers
    mapping(uint256 => Item) public marketplace;

    // Mapping for redeemable item prices
    mapping(string => uint256) public itemPrices;

    // Variable to track the next item ID
    uint256 public nextItemId = 1;

    // Constructor to initialize the token with a name, symbol, and mint initial tokens to the owner
    constructor() ERC20("Reward", "RWD") Ownable(msg.sender) {
        _mint(msg.sender, 10000); // Mint initial tokens for the owner

        // Add example items to both marketplace and redeemable items (optional)
        itemPrices["Sword"] = 100;
        itemPrices["Shield"] = 200;

        marketplace[nextItemId++] = Item(1, msg.sender, 300);
        marketplace[nextItemId++] = Item(2, msg.sender, 500);
    }

    // Function to mint tokens to reward players (only the owner can mint tokens)
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
    // Function to get the balance of the caller's tokens
    function getBalance() external view returns(uint256) {
        return this.balanceOf(msg.sender);
    }
    // Players can transfer tokens to other players
    function transferToken(address _receiver, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "You do not have enough tokens");
        approve(msg.sender, _value);
        transferFrom(msg.sender, _receiver, _value);
    }

    // Players redeem tokens for specific in-game rewards (items)
    function redeemItem(string memory itemName) public {
        uint256 price = itemPrices[itemName];
        require(price > 0, "Item does not exist");
        require(balanceOf(msg.sender) >= price, "Insufficient balance to redeem item");

        _burn(msg.sender, price);
        emit Redeem(msg.sender, price, itemName);
    }
    // Players can burn tokens voluntarily if they no longer need them
    function burnTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to burn tokens");
        _burn(msg.sender, amount);
    }

    // Function to add or update redeemable items with their prices
    function addItem(string memory itemName, uint256 price) public onlyOwner {
        require(price > 0, "Price must be greater than zero");
        itemPrices[itemName] = price;
    }

    // Sellers can list an item on the marketplace with a price
    function listItem(uint256 price) public {
        require(price > 0, "Price must be greater than zero");
        require(balanceOf(msg.sender) >= price, "You do not have enough tokens to list this item");

        _burn(msg.sender, price);

        uint256 newItemId = nextItemId++;
        marketplace[newItemId] = Item(newItemId, msg.sender, price);

        emit ItemAdded(newItemId, price, msg.sender);
    }

    // Players can buy an item from the marketplace using tokens
    function buyItem(uint256 itemId) public {
        Item memory item = marketplace[itemId];
        require(item.seller != address(0), "Item does not exist");
        require(balanceOf(msg.sender) >= item.price, "Insufficient tokens");

        _transfer(msg.sender, item.seller, item.price);

        emit ItemPurchased(msg.sender, itemId, item.price);
    }
}

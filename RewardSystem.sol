// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract Reward is ERC20, Ownable, ERC20Burnable {

    event Redeem(address indexed player, uint256 amount, string itemName);
    event ItemAdded(uint256 itemId, uint256 price, address seller);
    event ItemPurchased(address indexed buyer, uint256 itemId, uint256 price);

    struct Item {
        uint256 id;
        address seller;
        uint256 price;
        string itemName;
    }

    mapping(uint256 => Item) public marketplace;
    mapping(string => uint256) public itemPrices;

    // Mapping to track redeemed items by users
    mapping(address => mapping(string => bool)) public hasRedeemedItem;

    uint256 public nextItemId = 1;

    constructor() ERC20("Reward", "RWD") Ownable(msg.sender) {
        _mint(msg.sender, 10000);

        itemPrices["Sword"] = 100;
        itemPrices["Shield"] = 200;

        marketplace[nextItemId++] = Item(1, msg.sender, 300, "Armor");
        marketplace[nextItemId++] = Item(2, msg.sender, 500, "Helmet");
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function getBalance() external view returns(uint256) {
        return this.balanceOf(msg.sender);
    }

    function transferToken(address _receiver, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "You do not have enough tokens");
        approve(msg.sender, _value);
        transferFrom(msg.sender, _receiver, _value);
    }

    function redeemItem(string memory itemName) public {
        uint256 price = itemPrices[itemName];
        require(price > 0, "Item does not exist");
        require(balanceOf(msg.sender) >= price, "Insufficient balance to redeem item");
        require(!hasRedeemedItem[msg.sender][itemName], "Item has already been redeemed");

        _burn(msg.sender, price);

        // Mark the item as redeemed for this player
        hasRedeemedItem[msg.sender][itemName] = true;

        emit Redeem(msg.sender, price, itemName);
    }

    function burnTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to burn tokens");
        _burn(msg.sender, amount);
    }

    function addItem(string memory itemName, uint256 price) public onlyOwner {
        require(price > 0, "Price must be greater than zero");
        itemPrices[itemName] = price;
    }

    function listItem(uint256 price, string memory itemName) public {
        require(price > 0, "Price must be greater than zero");
        require(balanceOf(msg.sender) >= price, "You do not have enough tokens to list this item");

        _burn(msg.sender, price);

        uint256 newItemId = nextItemId++;
        marketplace[newItemId] = Item(newItemId, msg.sender, price, itemName);

        emit ItemAdded(newItemId, price, msg.sender);
    }

    function buyItem(uint256 itemId) public {
        Item memory item = marketplace[itemId];
        require(item.seller != address(0), "Item does not exist");
        require(balanceOf(msg.sender) >= item.price, "Insufficient tokens");

        _transfer(msg.sender, item.seller, item.price);

        emit ItemPurchased(msg.sender, itemId, item.price);
    }

    // Function to check if a player has redeemed a specific item
    function hasRedeemed(string memory itemName) public view returns (bool) {
        return hasRedeemedItem[msg.sender][itemName];
    }
}

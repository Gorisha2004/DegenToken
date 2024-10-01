# Reward System
## Overview
Reward is an ERC20 token built on the Avalanche blockchain using Solidity. This token is designed to reward players in the  Gaming ecosystem and can be used to purchase and sell items in the in-game store, trade with other players, and more. The contract includes functionalities for minting new tokens, burning tokens, transferring tokens, purchasing items, list items , checking token balances and many more.

# Description
Reward is a smart contract inheriting properties from ERC20, Ownable, and ERC20Burnable. The contract includes a public constructor that initializes the token with the name "Reward" and the symbol "RWD" and sets the deployer as the owner.

# Functions

* mint: Allows the owner to mint new tokens to a specified address.
```
        function mint(address to, uint256 amount) external onlyOwner {
            _mint(to, amount);
    }
```
* getBalance: Allows the caller to check their token balance.
```
    function getbalance() external view returns(uint256){
        return this.balanceOf(msg.sender);
    }
```
* transferToken: Allows transferring tokens to a specified address.
```
    function transferToken(address _receiver, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "You do not have enough Degen Tokens ");
        approve(msg.sender, _value);
        transferFrom(msg.sender, _receiver, _value);
    }
```
* redeemItem : Allow Players to redeem tokens for specific in-game rewards (items)
```
    function redeemItem(string memory itemName) public {
        uint256 price = itemPrices[itemName];
        require(price > 0, "Item does not exist");
        require(balanceOf(msg.sender) >= price, "Insufficient balance to redeem item");

        _burn(msg.sender, price);
        emit Redeem(msg.sender, price, itemName);
    }
```  
* burnTokens: Allows any token holder to burn their tokens.
```
    function burnTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to burn tokens");
        _burn(msg.sender, amount);
    }
```
* listItem
```
    function listItem(uint256 price) public {
        require(price > 0, "Price must be greater than zero");
        require(balanceOf(msg.sender) >= price, "You do not have enough tokens to list this item");

        _burn(msg.sender, price);

        uint256 newItemId = nextItemId++;
        marketplace[newItemId] = Item(newItemId, msg.sender, price);

        emit ItemAdded(newItemId, price, msg.sender);
    }
```
and many more.


# Events
* event Redeem(address indexed player, uint256 amount) : Event emitted when a player redeems tokens for an event or item
* event ItemAdded(uint256 itemId, uint256 price, address seller) : Event emitted when a player buys any item 
* event ItemPurchased(address indexed buyer, uint256 itemId, uint256 price) : Event emitted when a player purchases any item in exchange of any service or item.


# Installation
* Open Remix IDE.
* Create a new file by clicking on the "+" icon in the left-hand sidebar.
* Save the file with a .sol extension (e.g., DegenToken.sol).
* Copy and paste the following code into the file:
[RewardSystem.sol](RewardSystem.sol)

# Executing Program
* Deploy the contract using Remix (a platform to compile and deploy Solidity contracts) and implement all the functionalities by passing suitable values.
* Select the network as metamask and run all the functionalities.
* Check all the transactions on snowtrace testnet by signing in with your account.



# Help
If you encounter any issues or need further assistance, please refer to the following resources:

* OpenZeppelin Documentation
* Remix Documentation

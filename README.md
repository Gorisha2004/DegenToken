# Reward System
## Overview
Reward is an ERC20 token built on the Avalanche blockchain using Solidity. This token is designed to reward players in the  Gaming ecosystem and can be used to purchase items in the in-game store, trade with other players, and more. The contract includes functionalities for minting new tokens, burning tokens, transferring tokens, and checking token balances.

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
* purchaseItem : Allow Players to redeem tokens for in-game rewards
```
    function purchaseItem(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to redeem tokens");
        _burn(msg.sender, amount);
        emit Redeem(msg.sender, amount);
    }
```  
* burnToken: Allows any token holder to burn their tokens.
```
    function burnTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to burn tokens");
        _burn(msg.sender, amount);
    }
```

# Installation
* Open Remix IDE.
* Create a new file by clicking on the "+" icon in the left-hand sidebar.
* Save the file with a .sol extension (e.g., DegenToken.sol).
* Copy and paste the following code into the file:

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract Reward is ERC20, Ownable, ERC20Burnable {

    // Event emitted when a player redeems tokens for an event or item
    event Redeem(address indexed player, uint256 amount);

    constructor() ERC20("Reward", "RWD") Ownable(msg.sender) {
        // Initial mint for the owner (could be used for initial reward )
        _mint(msg.sender, 10000 * 10 ** decimals());
    }
        // Mint tokens to reward players for participating in events (only owner can mint)
        function mint(address to, uint256 amount) external onlyOwner {
            _mint(to, amount);
    }

    function getbalance() external view returns(uint256){
        return this.balanceOf(msg.sender);
    }
     // Players can transfer tokens to other players
    function transferToken(address _receiver, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "You do not have enough Degen Tokens ");
        approve(msg.sender, _value);
        transferFrom(msg.sender, _receiver, _value);
    }

    // Players redeem tokens for in-game rewards 
    function purchaseItem(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to redeem tokens");
        _burn(msg.sender, amount);
        emit Redeem(msg.sender, amount);
    }

    // Players can burn their own tokens if they no longer need them
    function burnTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to burn tokens");
        _burn(msg.sender, amount);
    }
}
```
# Executing Program
Deploy the contract using Remix (a platform to compile and deploy Solidity contracts) and implement all the functionalities by passing suitable values.

# Help
If you encounter any issues or need further assistance, please refer to the following resources:

* OpenZeppelin Documentation
* Remix Documentation

# Degen Token
## Overview
DegenToken is an ERC20 token built on the Avalanche blockchain using Solidity. This token is designed to reward players in the Degen Gaming ecosystem and can be used to purchase items in the in-game store, trade with other players, and more. The contract includes functionalities for minting new tokens, burning tokens, transferring tokens, and checking token balances.

# Description
DegenToken is a smart contract inheriting properties from ERC20, Ownable, and ERC20Burnable. The contract includes a public constructor that initializes the token with the name "Degen" and the symbol "DGN" and sets the deployer as the owner.

# Functions

* mint: Allows the owner to mint new tokens to a specified address.
* decimals: Returns the number of decimals used to get its user representation. Overridden to return 0.
* getBalance: Allows the caller to check their token balance.
* transferToken: Allows transferring tokens to a specified address.
* burn: Allows any token holder to burn their tokens.

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

contract DegenToken is ERC20, Ownable, ERC20Burnable {

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function decimals() override public pure returns(uint8){
        return 0;
    }

    function getBalance() external view returns(uint256){
        return this.balanceOf(msg.sender);
    }

    function transferToken(address _receiver, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "You do not have enough Degen Tokens");
        approve(msg.sender, _value);
        transferFrom(msg.sender, _receiver, _value);
    }
}
```
# Executing Program
Deploy the contract using Remix (a platform to compile and deploy Solidity contracts) and implement all the functionalities by passing suitable values.

# Help
If you encounter any issues or need further assistance, please refer to the following resources:

* OpenZeppelin Documentation
* Remix Documentation

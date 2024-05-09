// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LiquidityVault is ERC4626 {
    ERC20 public assetToken;  // The token used for deposits (e.g., BTC)

    // Replace with the actual token contract address for the asset (e.g., USDC)
    constructor(ERC20 _assetToken) 
        ERC4626(_assetToken) {
        assetToken = _assetToken;
    }

    // Function to deposit liquidity
    function depositLiquidity(uint256 amount) external {
        require(assetToken.balanceOf(msg.sender) >= amount , "Not enough balance");

        // Transfer tokens from the user to the contract
        assetToken.transferFrom(msg.sender, address(this), amount);

        // Mint vault shares to the user
        _mint(msg.sender, amount);
    }

    // Function to withdraw liquidity
    function withdrawLiquidity(uint256 shares) external {
        // Burn the user's shares
        _burn(msg.sender, shares);

        // Transfer the underlying asset back to the user
        assetToken.transfer(msg.sender, shares);
    }
}

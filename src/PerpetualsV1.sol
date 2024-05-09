// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Price.sol";
import "./Lp.sol";

contract PerpetualProtocol {
    ERC20 public collateralToken; // The token used as collateral (e.g., USDC)
    uint256 public maxLeverage = 15; // Maximum allowed leverage
    address public liquityVaultAddress;

    PriceOracle price = PriceOracle(priceOracleAddress);
    LiquidityVault public Lp= LiquidityVault(liquityVaultAddress);

    struct Position {
        address trader;
        uint256 size;
        uint256 collateral;
        uint256 borrowedValue;
        bool isOpen;
        bool isLong; // true for long, false for short
    }

    mapping(address => Position) public positions;

    constructor(ERC20 _collateralToken, address _liquityVaultAddress, address _priceOracleAddress) {
        collateralToken = _collateralToken;
        liquityVaultAddress = _liquityVaultAddress;
        priceOracleAddress = _priceOracleAddress;
    }

    function openPosition(uint256 size, uint256 collateralAmount, bool isLong) external {
        require(!positions[msg.sender].isOpen, "Position already open");
        require(size / collateralAmount <= maxLeverage, "Exceeds maximum leverage");

        Lp.depositLiquidity(collateralAmount);

        int latestBTCPrice = PriceOracle.getLatestBTCPrice();

        // Calculate borrowed value based on the BTC price and position size
        uint256 borrowedValue = size * uint256(latestBTCPrice);

        positions[msg.sender] = Position({
            trader: msg.sender,
            size: size,
            collateral: collateralAmount,
            borrowedValue: borrowedValue,
            isOpen: true,
            isLong: isLong
        });

        // Additional logic for position opening might include price checks, etc.
    }

    function closePosition() external {
        require(positions[msg.sender].isOpen, "No open position to close");

        Position storage position = positions[msg.sender];
        uint256 pnl = calculatePnL(position);

        // Adjust collateral based on PnL
        if (pnl > 0) {
            collateralToken.transfer(position.trader, position.collateral + pnl);
        } else {
            collateralToken.transfer(position.trader, position.collateral);
        }

        delete positions[msg.sender];
    }

    function calculatePnL(Position storage position) private view returns (uint256) {
        uint256 currentMarketValue = getCurrentMarketValue(); // Implement this function
        uint256 averagePositionPrice = getAveragePositionPrice(); // Implement this function

        if (position.isLong) {
            return (currentMarketValue - averagePositionPrice) * position.size;
        } else {
            return (averagePositionPrice - currentMarketValue) * position.size;
        }
    }

}

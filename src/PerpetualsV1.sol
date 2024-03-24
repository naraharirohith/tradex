// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PerpetualProtocol {
    ERC20 public collateralToken; // The token used as collateral (e.g., USDC)
    uint256 public maxLeverage = 15; // Maximum allowed leverage

    struct Position {
        address trader;
        uint256 size;
        uint256 collateral;
        bool isOpen;
        bool isLong; // true for long, false for short
    }

    mapping(address => Position) public positions;

    constructor(ERC20 _collateralToken) {
        collateralToken = _collateralToken;
    }

    function openPosition(uint256 size, uint256 collateralAmount, bool isLong) external {
        require(!positions[msg.sender].isOpen, "Position already open");
        require(collateralToken.transferFrom(msg.sender, address(this), collateralAmount), "Collateral transfer failed");
        require(size / collateralAmount <= maxLeverage, "Exceeds maximum leverage");

        positions[msg.sender] = Position({
            trader: msg.sender,
            size: size,
            collateral: collateralAmount,
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

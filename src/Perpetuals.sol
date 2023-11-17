// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract PerpetualProtocol {
    address public owner;
    uint256 public totalLiquidity;
    
    struct Position {
        address trader;
        uint256 size;
        uint256 collateral;
    }
    
    Position[] public positions;
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
    
    function deposit() external payable {
        totalLiquidity += msg.value;
    }
    
    function openPosition(uint256 size, uint256 collateral) external payable {
        require(size > 0, "Position size must be greater than zero");
        require(collateral > 0, "Collateral must be greater than zero");
        require(msg.value == collateral, "Collateral must match the sent value");
        
        positions.push(Position(msg.sender, size, collateral));
    }
    
    function closePosition(uint256 positionIndex) external {
        require(positionIndex < positions.length, "Invalid position index");
        Position storage position = positions[positionIndex];
        require(msg.sender == position.trader, "Only the position owner can close it");
        
        uint256 payout = calculatePayout(position);
        require(payout > 0, "No payout available");
        
        // Transfer the payout to the trader
        payable(msg.sender).transfer(payout);
        
        // Remove the closed position
        delete positions[positionIndex];
    }
    
    function calculatePayout(Position storage position) internal view returns (uint256) {
        // Simplified logic: Payout is based on the position's size
        return position.size;
    }
}

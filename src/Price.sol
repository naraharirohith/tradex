// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceOracle {
    AggregatorV3Interface internal btcPriceFeed;
    AggregatorV3Interface internal usdcPriceFeed;

    address public BTC_Price_Feed_Address = 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43;
    // address USDC_Price_Feed_Address = 

    /**
     * Network: Mainnet
     * Aggregator: BTC/USD
     * Address: [Provide the Chainlink BTC/USD price feed address for your network]
     * Aggregator: USDC/USD
     * Address: [Provide the Chainlink USDC/USD price feed address for your network]
     */
    constructor() {
        // Replace the addresses below with the appropriate ones for your network
        btcPriceFeed = AggregatorV3Interface(BTC_Price_Feed_Address);
        // usdcPriceFeed = AggregatorV3Interface([USDC_Price_Feed_Address]);
    }

    /**
     * Returns the latest price of BTC
     */
    function getLatestBTCPrice() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = btcPriceFeed.latestRoundData();
        return price;
    }

    /**
     * Returns the latest price of USDC
     */
    // function getLatestUSDCPrice() public view returns (int) {
    //     (
    //         /*uint80 roundID*/,
    //         int price,
    //         /*uint startedAt*/,
    //         /*uint timeStamp*/,
    //         /*uint80 answeredInRound*/
    //     ) = usdcPriceFeed.latestRoundData();
    //     return price;
    // }
}

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.16;

import "./Zuniswap.sol";

interface IZuniswapFactory {
    function createExchange(address _tokenAddress) external returns (address);
    function getExchange(address _tokenAddress) external returns (address);
}

contract ZuniswapFactory is IZuniswapFactory {
    mapping(address => address) public tokenExchange;

    event ExchangeCreated(address indexed token, address indexed exchange);

    function createExchange(address _tokenAddress) public returns (address) {
        require(_tokenAddress != address(0), "Cannot create exchange with 0 address");
        require(tokenExchange[_tokenAddress] == address(0), "exchange already exists");

        Zuniswap exchange = new Zuniswap(_tokenAddress);
        tokenExchange[_tokenAddress] = address(exchange);

        emit ExchangeCreated(_tokenAddress, address(exchange));

        return address(exchange);
    }

    function getExchange(address _tokenAddress) public view returns (address) {
        return tokenExchange[_tokenAddress];
    }
}

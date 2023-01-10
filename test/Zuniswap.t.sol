// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/core/Zuniswap.sol";
import "../src/lib/IERC20.sol";
import "../src/lib/ERC20.sol";

contract ZuniswapTest is Test {
    ERC20Mintable public token;
    Zuniswap public pool;

    function setUp() public {
        token = new ERC20Mintable("DAI", "DAI", 18);
        token.mint(address(this), 100000000000 ether);
        pool = new Zuniswap(address(token));
    }

    function testAddLiquidity() public {
        vm.deal(address(this), 1 ether);
        token.approve(address(pool), 200 wei);

        pool.addLiquidity{value: 100 wei}(200);

        assertTrue(token.balanceOf(address(pool)) == 200 wei);
        assertTrue(pool.getReserve() == 200 wei);
        assertTrue(address(pool).balance == 100 wei);
    }

    function testGetPrice() public {
        vm.deal(address(this), 1 ether);
        token.approve(address(pool), 200 wei);

        pool.addLiquidity{value: 100 wei}(200 wei);

        uint256 tokenReserve = pool.getReserve();
        uint256 etherReserve = address(pool).balance;

        // price(x) = X/Y
        assertTrue(pool.getPrice(etherReserve, tokenReserve) == 500);
        // price(y) = Y/X
        assertTrue(pool.getPrice(tokenReserve, etherReserve) == 2000);
    }

    function testGetTokenAmount() public {
        vm.deal(address(this), 1000 ether);
        token.approve(address(pool), 2000 ether);

        pool.addLiquidity{value: 1000 ether}(2000 ether);

        uint256 tokensOut = pool.getTokenAmount(1 ether);
        console.log(tokensOut);
        assertTrue(tokensOut == 1998001998001998001);
    }
}

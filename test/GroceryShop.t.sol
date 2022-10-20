// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/GroceryShop.sol";


contract GroceryShopTest is Test {
    event Added(GroceryShop.GroceryType groceryType, uint256 units);
    event Bought(uint256 purchaseId, GroceryShop.GroceryType groceryType, uint256 units);
    
    GroceryShop public groceryShop;

    address testOwner;
    address testBuyer;

    uint256 initialBreadCount = 10;
    uint256 initialEggCount = 10;
    uint256 initialJamCount = 10;

    function setUp() public {
        groceryShop = new GroceryShop(
            initialBreadCount,
            initialEggCount,
            initialJamCount
        );

        testOwner = address(this);
        testBuyer = address(0xABCD);
    }

    function testOwnerCanAdd() public {
        groceryShop.add(GroceryShop.GroceryType.Bread, 10);
    }

    function testFailAddIfNotOwner() public {
        vm.prank(testBuyer);
        groceryShop.add(GroceryShop.GroceryType.Bread, 10);
    }

    function testExpectEmitAddEvent() public {
        vm.expectEmit(false, false, false, true);

        emit Added(GroceryShop.GroceryType.Bread, 10);
        groceryShop.add(GroceryShop.GroceryType.Bread, 10);
    }

    function testFailIfInvalidAmountPassed() public {
        groceryShop.buy{value: 0.01 ether}(GroceryShop.GroceryType.Bread, 10);
    }

    function testFailIfNotEnoughStock() public {
        groceryShop.buy{value: 0.1 ether}(GroceryShop.GroceryType.Bread, 20);
    }

    function testExpectEmitBuyEvent() public {
        vm.expectEmit(false, false, false, true);

        emit Bought(1, GroceryShop.GroceryType.Bread, 1);
        groceryShop.buy{value: 0.01 ether}(GroceryShop.GroceryType.Bread, 1);
    }

    function testCashRegister() public {
        payable(testBuyer).transfer(0.1 ether);

        vm.prank(testBuyer);
        groceryShop.buy{value: 0.01 ether}(GroceryShop.GroceryType.Bread, 1);

        (address buyer, GroceryShop.GroceryType item, uint256 count) = groceryShop.cashRegister(1);

        assertEq(buyer, testBuyer);
        assertEq(uint(item), uint(GroceryShop.GroceryType.Bread));
        assertEq(count, 1);

    }
}

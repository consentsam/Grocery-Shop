// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract GroceryShop {
    enum GroceryType {
        None,
        Bread,
        Egg,
        Jam
    }
    struct Transaction {
        address user;
        GroceryType item;
        uint256 count;
    }
    
    address payable public owner;
    uint256 purchaseId = 1;
    mapping(GroceryType => uint256) public groceryCount;
    mapping(uint256 => Transaction) public cashRegister;
    

    event Added(GroceryType grocery, uint256 units);
    event Bought(uint256 purchaseId, GroceryType grocery, uint256 units);

    error NotEnoughMoney(uint256 requested, uint256 available);
    error InvalidQuantityEntered(uint256 units);
    error NotEnoughQuantityInGroceryStore(uint256 units);
    error InvalidGrocerySelected(GroceryType grocery);

    constructor(
        uint256 _breadCount,
        uint256 _eggCount,
        uint256 _jamCount
    ) {
        owner = payable(msg.sender);
        groceryCount[GroceryType.Bread] = _breadCount;
        groceryCount[GroceryType.Egg] = _eggCount;
        groceryCount[GroceryType.Jam] = _jamCount;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "This function can only be called by owner of this grocery shop"
        );
        _;
    }

    modifier notEnoughMoney(uint256 x) {
        if (msg.value < x * 1e16 wei) {
            revert NotEnoughMoney(x * 1e16 wei, msg.value);
        }
        _;
    }

    modifier validGrocery(GroceryType _grocery) {
        if (
            _grocery != GroceryType.Bread &&
            _grocery != GroceryType.Egg &&
            _grocery != GroceryType.Jam
        ) {
            revert InvalidGrocerySelected(_grocery);
        }
        _;
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getBreadQuantity() external view returns (uint256) {
        return groceryCount[GroceryType.Bread];
    }

    function getEggQuantity() external view returns (uint256) {
        return groceryCount[GroceryType.Egg];
    }

    function getJamQuantity() external view returns (uint256) {
        return groceryCount[GroceryType.Jam];
    }

    function add(GroceryType _grocery, uint256 units)
        external
        onlyOwner
        validGrocery(_grocery)
    {
        if (units <= 0) {
            revert InvalidQuantityEntered(units);
        }
        cashRegister[purchaseId] = Transaction(msg.sender, _grocery, units);
        // cashRegister[purchaseId].count += units;
        purchaseId += 1;
        groceryCount[_grocery] += units;
        emit Added(_grocery, units);
    }

    function buy(GroceryType _grocery, uint256 units)
        external
        payable
        validGrocery(_grocery)
        notEnoughMoney(units)
    {
        if (units <= 0) {
            revert InvalidQuantityEntered(units);
        }
        if (units > groceryCount[_grocery]) {
            revert NotEnoughQuantityInGroceryStore(units);
        }
        groceryCount[_grocery] -= units;
        cashRegister[purchaseId] = Transaction(msg.sender, _grocery, units);
        emit Bought(purchaseId, _grocery, units);
        purchaseId += 1;
    }

    function withdraw() external onlyOwner {
        (bool sent, ) = owner.call{value: address(this).balance}("");
        require(sent, "Withdrawl failed, Please try again");
    }

    receive() external payable {}
}

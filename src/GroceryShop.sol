// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract GroceryShop{

    enum Grocery{
        None,
        Bread,
        Egg,
        Jam
    }

    address payable public owner;
    mapping(uint => uint) groceryRegistry;

    uint256 orderNumber=1;

    event Added(Grocery grocery, uint256 unit);
    event Bought(uint256 purchaseId, Grocery grocery, uint256 unit);

    error NotEnoughMoney(uint256 requested,uint256 available);
    error InvalidQuantityEntered(uint256 amount);
    error NotEnoughQuantityInGroceryStore(uint256 amount);
    error InvalidGrocerySelected(Grocery grocery);

    constructor(uint256 _breadCount, uint256  _eggCount, uint256 _jamCount){
        groceryRegistry[uint256(Grocery.Bread)] = _breadCount;
        groceryRegistry[uint256(Grocery.Egg)]   = _eggCount;
        groceryRegistry[uint256(Grocery.Jam)]   = _jamCount;
        owner = payable(msg.sender) ;
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"This function can only be called by owner of this grocery shop");
        _;
    }

    modifier notEnoughMoney(uint256 x){
        if(msg.value< x*1e16 wei){
            revert NotEnoughMoney(x*1e16 wei, msg.value);
        }
        _;
    }

    modifier validGrocery(Grocery _grocery){
        if( _grocery!=Grocery.Bread && _grocery!=Grocery.Egg && _grocery!=Grocery.Jam ){
            revert InvalidGrocerySelected(_grocery);
        }
        _;
    }

    function getContractBalance() view external returns (uint256) {
        return address(this).balance;
    }
    function getBreadQuantity() view external returns (uint256){
        return groceryRegistry[uint256(Grocery.Bread)];
    }
    function getEggQuantity() view external returns (uint256){
        return groceryRegistry[uint256(Grocery.Egg)];
    }
    function getJamQuantity() view external returns (uint256){
        return groceryRegistry[uint256(Grocery.Jam)];
    }

    function add(Grocery _grocery, uint256 unit) onlyOwner validGrocery(_grocery)  external  {
        if(unit<=0){
            revert InvalidQuantityEntered(unit);
        }
        groceryRegistry[uint256(_grocery)] += unit;
        emit Added(_grocery,unit);
    }

    function buy(Grocery _grocery, uint256 unit) validGrocery(_grocery) notEnoughMoney(unit) external payable {
        
        if(unit<=0){
            revert InvalidQuantityEntered(unit);
        }
        if(unit>groceryRegistry[uint256(_grocery)]){
            revert NotEnoughQuantityInGroceryStore(unit);
        }
        groceryRegistry[uint256(_grocery)] -= unit;
        emit Bought(orderNumber,_grocery, unit);
        orderNumber+=1;

    }

    function withdraw() onlyOwner external {
        (bool sent, ) = owner.call{value: address(this).balance}("");
        require(sent, "Withdrawl failed, Please try again");
    }
    
    receive() external payable {}
}

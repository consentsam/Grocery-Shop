// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract GroceryShop{

    enum GroceryType{
        None,
        Bread,
        Egg,
        Jam
    }

    address payable public owner;
    mapping(uint => uint) cashRegister;

    uint256 purchaseId=1;

    event Added(GroceryType grocery, uint256 units);
    event Bought(uint256 purchaseId, GroceryType grocery, uint256 units);

    error NotEnoughMoney(uint256 requested,uint256 available);
    error InvalidQuantityEntered(uint256 units);
    error NotEnoughQuantityInGroceryStore(uint256 units);
    error InvalidGrocerySelected(GroceryType grocery);

    constructor(uint256 _breadCount, uint256  _eggCount, uint256 _jamCount){
        cashRegister[uint256(GroceryType.Bread)] = _breadCount;
        cashRegister[uint256(GroceryType.Egg)]   = _eggCount;
        cashRegister[uint256(GroceryType.Jam)]   = _jamCount;
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

    modifier validGrocery(GroceryType _grocery){
        if( _grocery!=GroceryType.Bread && _grocery!=GroceryType.Egg && _grocery!=GroceryType.Jam ){
            revert InvalidGrocerySelected(_grocery);
        }
        _;
    }

    function getContractBalance() view external returns (uint256) {
        return address(this).balance;
    }
    function getBreadQuantity() view external returns (uint256){
        return cashRegister[uint256(GroceryType.Bread)];
    }
    function getEggQuantity() view external returns (uint256){
        return cashRegister[uint256(GroceryType.Egg)];
    }
    function getJamQuantity() view external returns (uint256){
        return cashRegister[uint256(GroceryType.Jam)];
    }

    function add(GroceryType _grocery, uint256 units) onlyOwner validGrocery(_grocery)  external  {
        if(units<=0){
            revert InvalidQuantityEntered(units);
        }
        cashRegister[uint256(_grocery)] += units;
        emit Added(_grocery,units);
    }

    function buy(GroceryType _grocery, uint256 units) validGrocery(_grocery) notEnoughMoney(units) external payable {
        
        if(units<=0){
            revert InvalidQuantityEntered(units);
        }
        if(units>cashRegister[uint256(_grocery)]){
            revert NotEnoughQuantityInGroceryStore(units);
        }
        cashRegister[uint256(_grocery)] -= units;
        emit Bought(purchaseId,_grocery, units);
        purchaseId+=1;

    }

    function withdraw() onlyOwner external {
        (bool sent, ) = owner.call{value: address(this).balance}("");
        require(sent, "Withdrawl failed, Please try again");
    }
    
    receive() external payable {}
}

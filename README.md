# Grocery Shop

## Goal

The goal of this exercise is to develop a `Grocery Shop` smart contract, deploy it on **Goerli testnet** and also verify the contract on **Goerli Etherscan**. This `Grocery Shop` has 3 kinds of groceries

-   Bread (GroceryType: 1)
-   Egg (GroceryType: 2)
-   Jam (GroceryType: 3)

This shop maintains a cash register which keeps records of all groceries.

Complete this contract with following specifications for each function

-   constructor(uint256 breadCount, uint256 eggCount, uint256 jamCount)

    -   Takes initial number of items of each grocery in order - Bread, Egg and Jam, and stores them.
    -   Should save the sender of this transaction as **owner**.

-   add

    -   This function is only callable by owner.
    -   It takes in the `Grocery Type` as first parameter and number of units to add as the second parameter.
    -   It should emit an event named `Added` with parameters `Grocery Type` and `Number of units added`.

-   buy

    -   This function takes in `Grocery Type` and `Number of units to buy` as parameters.
    -   For simplicity, the price of each unit in shop irrespective of its type is **0.01 ether**.
    -   It should emit an event named `Bought` with parameters `Purchase Id`, `Grocery Type` and `Number of units bought`. The `Purchase Id` in this case should start from **1** and increment sequentially on every purchase.

-   withdraw

    -   This function is only callable by owner.
    -   It should transfer the entire amount in contract to the owner.

## Evaluation

-   Write the contract on `Remix` and test it for following scenarios manually
    -   `add` function should not allow anyone other than owner.
    -   `buy` should revert when invalid amount is passed.
    -   Correct events should be emitted as mentioned in specifications.

-   Deploy the contract on Goerli testnet through **Remix** and verify it [here](https://goerli.etherscan.io/verifyContract).

-   Clone this repo. Use the flag `--recurse-submodules` to clone the repo along with the submodules. You can use the following command after replacing the `CLONE_URL` with the clone url of your repo

    ```
    git clone --recurse-submodules CLONE_URL
    ```

-   Create a new branch with your name. You can use the following command

    ```
    git checkout -b my-name
    ```

-   Paste the code from Remix to `src/GroceryShop.sol` file.

-   Replace `PASTE_YOUR_CONTRACT_ADDRESS_HERE` with your contract address at the end of this README file.

-   Commit and push your changes.

-   Create a pull request from your forked repo to main branch of original repo to run the github workflow.

## Note

-   Add proper checks for invalid inputs and error cases.
-   Use modifier where appropriate.
-   Use enums and structs where appropriate.

## Contract Address

PASTE_YOUR_CONTRACT_ADDRESS_HERE

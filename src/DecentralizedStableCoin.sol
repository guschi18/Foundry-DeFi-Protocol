// SPDX-License-Identifier: MIT

// Layout of the contract file:
// version
// imports
// errors
// interfaces, libraries, contract

// Inside Contract:
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private

// view & pure functions

/*
        * @title: DecentralizedStableCoin
        * @author: HansP
        * Collateral: Exogenous (ETH & BTC)
        * Minting: Algorithmic
        * Relative Stability: Pegged to USD
        *
        * This is the contract meant to be governed by DSCEngine. This contract is just the ERC20 implementation of our stablecoin system.
*/

pragma solidity ^0.8.18;

/**
 * Imports
 */
import {ERC20Burnable, ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * Errors
 */
error DecentralizedStableCoin__MustBeMoreThanZero();
error DecentralizedStableCoin__BurnAmountExceedsBalance();
error DecentralizedStableCoin__NotZeroAddress();

contract DecentralizedStableCoin is ERC20Burnable, Ownable {
    /**
     * Constructor
     */
    constructor() Ownable(msg.sender) ERC20("DecentralizedStableCoin", "DSC") {}

    /**
     * External Functions
     */
    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount <= 0) {
            revert DecentralizedStableCoin__MustBeMoreThanZero();
        }
        if (balance < _amount) {
            revert DecentralizedStableCoin__BurnAmountExceedsBalance();
        }
        super.burn(_amount);
    }

    function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
        if (_to == address(0)) {
            revert DecentralizedStableCoin__NotZeroAddress();
        }
        if (_amount <= 0) {
            revert DecentralizedStableCoin__MustBeMoreThanZero();
        }
        _mint(_to, _amount);
        return true;
    }

    /**
     * Internal Functions
     */

    /**
     * Private Functions
     */
}

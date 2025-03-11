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
        * @title DSCEngine
        * @author HansP
        *
        * The system is designed to be as minimal as possible, and have the tokens maintain a 1 token == $1 peg at all times.
        * This is a stablecoin with the properties:
        * - Exogenously Collateralized
        * - Dollar Pegged
        * - Algorithmically Stable
        *
        * It is similar to DAI if DAI had no governance, no fees, and was backed by only WETH and WBTC.
        *
        * Our DSC system should always be "overcollateralized". At no point, should the value of
        * all collateral < the $ backed value of all the DSC.
        *
        * @notice This contract is the core of the Decentralized Stablecoin system. It handles all the logic
        * for minting and redeeming DSC, as well as depositing and withdrawing collateral.
        * @notice This contract is based on the MakerDAO DSS system
        */

pragma solidity ^0.8.18;

/**
 * Imports
 */
import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {AggregatorV3Interface} from
    "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract DSCEngine is ReentrancyGuard {
    /**
     * Errors
     */
    error DSCEngine__NeedMoreThanZero();
    error DSCEngine__TokenNotAllowed();
    error DSCEngine__TokenAddressesAndPriceFeedAddressesLengthsMustBeTheSame();
    error DSCEngine__TransferFailed();

    /**
     * State Variables
     */
    DecentralizedStableCoin private immutable i_dsc;
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;
    mapping(address token => address priceFeed) private s_priceFeeds;
    mapping(address user => uint256 amountDscMinted) private s_DSCMinted;
    address[] private s_collateralTokens;

    uint256 private constant ADDITIONAL_FEED_PRECISION = 1e10;
    uint256 private constant PRECISION = 1e18;

    /**
     * Events
     */
    event CollateralDeposited(address indexed user, address indexed token, uint256 amount);

    /**
     * Modifiers
     */
    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert DSCEngine__NeedMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert DSCEngine__TokenNotAllowed();
        }
        _;
    }

    /**
     * Constructor
     */
    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__TokenAddressesAndPriceFeedAddressesLengthsMustBeTheSame();
        }

        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
            s_collateralTokens.push(tokenAddresses[i]);
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }
    /**
     * Functions
     */

    /**
     * External Functions
     */
    function depositCollateralAndMintDsc() external {}

    /* 
    * @notice Deposit collateral and mint DSC
    * @param tokenCollateralAddress The address of the token to deposit as collateral
    * @param amountCollateral The amount of collateral to deposit
    */
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        //Checks
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        //Effects
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);

        //Interactions
        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
        if (!success) {
            revert DSCEngine__TransferFailed();
        }
    }

    function redeemCollateralForDsc() external {}

    function redeemCollateral() external {}

    /*
    * @param amountDscToMint: The amount of DSC you want to mint
    * You can only mint DSC if you hav enough collateral
    */
    function mintDsc(uint256 amountDscToMint) public moreThanZero(amountDscToMint) nonReentrant {
        // Effects
        s_DSCMinted[msg.sender] += amountDscToMint;
        _revertIfHealthFactorIsBroken(msg.sender);
    }

    function burnDsc() external {}

    function liquidate() external {}

    /**
     * Getter Functions
     */
    function getAccountCollateralValue(address user) public view returns (uint256 totalCollateralValueInUsd) {
        for (uint256 i = 0; i < s_collateralTokens.length; i++) {
            address token = s_collateralTokens[i];
            uint256 amount = s_collateralDeposited[user][token];
            totalCollateralValueInUsd += getUsdValue(token, amount);
        }
        return totalCollateralValueInUsd;
    }

    function getUsdValue(address token, uint256 amount) public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeeds[token]);
        (, int256 price,,,) = priceFeed.latestRoundData();
        return ((uint256(price) * ADDITIONAL_FEED_PRECISION) * amount) / PRECISION;
    }

    /**
     * Private & Internal View Functions
     */
    function _revertIfHealthFactorIsBroken(address user) internal view {}

    /*
    * Returns how close to liquidation a user is
    * If a user goes below 1, then they can be liquidated.
    */
    function _healthFactor(address user) private view returns (uint256) {
        (uint256 totalDscMinted, uint256 collateralValueInUsd) = _getAccountInformation(user);
    }

    function _getAccountInformation(address user)
        private
        view
        returns (uint256 totalDscMinted, uint256 collateralValueInUsd)
    {
        totalDscMinted = s_DSCMinted[user];
        collateralValueInUsd = getAccountCollateralValue(user);
    }
}

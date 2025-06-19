# Decentralized Stablecoin (DSC) Protocol

A sophisticated DeFi protocol implementing an algorithmic, overcollateralized stablecoin system built on Ethereum. This project creates a decentralized stablecoin that maintains a $1 USD peg through exogenous collateral and algorithmic stability mechanisms.

## 🔥 Features

- **USD-Pegged Stablecoin**: Maintains 1:1 parity with USD using Chainlink price feeds
- **Overcollateralized System**: Requires 200% collateralization ratio for minting
- **Dual Collateral Support**: Accepts WETH and WBTC as collateral
- **Automated Liquidations**: Protects the protocol through incentivized liquidation mechanisms
- **Decentralized & Trustless**: No governance tokens, no fees, purely algorithmic

## 🏗️ System Architecture

### Core Components

1. **DecentralizedStableCoin (DSC)** - The ERC20 stablecoin token
2. **DSCEngine** - Core protocol logic handling collateral, minting, and liquidations
3. **Price Oracle Integration** - Chainlink price feeds for accurate asset pricing

### Key Features

- **Exogenous Collateral**: Backed by WETH and WBTC (external assets)
- **Algorithmic Stability**: No governance required, purely code-driven
- **Liquidation Protection**: 10% bonus for liquidators to maintain system health
- **Health Factor System**: Continuous monitoring of collateralization ratios

## 🎯 Project Goals

1. **Relative Stability**: USD-pegged through Chainlink price feeds
2. **Stability Mechanism**: Algorithmic and decentralized with sufficient collateral backing
3. **Collateral Types**: Exogenous collateral (WETH & WBTC)
4. **Overcollateralization**: System maintains >200% collateral ratio at all times

## 🔧 Technical Implementation

### Smart Contracts

#### DecentralizedStableCoin.sol
- ERC20 token implementation with burn and mint capabilities
- Ownable pattern with DSCEngine as the owner
- Input validation and error handling

#### DSCEngine.sol
- Core protocol mechanics
- Collateral management (deposit/withdraw)
- DSC minting and burning
- Liquidation system
- Health factor calculations
- Integration with Chainlink price feeds

### Key Constants
- **Liquidation Threshold**: 50% (200% overcollateralization)
- **Minimum Health Factor**: 1.0
- **Liquidation Bonus**: 10%
- **Precision**: 18 decimals

## 🚀 Getting Started

### Prerequisites
- [Foundry](https://getfoundry.sh/) - Ethereum development toolkit
- [Git](https://git-scm.com/)

### Installation

```bash
git clone https://github.com/your-username/decentralized-stablecoin
cd decentralized-stablecoin
forge install
```

### Build

```bash
forge build
```

### Test

```bash
forge test
```

## 🌐 Deployment

The protocol supports deployment on:
- **Ethereum Sepolia Testnet** (with live Chainlink price feeds)
- **Local Anvil Network** (with mock price feeds for development)

### Deploy to Anvil (Local)

```bash
anvil
forge script script/DeployDSC.s.sol --rpc-url http://localhost:8545 --private-key <your-private-key> --broadcast
```

### Deploy to Sepolia

```bash
forge script script/DeployDSC.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

## 🔄 Protocol Mechanics

### Minting DSC
1. Deposit WETH or WBTC as collateral
2. Ensure collateralization ratio > 200%
3. Mint DSC tokens up to safe limits
4. Health factor must remain > 1.0

### Liquidation Process
1. User's health factor falls below 1.0
2. Liquidators can repay user's debt
3. Liquidators receive collateral + 10% bonus
4. Protocol remains healthy and overcollateralized

### Health Factor Calculation
```
Health Factor = (Collateral Value * Liquidation Threshold) / Total DSC Minted
```

## 🛡️ Security Features

- **Reentrancy Protection**: OpenZeppelin's ReentrancyGuard
- **Input Validation**: Comprehensive checks on all user inputs
- **Price Feed Security**: Chainlink oracle integration
- **Overcollateralization**: Built-in safety margins
- **Liquidation Incentives**: Economic incentives for system health

## 🧪 Testing

The protocol includes comprehensive test suites:
- Unit tests for core functionality
- Integration tests for multi-contract interactions
- Fuzz testing for edge cases
- Mock contracts for isolated testing

## 📊 Comparison to Existing Protocols

This protocol is similar to MakerDAO's DAI but with key differences:
- ✅ No governance complexity
- ✅ No stability fees
- ✅ Simplified collateral types (WETH & WBTC only)
- ✅ Pure algorithmic stability

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This is an educational project and should not be used in production without proper auditing. Cryptocurrency investments carry risk, and you should do your own research before interacting with any DeFi protocol.

## 🔗 Resources

- [Foundry Documentation](https://book.getfoundry.sh/)
- [Chainlink Price Feeds](https://docs.chain.link/data-feeds)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [MakerDAO Documentation](https://docs.makerdao.com/)
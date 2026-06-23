# Payment Management — Wallet & Payout Journey

## Actor
A user (buyer or provider) who needs to manage incoming/outgoing payments through the platform.

## Goal
View balance, initiate a payout to their linked bank account or wallet.

## Steps
1. Navigates to their wallet/dashboard to review escrowed funds held in the Smart Contract Safe multisig.
2. Reviews milestone status — funds are held in USDC/EURC until each milestone is signed off.
3. Initiates a payout request; the smart contract automatically splits 95% to the provider and 5% to the solidarity fund.
4. Funds settle on-chain; user sees updated balance in their crypto wallet.

## Pain Points
- Gas fees for on-chain transactions.
- Non-crypto users may find crypto balances confusing.
- Stablecoin depeg risk (USDC/EURC stability).

## Success Criteria
The user initiates a payout, the smart contract executes the 95/5 split, and funds are settled on-chain.

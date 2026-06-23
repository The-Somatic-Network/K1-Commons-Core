# Payment Management — Wallet & Payout Journey

## Actor
A user (buyer or provider) who needs to manage incoming/outgoing payments through the platform.

## Goal
View balance, initiate a payout to their linked bank account or wallet.

## Steps
1. Navigates to their wallet/dashboard.
2. Reviews available balance (fiat_balance + time_credit_balance).
3. Initiates a payout request for the desired amount.
4. The platform processes the transfer via the payment provider (e.g., Stripe, Wise, or direct bank).
5. User confirms the payout is reflected in their bank account.

## Pain Points
- Payout delays — bank transfers can take days to clear.
- Insufficient balance — user tries to withdraw more than available.
- Provider fees — payment gateways take a cut on top of the platform fee.

## Success Criteria
The user initiates a payout and receives funds in their bank account within the expected timeframe.

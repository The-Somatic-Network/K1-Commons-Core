# Linked Bank Account — Wallet Setup Journey

## Actor
A user who needs to connect their bank account to enable payouts and payments.

## Goal
Link a bank account through a third-party provider (e.g., Stripe, Wise) so they can receive payouts and make payments.

## Steps
1. Navigates to account settings → authentication methods.
2. Sets up account abstraction — Google login or Passkey (no seed phrases needed).
3. Connects Stripe as the credit-card-to-crypto on-ramp so non-crypto users experience a normal checkout flow.
4. Confirms the account is ready for transactions (fiat on-ramp → auto-converted to USDC/EURC).

## Pain Points
- Google login may raise privacy concerns.
- Passkey setup requires a compatible device/browser.
- Stripe on-ramp fees reduce effective payout amount.

## Success Criteria
The user completes setup via account abstraction (Google/Passkey) and can fund their wallet through Stripe's credit-card on-ramp.

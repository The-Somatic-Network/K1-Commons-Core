# The Dispute Resolution — Mediation Journey

## Actor
A buyer or provider who is in a disagreement over a contract's scope, quality, or payment terms.

## Goal
Resolve the dispute fairly through mediation or arbitration.

## Steps
1. The freelancer marks a milestone as complete (optimistic release).
2. A dispute window opens (e.g., 48–72 hours) during which the buyer can challenge the milestone.
3. If unchallenged, the smart contract auto-pays the milestone funds.
4. If the buyer files a dispute during the window, the case is routed to a third-party on-chain arbitrator (e.g., Kleros).
5. Kleros jurors vote on the evidence, and the contract distributes the escrowed funds according to the ruling.

## Pain Points
- Kleros arbitration fees and gas costs.
- Jurisdiction/language matching for jurors.
- Dispute window may be too short or too long depending on the contract type.

## Success Criteria
The dispute is resolved by the third-party arbitrator and funds are distributed on-chain without platform mediation.

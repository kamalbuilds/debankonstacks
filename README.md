# NFT Collateral Loan Contract on Stacks

This project introduces a novel smart contract for the Stacks blockchain, allowing Stacks Monkey NFT owners to use their non-fungible tokens (NFTs) from the "Stacks Monkeys" collection as collateral to secure loans. Lenders can provide loans to these NFT owners, and if the loan is not repaid by a specified due date, the NFT collateral is transferred to the lender. This mechanism provides liquidity to NFT owners while offering lenders an opportunity to earn interest or potentially acquire valuable NFTs.

## Features

- **Stake NFTs**: NFT owners can stake their "Stacks Monkeys" NFTs as collateral for loans.
- **Loan Provision**: Lenders can offer loans to NFT stakers, specifying loan amounts and due dates.
- **Loan Repayment**: Borrowers can repay loans before the due date to reclaim their NFTs.
- **Claim Collateral**: Lenders can claim the NFT collateral if the loan is not repaid on time.
- **Extend Loan**: Borrowers have the option to extend the loan period under certain conditions.
- **Loan and Staking Information**: Users can query the contract to get information about staked NFTs and loans.

## Prerequisites

Before interacting with the contract, ensure you have:

- A Stacks Wallet with STX tokens for transaction fees.
- Ownership of "Stacks Monkeys" NFTs you wish to stake as collateral.

## Contract Functions

### Stake NFT

```lisp
(stake-nft (token-id uint))
```
- **Description**: Stake a "Stacks Monkeys" NFT as collateral for a loan.
- **Parameters**:
  - `token-id`: The ID of the NFT to stake.

### Provide Loan

```lisp
(provide-loan (token-id uint) (loan-amount uint) (due-block uint))
```
- **Description**: Provide a loan to the staker of an NFT, specifying the loan amount and the repayment due date in block height.
- **Parameters**:
  - `token-id`: The ID of the staked NFT.
  - `loan-amount`: The amount of the loan.
  - `due-block`: The block height by which the loan must be repaid.

### Repay Loan

```lisp
(repay-loan (token-id uint))
```
- **Description**: Repay an outstanding loan and reclaim the staked NFT.
- **Parameters**:
  - `token-id`: The ID of the NFT for which the loan is being repaid.

### Claim Collateral

```lisp
(claim-collateral (token-id uint))
```
- **Description**: Claim the NFT collateral if the loan is not repaid by the due date.
- **Parameters**:
  - `token-id`: The ID of the NFT to claim as collateral.

### Extend Loan

```lisp
(extend-loan (token-id uint) (additional-blocks uint))
```
- **Description**: Extend the due date of an existing loan.
- **Parameters**:
  - `token-id`: The ID of the NFT for which the loan is extended.
  - `additional-blocks`: The number of blocks to extend the loan due date by.

### Get Staked NFT Info

```lisp
(get-staked-nft-info (token-id uint))
```
- **Description**: Retrieve information about a staked NFT, including the loan amount and due date.
- **Parameters**:
  - `token-id`: The ID of the staked NFT.

## Security Considerations

Users should be aware of the security implications of staking NFTs and providing loans. Ensure you trust the contract's operations and understand the terms of any loan you participate in, whether as a borrower or a lender.

## Development and Testing

This contract was developed and tested on the Stacks blockchain. Developers are encouraged to review the code, deploy it to a testnet, and perform thorough testing before considering a mainnet deployment.

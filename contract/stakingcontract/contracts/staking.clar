;; Interacting With the NFT and marketplace contracts
(use-trait nft-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

(define-constant ERR_NOT_OWNER (err u1))
(define-constant ERR_ALREADY_STAKED (err u2))
(define-constant ERR_NOT_STAKED (err u3))
(define-constant ERR_LOAN_ALREADY_TAKEN (err u4))
(define-constant ERR_LOAN_NOT_FULFILLED (err u5))
(define-constant ERR_LOAN_REPAYMENT_FAILED (err u6))

;; Maps token IDs to the principal that staked them
(define-map staked-nfts uint { owner: principal, lender: (optional principal), loan-amount: uint, due-block: uint })

;; Allows a user to stake an NFT as collateral for a loan
(define-public (stake-nft (token-id uint))
  (let ((owner (unwrap! (nft-get-owner? .Stacks-Monkeys token-id) ERR_NOT_OWNER)))
    (asserts! (is-eq owner tx-sender) ERR_NOT_OWNER)
    (try! (nft-transfer? .Stacks-Monkeys token-id owner (as-contract tx-sender)))
    (map-insert staked-nfts token-id { owner: owner, lender: none, loan-amount: u0, due-block: u0 })
    (ok true)
))

;; Allows a lender to provide a loan to a staked NFT
(define-public (provide-loan (token-id uint) (loan-amount uint) (due-block uint))
  (let ((stake-info (unwrap! (map-get? staked-nfts token-id) ERR_NOT_STAKED)))
    (asserts! (is-none (get lender stake-info)) ERR_LOAN_ALREADY_TAKEN)
    (map-set staked-nfts token-id { owner: (get owner stake-info), lender: (some tx-sender), loan-amount: loan-amount, due-block: due-block })
    (ok true)
))

;; Allows the borrower to repay the loan and retrieve their NFT
(define-public (repay-loan (token-id uint))
  (let ((stake-info (unwrap! (map-get? staked-nfts token-id) ERR_NOT_STAKED)))
    (asserts! (is-some (get lender stake-info)) ERR_LOAN_NOT_FULFILLED)
    (asserts! (<= block-height (get due-block stake-info)) ERR_LOAN_REPAYMENT_FAILED)
    ;; Assuming loan repayment handling here, e.g., transferring tokens to lender
    (nft-transfer? .Stacks-Monkeys token-id (as-contract tx-sender) (get owner stake-info))
    (map-delete staked-nfts token-id)
    (ok true)
))

;; Transfers the NFT to the lender if the loan is not repaid in time
(define-public (claim-collateral (token-id uint))
  (let ((stake-info (unwrap! (map-get? staked-nfts token-id) ERR_NOT_STAKED)))
    (asserts! (is-some (get lender stake-info)) ERR_LOAN_NOT_FULFILLED)
    (asserts! (> block-height (get due-block stake-info)) ERR_LOAN_REPAYMENT_FAILED)
    (nft-transfer? .Stacks-Monkeys token-id (as-contract tx-sender) (unwrap! (get lender stake-info) ERR_NOT_OWNER))
    (map-delete staked-nfts token-id)
    (ok true)
))

;; Optional: A function to allow the borrower to extend the loan period.
(define-public (extend-loan (token-id uint) (additional-blocks uint))
(let ((stake-info (unwrap! (map-get? staked-nfts token-id) ERR_NOT_STAKED)))
(asserts! (is-some (get lender stake-info)) ERR_LOAN_NOT_FULFILLED)
;; Check current due block is not already passed to prevent extending after expiry
(asserts! (> (get due-block stake-info) block-height) ERR_LOAN_REPAYMENT_FAILED)
(let ((new-due-block (+ (get due-block stake-info) additional-blocks)))
(map-set staked-nfts token-id {
owner: (get owner stake-info),
lender: (get lender stake-info),
loan-amount: (get loan-amount stake-info),
due-block: new-due-block
})
(ok true)
)
))

;; Public read-only function to check the status of a staked NFT
(define-read-only (get-staked-nft-info (token-id uint))
(map-get? staked-nfts token-id)
)

;; Helper function to transfer the NFT back to its owner in case of successful loan repayment or when reclaiming the NFT without taking a loan.
(define-private (nft-transfer-back (token-id uint))
(let ((stake-info (unwrap! (map-get? staked-nfts token-id) ERR_NOT_STAKED)))
(nft-transfer? .Stacks-Monkeys token-id (as-contract tx-sender) (get owner stake-info))
))
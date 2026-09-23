# Loan overpayment transfer validation

Run test codeunit 59080 "Loan Overpayment Tests" in a Business Central test environment. Its 18 tests cover loan/deposit/share-capital allocations, accumulation of multiple loans, source snapshot changes (including unchanged aggregate totals), and invalid balances. The tests do not post transactions.

The Overpaid Loans page offers:
- **Transfer Overpayment** for the current loan.
- **Transfer Customer Overpayments** for all posted, non-reversed overpaid loans of the current row's member, regardless of page filters.

Both actions preview the member, source count, combined excess, and destination allocations. Choose Loan, Deposits, or Share Capital. When paying a loan, the existing option can transfer the remainder to deposits.

Before production use, validate posting in a test company:

1. Configure GENERAL / DEFAULT, loan product Loan Accounts, and Deposit Contribution and Share Capital transaction posting groups. No. Series is optional; a blank series uses a unique OVT- reference.
2. With source loans -1,000.25 and -250.50 for one member, use the customer action. Verify a total of 1,250.75 and two included loans. Loans for other members, reversed/unposted loans, zero balances, and positive balances must be excluded. Changing page filters must not change the member-wide scope.
3. Transfer the combined total to deposits. Verify both source loans become zero, deposits increase by 1,250.75, and share capital is unchanged. There must be two source debits and one credit, with one document number.
4. Repeat with Share Capital. Verify share capital increases by 1,250.75, deposits are unchanged, and the share capital entry has no loan number. Also check the original single-loan action with Share Capital.
5. Transfer to the same member's loan owing 3,000. Verify target = 1,749.25 and both source loans = 0. For a target owing 1,000, enable the remainder option and verify target = 0 and deposits increase by 250.75. With the option disabled, verify rejection.
6. Reject another member's destination, a source loan as destination, an unposted/reversed destination, and a settled/overpaid destination, including manually entered numbers.
7. Add, remove, or change an overpaid source after preview. Verify posting rejects the stale snapshot even when source balances change by equal and opposite amounts. A repeat transfer must not transfer the same excess twice.
8. Place unrelated journal lines in GENERAL / DEFAULT and in a different batch. Confirmation must show the count to delete. Decline confirmation: nothing is deleted or posted. Confirm: only GENERAL / DEFAULT is cleared; only the newly generated transfer lines are posted. Other batches remain untouched.
9. Change the GENERAL / DEFAULT line count while confirmation is open. Verify posting rejects the changed batch before deletion.
10. Force an error during posting (such as invalid account/dimension setup after lines are created). Verify original GENERAL / DEFAULT lines are restored, no partial ledger entries survive, and source/destination balances are unchanged. Batch deletion and posting belong to the same transaction.
11. Check blocked members, missing transaction posting groups, invalid posting dates, rounding mismatches, and foreign-currency loans. Verify clean failure with no deletion or posting left behind.
12. Test both configured and blank batch number series, and inspect balanced G/L entries, common document numbers, descriptions, branch dimensions, and the source loans disappearing from Overpaid Loans after success.

The action uses the existing Outstanding Balance definition including interest and charges. It posts a debit Loan Repayment for each source, then credits Loan Repayment, Deposit Contribution, or Share Capital. It does not rewrite loan balances or approved amounts. Batch cleanup uses deletion triggers and occurs inside the posting transaction with commits suppressed.

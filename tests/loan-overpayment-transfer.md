# Loan overpayment transfer validation

Run test codeunit 59080 "Loan Overpayment Tests" in a Business Central test environment. Its ten tests cover allocation to deposits, partial/full repayment of an outstanding loan, remainder handling, penny precision, and invalid source/destination balances. These tests do not post transactions.

Before using the action in production, validate posting in a test company with representative loan products and member posting setup:

- Configure the GENERAL journal template and DEFAULT batch, loan product Loan Accounts, and the Deposit Contribution transaction posting group. GENERAL / DEFAULT must be empty. A batch number series is optional: if blank, the action supplies a unique 20-character OVT- document reference, checked against customer entries, G/L entries, and journal lines. The action does not use the operator's Funds User Setup payment batch.
- With a source balance of -1,250.25, transfer to the same member's loan owing 3,000. Confirm source = 0, destination = 1,749.75, deposits unchanged, balanced G/L entries, and the common document number on both loan ledger entries.
- Transfer -1,250.25 to deposits. Confirm source = 0 and member deposit contributions increase by 1,250.25. The deposit ledger entry must have no loan number.
- Transfer -1,250.25 to a loan owing 1,000 with the remainder option enabled. Confirm source = 0, target = 0, deposits increase by 250.25, and all three entries balance.
- Disable the remainder option for the preceding case; verify rejection with no posting. Cancel the dialog or decline confirmation; verify no changes.
- Try the source loan itself, a different member's loan, an unposted/reversed loan, or a settled/overpaid destination. Verify rejection, including when entering the destination number manually.
- Change the source or destination balance in another session after the transfer preview. Verify posting is rejected if the displayed allocation changed. Repeat a completed transfer; verify it cannot transfer the same excess twice.
- Leave the operator's PAYMENTS / ADMIN batch number series blank and configure a valid number series on GENERAL / DEFAULT. Verify the action posts through GENERAL / DEFAULT without depending on PAYMENTS / ADMIN or Funds User Setup.
- Clear No. Series on GENERAL / DEFAULT and post both a loan transfer and a deposit transfer. Verify no No. Series error, distinct OVT- references for each transfer, and the same reference on all entries within each transfer. Confirm the batch number-series setup remains blank.
- Place unrelated entries in GENERAL / DEFAULT. Verify the action refuses to post and neither deletes nor posts those entries.
- Introduce a blocked member, invalid posting date, missing deposit posting group, or invalid loan G/L setup. Verify no source debit, destination credit, consumed document number, or new journal lines survive the failed transaction.
- Verify foreign-currency members/loans are rejected. This action is restricted to local currency.
- Confirm the source disappears from Overpaid Loans after success, and Loan Ledger Entries shows the transfer description and document number.

The action uses the existing Outstanding Balance definition, including interest and charges, and records the transfer as a debit Loan Repayment on the source and credit Loan Repayment and/or Deposit Contribution on the destination. It does not rewrite loan balances, create a new loan, or alter approved loan amounts.

# Interest earned monthly trend

## Current interface

Both Interest Earned (page 59060) and Applied Loans (page 59076) display only a rolling 12-month product chart, with Refresh and Open Expanded View actions. Interest no longer shows summary figures, comparison percentages, Basis, included-product text, product-filter fields, or a view selector. Both use product descriptions rather than product/COA codes in their labels. The current month ends today and is labelled incomplete.

Interest expanded view is page 59087; Applied Loans expanded view is page 59088. Each expanded page contains only its corresponding chart part. Native role-center widths are client-controlled; expanded views provide a dedicated page for inspection.

## Interest calculation

The account scope remains `4101..4110&<>4107&<>4109`. Each monthly value is negative SUM of G/L Entry Amount on normal posting dates. Debit adjustments and reversal entries count in their posting months; income-closing entries are excluded. Amounts remain in company local currency, with negative and zero months preserved. This is posted net income, not cash collected.

Product descriptions come from Loan Products Setup Loan Interest Account mappings, falling back to the G/L account name. Shared accounts are counted once, and identical description labels combine their account filters into one series. Clicking a product bar opens only its account(s) and posting month. The amount shown equals negative sum of the ledger Amount field.

Applied Loans counts every Loans Register entry by application month regardless of approval/posting status. Its bar drill-down opens the matching product(s) and application month. See loans-applied-chart.md for aggregation checks.

## Deployment and verification

Compile, then publish through the normal release process. KRB INTEREST VIEW and KRB LOANS CHART provide additive feature permissions alongside existing finance permissions. No live deployment was performed by the source edits.

- Confirm both role-center cards contain only the monthly chart and two actions.
- Verify 12 month groups, distinct product series and description-only labels. No products are dropped when more than six series exist.
- Reconcile a month's interest series to the scoped net G/L entries and applied-loan series to Loans Register counts.
- Click each chart's bars and confirm the corresponding product/account and date filters.
- Open both expanded views and verify they show the same monthly data as their role-center cards.
- Verify no data, missing product mappings, identical descriptions, negative interest adjustments, and current incomplete months.
- Run codeunit 59086 Interest Insights Tests in a disposable Business Central test company with rollback isolation. Its synthetic G/L fixtures must not be run in production. Local compilation does not execute these AL tests.

The contribution page and legacy period-selection object remain available in source for compatibility but are not actions on the simplified charts.

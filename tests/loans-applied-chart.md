# Applied loans by product

The Applied Loans chart retains the rolling 12-month application-date count across all loan statuses, including posted loans. It now creates a series for every product represented in that period and fills missing months with zero. The current month ends today and is labelled incomplete. Future-dated records and records outside the 12-month window are excluded.

Legends show product descriptions only, falling back to the historical product name on the loan. Missing mappings/names are labelled Unknown product or Unspecified product. Identical descriptions share a series; each underlying product is included once in its drill-down filter. Each bar opens the corresponding product(s) and month in All Loans.

After publishing, verify two products with applications in the same month render separate bars; sum all series for each month and reconcile to the former monthly total. Check a product with zero applications in another month, equal descriptions, a blank product, a missing setup mapping, more than six products, the January/year boundary, and an empty date window. Confirm bar drill-down counts match the chart and future applications are excluded. Live UI verification requires Business Central.

The chart now offers Open Expanded View, opening page 59088 Loans Applied Overview. Verify the expanded page retains the monthly product trend and bar drill-down. Assign KRB LOANS CHART alongside existing finance permissions if the new page is not already covered by the user's permissions.

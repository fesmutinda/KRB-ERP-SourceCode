# Instant loan member blocks

## Deployment

1. Compile and publish the extension through the normal deployment process.
2. Assign profile **KRBSC- TREASURY** to the treasury users. This exposes existing Finance Role Center page 50011, with the new cue and navigation action. If a tenant-created profile with this caption already exists, select the extension profile or map the existing profile to page 50011.
3. Add **KRB INSTANT BLOCKS** to authorized treasury/admin users, alongside their existing finance permissions. This is an additive permission set, not a complete finance role.
4. Add **KRB INSTANT READ** to the portal service account alongside its existing service permissions. Do not assign maintenance permissions to the service account.
5. Verify that other assigned permission sets do not grant unwanted block-table writes. Profiles control the home page; permission sets control maintenance access.

No user assignments or production deployment are performed by the source change. Existing members start unblocked; no migration from the separate loan-level blacklist is performed.

## User flow

Open the **Blocked Instant Loan Members** cue or **Instant Loan Member Blocks** action on the Finance/Treasury role center. The cue counts active block records. The list opens with all members matching the existing Member List filters (Customer Type Member and posting group MEMBER), so it supports both blocking and unblocking. Search for a member and check or uncheck **Block Instant Loans**. The change saves immediately. Use the Blocked column filter to show only blocked members. **Block History** shows the selected member's changes. **Refresh** reloads the latest statuses; conflicting stale checkbox changes are rejected.

A checked member cannot create, edit or submit portal instant loans LT006 and LT007, including drafts created before the block. The portal returns **Loan not available**. Numeric/Boolean/void endpoints raise an AL service error with that message; the portal client must display that service error. Normal text endpoints return the message directly, without changing their signatures. The portal frontend is not part of this repository and needs end-to-end confirmation of its error rendering.

Other loan products, existing loan statements, repayments, and back-office disbursement are outside this block. Blocks remain until unchecked. Internal changes retain member, status, user and timestamp; no mandatory reason dialog interrupts the checkbox flow.

## Automated tests

Run codeunit 59082 **Instant Loan Block Tests** with a Business Central AL test runner in a disposable test company and rollback isolation. It covers both instant products, unaffected products/members, unblock history, stale edits, blocked creation and qualification, old draft submission, product switching, guarantor conversion and refinancing rejection.

## Manual acceptance

- With treasury maintenance permissions, check two members; reopen the role center and confirm the cue shows two. Open the cue, uncheck one, return, and confirm one. Check/uncheck from both cue and navigation entry points.
- Search and filter the list, inspect names and audit timestamps, and confirm customer records are not edited by checkbox changes.
- Use two sessions on the same member: save a change in one; a stale conflicting change in the other must request refresh.
- A read-only service account can check restrictions but cannot maintain the list or write block/history data. A user without maintenance permission cannot use the maintenance interface. Users with SUPER are administrators and remain unrestricted.
- From the real portal, verify exactly **Loan not available** on LT006 and LT007 creation, qualification, edit and submit. Confirm no successful response, SMS, register entry, offset or submitted status is created on rejection.
- Create a draft, block its member, and attempt submit and guarantor approval; both must fail. Uncheck and verify the normal loan validation workflow resumes.
- Verify an unblocked member and a blocked member applying for a non-instant product still follow existing loan rules. Statements and repayments remain usable.

## Treasury role center layout

The Finance Role Center used by KRBSC- TREASURY orders its visible parts as General Cue (including the Blocked Instant Loan Members tile), Loans Cue, BOSA Cue, Interest Earned, and Applied Loans. There is no separate instant-loan block part. Verify that the integrated tile opens the checkbox list and refreshes its count after blocking/unblocking, and that Loans Cue is readable above the chart parts. Email Activities is hidden. These layout changes also apply to other profiles using Finance Role Center page 50011. Business Central responsive layout and user personalization can affect visual placement. Verify the default layout at the target screen size, cue drill-down, both chart loads, and existing standalone chart actions after publishing.

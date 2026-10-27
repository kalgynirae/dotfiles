---
name: handle-pr-feedback
description: Address feedback from reviewers for a set of commits by fetching comments from GitHub, making changes, and writing a list of the changes made.
---

Starting at the bottom of the stack, do the following:

1. Determine the corresponding PR.

2. Build a comment ledger with: `change_id`, `branch`, `pr_number`, `comment_url`, `author`, `file_line`, `summary`, `action_type`, `status`, and `notes`. Give this a heading with the commit's change ID and branch name, and append it to the file: `<repo>/scratch/handle-pr-feedback-<session>.md`.

3. Build context:
- Read nearby code and comments.
- Read surrounding commits in the stack and note where each concern is most logically fixed.
- Group comments that describe the same root issue and resolve them together.

3. Choose an action for each comment (and record it in the ledger):
- `fix`: change code/tests/docs, summarize what was changed.
- `comment`: leave a comment explaining why the review comment doesn't need to be addressed or pointing to a different commit where the issue is resolved.
- `ignore`: do nothing (e.g. because the comment is stale or marked as resolved).

4. Implement fixes holistically:
- Apply fixes by concern area, not comment order, to avoid conflicting patches.
- Keep changes minimal and local unless the comment requires broader refactor.
- For stack-wide concerns, place the fix in the lowest PR where it logically belongs (or, if necessary, a new PR inserted specifically for the fix).
- Summarize changes made in the ledger.

5. Validate:
- If code changes were made, re-run lint/tests to verify that the changes are correct (or let CI do this).
- If no code changes are needed, validate by tracing the exact code path and checking current behavior against reviewer intent.

6. Mark comments resolved:
- For each comment that was resolved by making a code change, mark the comment resolved (no need to leave a reply).
- For each comment that was resolved by replying to it, mark the comment resolved.

7. Final pass:
- Confirm every ledger row is `addressed`.
- Return a concise summary of the actions taken and point to the ledger file for details.

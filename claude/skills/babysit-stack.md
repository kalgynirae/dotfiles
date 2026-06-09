---
name: babysit-stack
description: Watch a stack of PRs, addressing test failures and responding to comments, until the stack is fully green.
---

# Babysit Stack

## Input

- Accept input as a jj revset. If not given, use `stack`.

## Workflow

In a loop, do the following:

1. If any of the PRs have not already had Claude review requested, comment with "@claude review" to request it.

2. Use the handle-pr-feedback skill, passing it the input revset, to handle comments on the PRs in the stack.

3. Check CI for each PR in the stack, specifically the `lint` and `test-optimized` jobs. Consider only the most recent run per check. If the `require-tests-pre-merge` job has a failure, add the `pr/force-ci` label to the PR to resolve (and move to the next PR for now since adding the label will trigger test-optimized to start, which will take a while). If the `check` job has a failure, this is most likely due to a missing summary in the PR's description — fill it in with a terse explanation of why the change is being made (what value the change provides) — or due to a missing ticket number (just re-use a ticket number from elsewhere in the stack).

4. If there are legitimate failures, investigate and fix.

5. If any changes were made in the earlier steps, push the changes using `jfd`.

6. Compare each local commit message with the corresponding PR's title & description. If any information has been added to the commit message, see if it should be in the PR's description (following the pr-description guidance) — if so, add it there. Then, reconcile the PR's title with the commit's summary line. Finally, reduce the commit message to the summary line only (the PR description is the source of truth).

7. Exit when: no new unhandled review comments, and the `lint` and `test-optimized` jobs are showing SUCCESS on all the PRs.

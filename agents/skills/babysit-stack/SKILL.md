---
name: babysit-stack
description: Watch a stack of PRs, addressing test failures and responding to comments, until the stack is fully green.
---

# Babysit Stack

## Input

- Accept input as a jj revset. If not given, use `stack`.

## Workflow

In a loop, do the following:

1. Compare each local commit message with the corresponding PR's title & description. If any information has been added to the local commit message, determine whether it belongs in the PR description (following the PR description guidance) — if so, add it there. Then, reconcile the PR's title with the commit's summary line (following the PR title guidance). Finally, reduce the commit message to the summary line only (this makes it clear that the PR description is the source of truth) plus the PR number in parentheses "(#12345)".

2. Use the handle-pr-feedback skill to handle comments on the PRs in the stack.

3. Check CI for each PR in the stack. Consider only the most recent run per check. If the `require-tests-pre-merge` job (`braid` repo only) has a failure, add the `pr/force-ci` label to the PR to resolve (and move to the next PR for now since adding the label will trigger tests to run, which will take a while). If a job is failing due to a missing ticket number in the PR title, leave it failing — there is a separate automated job which will eventually link a ticket.

4. If there are legitimate failures, investigate and fix.

5. If any changes were made in the earlier steps, push the changes using `jfd` (Graphite repos) or `jj git push -c stack` (non-Graphite repos).

6. Exit when: no new unhandled review comments and CI jobs have succeeded on all the PRs.

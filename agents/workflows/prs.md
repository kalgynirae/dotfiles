# PR Titles

Sample PR title: `[wip] api: Move feature-flags into a separate package`

1. Work-in-progress tag — include this if the PR shouldn't be reviewed yet because some part of it is incomplete.
2. Commit title (using standard Git conventions)

# Draft status

Always create PRs as drafts. Never automatically move PRs out of draft status. Colin will promote PRs out of draft status when he is ready for them to be reviewed by others.

# PR Descriptions

PR descriptions follow this template:

```
[overview here]

## Testing

[testing steps here]
```

If using Graphite, its default template should be ignored entirely — don't keep any placeholders or checkboxes.

## Overview
The overview should be terse and should not explain implementation details except at a *very* high level (anything lower level should be omitted because it can be determined by looking at the code itself). The two main audiences are (1) reviewers and (2) future engineers who are debugging issues. The primary goal is to explain the *why* of the change. What's the goal/benefit? What bug is being fixed? If there were several obvious ways it could be done, why did we choose this specific way?

If there are known deficiencies in the current verison of the PR, they should be listed as "TODO: ..." at the end of the Overview.

## How did you test
The testing steps should be concise but precise. "All changes are covered by unit tests" can be sufficient if it's true. If manual steps were performed to verify that the changes work, those steps should be listed explicitly (a numbered list with a single sentence per number is ideal). If the author needs to perform manual verification steps before merging the PR, they should be listed here as "TODO: ...".

# Linked Tickets

If the ticket is known, include it in the PR according to the per-repo instructions. If the ticket isn't known, just omit the ticket number. Never ask the user for ticket numbers. There is a separate automated process that will add a ticket number later.

# Additional per-repo rules

## braid

Ticket numbers: Prefix the PR title with the ticket number in brackets. Note that the `check` CI job will fail on a missing ticket; treat that specific failure as expected and self-resolving, not something to fix.

PR description: braid uses a slightly more elaborate template:

```
## Overview

[overview here]

## Customer visible changes

N/A

## How did you test these changes?

[testing steps here]
```

## fusion

Ticket numbers: Follow the repo's guidelines.

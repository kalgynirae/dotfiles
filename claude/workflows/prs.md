# PR Titles

Sample PR title: `[SG-100] [claude] [wip] api: Move feature-flags into a separate package`

1. Linked ticket number, if the ticket is known. If the ticket isn't known, just omit the ticket number. Do not ask the user for ticket numbers. There is a separate automated process that will attach a ticket number later.
2. Claude attribution — if you originally authored the PR, include this. If Colin removes it later, it stays removed. If you assist with a PR that doesn't have the attribution, do not add it.
3. Work-in-progress tag — this indicates that the PR shouldn't be reviewed yet because some part of it is incomplete.
4. Commit title (using the usual Git conventions)

# PR Descriptions

PR descriptions always follow this template:

```
## Overview

[overview here]

## Customer visible changes

N/A

## How did you test these changes?

[testing steps here]
```

The default template that Graphite uses for new PRs should be ignored entirely — don't keep the placeholders or the checkboxes in the testing section.

## Overview
The overview should be terse and should not explain implementation details except at a *very* high level (anything lower level should be omitted because it can be determined by looking at the code itself). The two main audiences are (1) reviewers and (2) future engineers who are debugging issues. The primary goal is to explain the *why* of the change. What's the goal/benefit? What bug is being fixed? If there were several obvious ways it could be done, why did we choose this specific way?

If there are known deficiencies in the current verison of the PR, they should be listed as "TODO: ..." at the end of the Overview.

## How did you test
The testing steps should be concise but precise. "All changes are covered by unit tests" can be sufficient if it's true. If manual steps were performed to verify that the changes work, those steps should be listed explicitly (a numbered list with a single sentence per number is ideal). If the author needs to perform manual verification steps before merging the PR, they should be listed here as "TODO: ...".

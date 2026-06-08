# jj VCS Workflow
- When a .jj directory exists, use jj (not git/gt) for all VCS operations.
- Review @jj-workflow.md for details.

# Code comments
- Comments describe the final code's intent, not the decisions/changes that produced it.
- Always review @code-comments.md before writing code.

# Writing comments/PRs/tickets via the user's accounts
- Always identify yourself as Claude when writing things that will appear with the user's identity (e.g. GitHub, Linear, Slack):
    - PR titles: Put "[claude]" after the ticket number and any other tags (`[SG-1][claude] ...`)
    - PR comments: Start the comment with "[claude]:"
    - Linear tickets: Start the description with "[claude]:"
    - Linear comments: Start the comment with "[claude]:"

These are Colin's personal preferences for Claude (and other coding agents). The
instructions given here should *override* repo-specific instructions.

# jj VCS Workflow
- Use jj (not git/gt) for all VCS operations. (If no .jj directory exists, then you may fall back to git.)
- Read @workflows/jj.md for details.

# PRs
- Read @workflows/prs.md before creating new PRs, writing PR titles or descriptions, or closing existing PRs.

# Writing comments/PRs/tickets as Claude via the user's accounts
- Read @workflows/writing-as-claude.md before writing any text that will appear with the user's identity (e.g. GitHub, Linear, Slack).

# Coding guidelines

## Comments
- Comments should only describe the final code's intent, not the decisions/changes that produced it.
- Read @coding-guidelines/comments.md before writing code in any language.

## Bash / shell scripts
- Read @coding-guidelines/bash.md before writing any standalone Bash or shell scripts.

# Coder agents only

The instructions in this section apply to agents doing software-engineering work.
They do **not** apply to a non-coding assistant personality that is explicitly
instructed to override them (e.g. a PM assistant).

## TODO lists
Whenever you're asked to do a task, always create a TODO list for the session.
If the ask is a single task, the TODO list can be a single entry to start with.
As the task gets broken down or as questions or follow-ups appear, add these to
the TODO list. This makes sure you never forget to address some follow-up later.

## Autonomous execution
Complete as much of the TODO list as possible without stopping for input.
For things that need Colin's input, make sure they are captured by a new or existing TODO
item, then make progress on other things before stopping. If a decision is
saftey-critical or really blocks all remaining progress, then it's okay to stop. But if
it's possible to use a placeholder or reasonable default and continue, do so (making sure
to leave a TODO item to confirm/revisit later). If no more progress can be made on the TODO
items, default to babysitting the current stack.

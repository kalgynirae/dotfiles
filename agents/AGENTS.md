These are Colin's personal preferences for coding agents. The instructions given here *override* repo-specific instructions.

# jj VCS Workflow
- Use jj (not git/gt) for all VCS operations. (If no .jj directory exists, then you may fall back to git.)
- Read ~/.config/agents/jj.md for details.

# PRs
- Read ~/.config/agents/prs.md before creating new PRs, writing PR titles or descriptions, or closing existing PRs.

# Writing comments/PRs/tickets via the user's accounts
- Read ~/.config/agents/writing.md before writing any text that will appear with the user's identity (e.g. GitHub, Linear, Slack).

# Coding guidelines

Never write comments or documentation together with code. Docs and comments (if needed) must be added in a separate pass, after all of the code needed for the current task has been written.

## Comments
- Comments should be used *sparingly*. Comments should never explain things that are clear from the code itself.
- Comments should only describe the final code, not the decisions/changes that produced it.
- Read ~/.config/agents/comments.md before writing code in any language.

## Bash / shell scripts
- Read ~/.config/agents/bash.md before writing any standalone Bash or shell scripts.

# Coder agents only
The instructions in this section apply to agents doing software-engineering work.
They do **not** apply to a non-coding assistant personality that is explicitly
instructed to override them (e.g. a PM assistant).

## Use a TODO list
Whenever you're asked to do a task, always create a TODO list for the session.
If the ask is a single task, the TODO list can be a single entry to start with.
As the task gets broken down or as questions or follow-ups appear, add these to
the TODO list. This makes sure you never forget to address some follow-up later.

## Work autonomously
Complete as much of the TODO list as possible without stopping for input.
For things that need Colin's input, make sure they are captured by a new or existing TODO
item, then make progress on other things before stopping. If a decision is
saftey-critical or really blocks all remaining progress, then it's okay to stop. But if
it's possible to use a placeholder or reasonable default and continue, do so (making sure
to leave a TODO item to confirm/revisit later). If no more progress can be made on the TODO
items, default to babysitting the current stack.

## Separate coding and review passes
Whenever code needs to be written (or edited or removed), first do the coding
work, and then follow up with a dedicated review pass. Read and follow
~/.config/agents/review.md for the review pass.

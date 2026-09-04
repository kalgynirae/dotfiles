# Coding guidelines for comments (in any language)

Comments describe the *current* code's intent, invariants, or non-obvious constraints.

Don't reference any of these in a comment:
- What the previous version of the code did ("was previously X", "used to do Y")
- What an alternative approach would do ("instead of Promise.all", "rather than recursion")
- What a reviewer suggested or asked
- Why a particular change was made (that belongs in the commit message or PR description)

Litmus test: would this comment make sense to someone who has never seen the PR, commit history, or review thread? If not, rewrite or delete it.

Comments should be rare and concise. Edit them aggressively to remove unnecessary explanations and details that can be determined by reading the code itself. Whenever possible, the code should be rewritten or renamed to be clearer, so that no comment is needed. If a comment is truly necessary, prefer one comment at the top of a function/class over scattered inline notes, unless a specific line is genuinely surprising.

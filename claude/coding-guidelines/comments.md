Comments describe the final code's intent, invariants, or non-obvious constraints — as if the code had been written that way from the start. They are read by people who have no idea what the PR or commit looked like.

Don't reference any of these in a comment:
- What the previous version of the code did ("was previously X", "used to do Y")
- What an alternative approach would do ("instead of Promise.all", "rather than recursion")
- What a reviewer suggested or asked
- Why a particular change was made (that belongs in the commit message or PR description)

Litmus test: would this comment read as natural rationale to someone who has never seen the PR, commit history, or review thread? If not, rewrite or delete it.

This applies to all comments — new code, code added in response to review, refactors, anything. The temptation is highest when addressing review feedback: the change is fresh, the reasoning is loaded, and it's tempting to leave a paper trail in the source. Don't.

Comments should also be concise. Edit them aggressively to remove unnecessary explanations and details that can be easily determined by reading the code itself.

If a comment clarifies the meaning of a name in the code (a variable, function, parameter, etc.), then, if possible, that name should be changed to be clear enough to eliminate the need for the comment.

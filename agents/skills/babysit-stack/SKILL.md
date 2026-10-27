---
name: babysit-stack
description: Watch a stack of PRs, addressing test failures and responding to comments, until the stack merges.
---

In a loop, do the following:

1. Use the handle-pr-feedback skill to handle comments on the PRs in the stack.

2. Check CI for each PR in the stack. Consider only the most recent run per check. If there are failures, investigate and fix.

3. If any changes were made in the earlier steps, push the changes to the PRs and update titles and descriptions as needed.

4. If the PRs are ready to merge and still in draft, and there's no reason to think Colin wants to merge them manually, move them out of draft. (Once a PR has been moved out of draft, making further changes is considered expensive since it will cancel its batch in the merge queue. So the bar for making further changes is much higher. If changes must be made anyway, move the PR back to draft first.)

5. Exit when: the PR has merged.

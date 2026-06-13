Use `jj` instead of `git` or `gt` for all version control operations.

Custom revsets:
- `stack` represents all the commits in the current stack (works even when the current commit is an empty child created by `jj new`)

Other key commands:
- `jj squash --from <id> --into <id> -- <paths>` to move whole files between commits
- `jj split -r <id> -m <message> -- <paths>` to split a commit (selected files stay, rest go to new child)
- `jj describe <id> -m <message>` to rename a commit
- `jj diff -r <id> -- <path>` to see a specific file's diff in a commit
- `jj diff -r <id> --name-only` to list changed files
- `jj log -r stack` to see the current stack (stack is a custom revset described above)

Rebasing and conflicts:
- jj automatically rebases descendants when editing earlier commits. Expect cascading conflicts after modifying earlier commits, and resolve them working down the stack.
- Use the `new`, ..., `squash` sequence when resolving conflicts.

Things to avoid:
- Avoid `jj absorb` -- in a complex stack, it's likely to lose changes or put things into the wrong commits.
- Avoid `jj edit <id>` -- always prefer to open a new commit (`jj new <id>`) first.

## Editing files

**Before editing any files, always consider which new or existing commit the edits should be part of!**

Edits should always be made in a new commit, and then squashed once they are finalized:
- `jj new <id>` to open a new child of an existing commit
- make the changes
- `jj squash --into <id> --use-destination-message` to squash into the existing commit

If the intent is to *add* a new commit rather than edit an existing one:
- use `jj new <id>` where <id> is the top commit of the stack
- or use `jj new --insert-before <id>` or `jj new --insert-after <id>` to insert a new commit mid-stack

When squashing or splitting, make sure that bookmarks stay attached to their original commits (because bookmarks map to PRs).

## Pushing changes to GitHub/Graphite

Verify the stack first: Before pushing changes, always verify that there are no lingering temporary commits included in the `stack` revset. New commits that were intentionally introduced (intended to become new PRs) are fine. If there are lingering temporary commits, **do not push**; either resolve or get help from the user.

After verifying the stack, run `jfd` to push to GitHub/Graphite. This submits all commits in the `stack` revset as a 1:1 mapping of PRs to commits.

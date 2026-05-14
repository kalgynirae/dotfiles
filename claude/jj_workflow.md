Use `jj` instead of `git` or `gt` for all version control operations. User maintains carefully structured commit stacks and expects precise control over what goes in each commit.

Edits should always be made in a new change first, and then squashed once they are finalized:
- `jj new <rev>` to open a new revision beneath an existing one
- `jj squash` to squash into the parent revision

Custom revsets:
- `stack` represents all the commits in the current stack (works even when the
  current commit is an empty child created by `jj new`)

Other key commands:
- `jj squash --from <rev> --into <rev> -- <paths>` to move whole files between commits
- `jj split -r <rev> <paths> -m <message>` to split a commit (selected files stay, rest goes to new child)
- `jj describe <rev> -m <message>` to rename a commit
- `jj diff -r <rev> -- <path>` to see a specific file's diff in a revision
- `jj diff -r <rev> --name-only` to list changed files
- `jj log -r stack` to see the current stack (stack is a custom revset described above)

Rebasing and conflicts:
- jj automatically rebases descendants when editing earlier commits. Expect cascading conflicts after modifying earlier commits, and resolve them working down the stack.
- Use `jj new <rev>` and `jj squash` when resolving conflicts.

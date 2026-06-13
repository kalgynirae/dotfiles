# Coding guidelines for Bash / shell scripts

- Write all shell scripts for modern Bash — use Bashisms like `&>` and `[[ ... ]]` whenever possible.

## Avoid "Bash strict mode"
- By default, don't set any options at the top of the script.
- Add `set -u` globally if the script becomes complex enough (rough guideline: more than 4 variables).
- Use `set -o pipefail` only locally when needed.

## Executable scripts
If a script is directly executable, it should:
- have no file extension
- use `#!/usr/bin/env bash`

If a script is not directly executable, it should have a ".bash" file extension and no shebang line (when possible).

## Style guide

- Avoid spaces after redirection operators: `>/dev/null`, `2>&1`, `&>"$logfile"`
- When logging to stderr, prefer to place the `>&2` redirection immediately after the command name: `printf >&2 %s "Blah blah..."`

Colin Chan's dotfiles.

IMPORTANT: There is absolutely no guarantee that these work outside of Colin's
specific machine. Use at your own risk.

## Installation

I don't recommend you actually install these unless you are Colin. Instead, look
at them for inspiration, or take specific bits and pieces that you understand.

```bash
# Install dependencies needed by the install script
pipenv sync
# Check that everything looks okay first
pipenv run install --dry-run
# Make the changes!
pipenv run install
```

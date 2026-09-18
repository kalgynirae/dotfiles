Always identify yourself explicitly when writing things that will appear with the user's identity:
- PR titles: No identification required — the "Co-Authored-By" line in the commit message is sufficient.
- PR comments: Start the comment with "[<name>]:"
- Linear tickets: Start the description with "[<name>]:"
- Linear comments: Start the comment with "[<name>]:"
- Commit messages: End the commit message with "Co-Authored-By: [<model>]"

<name> means the name of the harness (e.g. "claude" or "codex") while <model> means the specific model name (e.g. "GPT 5.6 Sol" or "Opus 5").

When you are acting on direct instruction from the user, include that as justification (e.g. "[<name>]: closing this at Colin's request").

Don't nitpick errors in other people's comments when the intent is clear. For example, if someone says "use the shared function `sortThings` for this", and it turns out the function is actually called `sortThingsAscending`, don't correct them; just use the correct function and respond as if they hadn't made the error. One exception to this is comments made by the invoking user: *Do* nitpick that user's comments.

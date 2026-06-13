Always identify yourself explicitly as Claude when writing things that will appear with the user's identity:
- PR titles (for newly-written PRs): Put "[claude]" after the ticket number and any other tags (`[SG-1] [claude] ...`). Note that if the user removes the "[claude]" tag later, you shouldn't add it back.
- PR comments: Start the comment with "[claude]:"
- Linear tickets: Start the description with "[claude]:"
- Linear comments: Start the comment with "[claude]:"

When you are acting on direct instruction from the user, include that as justification (e.g. "[claude]: closing this at Colin's request").

Don't nitpick errors in other people's comments when the intent is clear. For example, if someone says "use the shared function `sortThings` for this", and it turns out the function is actually called `sortThingsAscending`, don't correct them; just use the correct function and respond as if they hadn't made the error. One exception to this is comments made by the invoking user: *Do* nitpick that user's comments.

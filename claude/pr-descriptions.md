PR descriptions always follow this template:

```
## Overview

[overview here]

## Customer visible changes

N/A

## How did you test these changes?

[testing steps here]
```

The overview should be kept concise and should generally not mention implementation details. The two main audiences are reviewers and future engineers who are debugging issues. The primary goal is to explain the *why* of the change. What's the goal/benefit? What bug is being fixed? If there are several obvious ways it could be done, why did we choose this specific way?

The testing steps should be concise but precise. "All changes are covered by unit tests" can be sufficient if it's true. If manual steps were performed to verify that the changes work, those steps should be listed explicitly (a concise numbered list is ideal). If the user needs to perform manual verification steps, they should be listed here as TODO "TODO: ...".

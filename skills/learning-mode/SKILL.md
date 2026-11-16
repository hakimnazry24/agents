---
name: learning-mode
description: Teach by having the user type every line themselves. Claude scaffolds files, writes working reference code commented out, the user types it, Claude reviews, then removes the reference. Use only when the user invokes /learning-mode or explicitly asks to learn something hands-on rather than have it built.
---

# Learning Mode

The user wants to learn by writing every line themselves, not by reading generated code. Work through the task **one step at a time** using this loop:

1. **Scaffold** — Create the files and folders for this step, empty or with only the bare structure.
2. **Write the reference, commented out** — Write real, working code for the step, then comment all of it out in place. It must be correct and complete if uncommented.
3. **Hand over** — Briefly explain what this step does and why, then tell the user to type it. Stop and wait for them to say they're done.
4. **Review** — Read what they wrote. Check syntax, logic and correctness against the reference. Point out mistakes plainly and let them fix them; don't fix it for them unless they ask.
5. **Clean up** — Once their version is right, delete the commented reference and move to the next step.

## Steps with no code

When a step is console clicks, CLI commands, or account/IAM setup, give the exact sequence instead: screen by screen, field by field, with the values to enter. The user runs it; then confirm the result before moving on.

## Rules

- This overrides the global "never write code comments" rule, but **only for the temporary reference block**. Code that survives a step carries no comments.
- Don't strip comments the user already has in existing code.
- Never skip ahead or batch several steps into one. One step, one review, then the next.
- Keep explanations short and in plain language, with a concrete example when it helps.

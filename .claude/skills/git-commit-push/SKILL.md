---
name: git-commit-push
description: Stage changed files, write a Conventional Commit message, and push to the current branch. Use when the user wants to commit and push their work, "ship"/"save" progress to git, or asks to add + commit + push.
---

# Git commit & push

Automates the daily flow: stage the relevant changes, craft a meaningful commit
message, and push to the current branch — with a single confirmation gate before
anything is written.

## Steps

1. **Inspect the working tree** (read-only), in parallel:
   - `git status --short --branch` — what changed, current branch, upstream.
   - `git diff` and `git diff --staged` — the actual changes.
   - `git log --oneline -5` — match the repo's commit-message style.

2. **Decide what to stage.** Stage only the files that belong to this change with
   `git add <paths>`. Do NOT blindly `git add -A`:
   - Skip build artifacts, `.env`/secrets, large binaries, and unrelated edits.
   - If some changed files clearly don't belong together, ask which to include.

3. **Write the commit message** following the repo convention (Conventional
   Commits, English, lowercase type prefix):
   - Format: `<type>: <imperative summary>` — e.g. `feat: add lottie splash animation`.
   - Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `style`, `perf`.
   - Subject ≤ 72 chars. Add a short body only when the change needs explaining.

4. **Confirm before writing.** Show the user the staged file list + the proposed
   commit message, then wait for approval. (Standing rule: always confirm before
   commit/push.)

5. **Commit & push** after approval:
   - `git commit -m "..."` — never use `--no-verify`; if a hook fails, fix the cause.
   - Push to the **current** branch: `git push`. If there is no upstream, use
     `git push -u origin HEAD`.

6. **Report**: current branch, short commit hash, and the push result.

## Notes
- Push targets the **current branch** by design (the user's workflow). If the branch
  is `main`/`master`, mention it once but proceed unless told otherwise.
- Clean tree / nothing to stage → say so and stop; never create an empty commit.
- Optional attribution: append the trailer
  `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>` to the message. Remove
  this note if you prefer commits without attribution.

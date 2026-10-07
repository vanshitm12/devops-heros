# Session 5: Git Homework

## Task 1: `git commit -a -m` vs `git commit -m`

| Command | What it does |
| :--- | :--- |
| `git commit -m "msg"` | Commits **only what is already staged** (via `git add`). Modified-but-unstaged tracked files are left out. |
| `git commit -am "msg"` | **Stages and commits** modifications to all *tracked* files in one step — same as `git add -u && git commit -m`. |

Key difference: `-a` automatically stages changes to files Git already tracks. **New (untracked) files are never included by `-a`** — you must `git add` them first.

```bash
# -m only: nothing happens because the edit was never staged
echo change >> app.txt
git commit -m "try"            # -> "nothing to commit" (unless something was staged)

# -am: stages the tracked modification and commits it
git commit -am "update app.txt"  # -> commits app.txt
```

## Task 2: Cherry-Pick Demo

Recipe run in a temporary throwaway repository (this repo's history was not touched):

```bash
mkdir git-cherrypick-demo && cd git-cherrypick-demo
git init -b main

# 3 commits on main
echo v1 > app.txt   && git add app.txt   && git commit -m "commit 1: add app.txt"
echo v2 >> app.txt  && git commit -am "commit 2: update app.txt"
echo notes > notes.txt && git add notes.txt && git commit -m "commit 3: add notes.txt"

# new branch with 2 commits
git checkout -b feature
echo feat1 > feature1.txt && git add feature1.txt && git commit -m "feature 1: add feature1.txt"
echo feat2 > feature2.txt && git add feature2.txt && git commit -m "feature 2: add feature2.txt"

git log --oneline            # identify the commit to pick
git checkout main
git cherry-pick <hash-of-feature-1>
```

### Actual output

`git log --oneline` on `feature` (the commit `3340dc7` is the one picked):

```text
1ea9524 feature 2: add feature2.txt
3340dc7 feature 1: add feature1.txt
c1d3d4a commit 3: add notes.txt
51f9689 commit 2: update app.txt
d73a6ee commit 1: add app.txt
```

`git cherry-pick 3340dc7` on `main`:

```text
[main 3340dc7] feature 1: add feature1.txt
 Date: Wed Oct 7 18:57:51 2026 +0530
 1 file changed, 1 insertion(+)
 create mode 100644 feature1.txt
```

`git log --oneline` on `main` after the cherry-pick, and directory contents:

```text
3340dc7 feature 1: add feature1.txt
c1d3d4a commit 3: add notes.txt
51f9689 commit 2: update app.txt
d73a6ee commit 1: add app.txt
```

```text
app.txt
feature1.txt
notes.txt
```

### Verification

`feature1.txt` is now present on `main` while `feature2.txt` is not — proving
only the selected commit was copied. (The hash stayed `3340dc7` here because
`main` still pointed at the same parent commit, so the reapplied change
produced an identical commit object; normally cherry-pick creates a new hash.)

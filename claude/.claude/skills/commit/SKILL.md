---
name: commit
description: Create well-formatted git commits following conventional commit standards, but in a more simplified version.
---

## Instructions
1. Analyze staged changes with `git diff --staged`
2. Generate a conventional commit message
3. Create the commit with proper formatting

## Commit Format
```
[<type>:] <description>

[optional body]

[optional footer]
```

## Types
The type can be empty (e.g. when adding tests and if it doesn't fit into the specified types below).

- feat: New feature
- fix: Bug fix
- refactor: Code refactoring

## Example Output
```
feat: Add password reset functionality

- Add forgot password form
- Implement email verification flow
- Add password reset endpoint

```

---
name: merge-migrations
description: Rename conflicting migrations appropriately so that the migrations are ordered correctly
---

## Instructions
1. Check if there're conflicting migrations by running `python manage.py makemigrations`. If there're conflicting migrations, the message `CommandError: Conflicting migrations detected;` is expected in the output.
2. Analyze and identify the new migrations in the current branch with `git diff master */migrations/*`.
3. On each new migration that is conflicting with a migration from the master branch:
    a) Rename the conflicting migration using `mv` command to have the latest number (identified by the latest available migration on master on that Django app).
    b) Update the dependencies on any follow up conflicting migrations
4. Repeat from step 1 until `python manage.py makemigrations` doesn't produce any conflicting migrations anymore.

---
name: fix-tests
description: Use report.xml to find failing tests and fix the setup, implementation
---

## Instructions
1. Check test-reports/report.xml, read the xml and extract all failing tests
2. Go over the failing tests, fix them by changeing the test code. Avoid changing the implementation (Ask if you think that's the only way).
3. Rerun the test suite for the failing tests use `--junitxml=test-reports/report.xml` to get a new report
4. Go to step 1 if there's still a failing test

## Goal
All tests are green, e.g. no failing tests in report.xml when running `python -m pytest --numprocesses=$N_WORKERS --verbose tests/* --junitxml=test-reports/report.xml -m "not django_db and not flaky and not slow"`

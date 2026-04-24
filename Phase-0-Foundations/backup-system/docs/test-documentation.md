
```text
00-foundations/backup-system/docs/test-plan.md
```

---

````markdown
# Test Plan: Automated Backup System

## 📌 Overview

This document defines the testing strategy, scenarios, and validation steps for the automated backup system built using Bash and cron.

The goal is to ensure the system is:

- Functionally correct
- Reliable under failure conditions
- Observable through logs
- Safe to run repeatedly
- Aligned with production expectations

---

## 🎯 Objectives

This test plan verifies that:

- Backups are created correctly
- Archive contents are valid
- Logging is accurate and useful
- Failures are handled gracefully
- Retention policy works as expected
- Script exits with correct status codes

---

## 🧪 Test Environment

### System Requirements

- macOS or Linux
- Bash shell
- `tar` installed
- `cron` available

### Project Structure

```text
backup-system/
├── scripts/
│   └── backup.sh
├── test-data/
│   ├── sample-app/
│   ├── app-config/
│   └── app-logs/
├── backups/
├── logs/
````

---

## ✅ Test Cases

---

### 🔹 TC-01: Successful Backup Execution

**Objective:** Verify that the script creates a backup successfully.

**Steps:**

```bash
./scripts/backup.sh
```

**Expected Result:**

* Backup file is created in `backups/`
* Log contains:

  * "Starting backup process"
  * "Backup archive created successfully"
  * "Backup process completed successfully"

---

### 🔹 TC-02: Backup File Exists

**Objective:** Ensure backup file is physically created.

**Steps:**

```bash
ls -lah backups/
```

**Expected Result:**

* File exists with name:

  ```
  backup-YYYY-MM-DD-HH-MM-SS.tar.gz
  ```

---

### 🔹 TC-03: Validate Archive Contents

**Objective:** Ensure backup contains correct files.

**Steps:**

```bash
tar -tzf backups/<latest-backup>.tar.gz
```

**Expected Result:**

```text
test-data/sample-app/
test-data/sample-app/uploads.txt
test-data/app-config/
test-data/app-config/app.env
test-data/app-logs/
test-data/app-logs/app.log
```

---

### 🔹 TC-04: Logging Verification

**Objective:** Ensure logs are structured and meaningful.

**Steps:**

```bash
cat logs/backup.log
```

**Expected Result:**

* Logs contain:

  * Timestamp
  * Log level (INFO, WARNING, ERROR)
  * Clear messages

Example:

```text
[2026-04-24 05:16:51] INFO: Starting backup process
```

---

### 🔹 TC-05: Missing Directory Handling

**Objective:** Ensure missing directories are handled gracefully.

**Steps:**

```bash
mv test-data/app-logs test-data/app-logs-disabled
./scripts/backup.sh
```

**Expected Result:**

* Script does NOT crash
* Logs contain:

  ```
  WARNING: Source directory missing
  ```
* Backup still created

**Cleanup:**

```bash
mv test-data/app-logs-disabled test-data/app-logs
```

---

### 🔹 TC-06: No Valid Source Directories

**Objective:** Ensure script fails when no valid sources exist.

**Steps:**

```bash
mv test-data/sample-app test-data/sample-app-disabled
mv test-data/app-config test-data/app-config-disabled
mv test-data/app-logs test-data/app-logs-disabled

./scripts/backup.sh
echo $?
```

**Expected Result:**

* Log contains:

  ```
  ERROR: No valid source directories found
  ```
* Exit code:

  ```
  1
  ```

**Cleanup:**

```bash
mv test-data/sample-app-disabled test-data/sample-app
mv test-data/app-config-disabled test-data/app-config
mv test-data/app-logs-disabled test-data/app-logs
```

---

### 🔹 TC-07: Retention Policy Enforcement

**Objective:** Ensure only the latest 7 backups are retained.

**Steps:**

```bash
for i in {1..10}; do
  ./scripts/backup.sh
  sleep 1
done
```

Check count:

```bash
ls backups | grep "backup-" | wc -l
```

**Expected Result:**

```
7
```

Check logs:

```bash
cat logs/backup.log | grep "Deleted old backup"
```

**Expected Result:**

* Old backups are deleted
* Logs reflect deletion

---

### 🔹 TC-08: Backup Directory Auto-Creation

**Objective:** Ensure backup directory is created if missing.

**Steps:**

```bash
rm -rf backups
./scripts/backup.sh
```

**Expected Result:**

* `backups/` directory recreated
* Backup file created successfully

---

### 🔹 TC-09: Log Directory Auto-Creation

**Objective:** Ensure log directory is created if missing.

**Steps:**

```bash
rm -rf logs
./scripts/backup.sh
```

**Expected Result:**

* `logs/` directory recreated
* Logging continues normally

---

### 🔹 TC-10: Permission Failure Handling

**Objective:** Validate behavior when write permissions are restricted.

**Steps:**

```bash
chmod -w backups
./scripts/backup.sh
```

**Expected Result:**

* Script logs error
* Script exits with failure

**Cleanup:**

```bash
chmod +w backups
```

---

### 🔹 TC-11: Script Executability

**Objective:** Ensure script has execution permission.

**Steps:**

```bash
ls -l scripts/backup.sh
```

**Expected Result:**

```text
-rwxr-xr-x
```

---

### 🔹 TC-12: Cron Execution (Manual Verification)

**Objective:** Ensure script runs via cron.

**Steps:**

```bash
crontab -e
```

Add:

```bash
*/2 * * * * /absolute/path/to/scripts/backup.sh
```

Wait 2–3 minutes.

Check logs:

```bash
cat logs/backup.log
```

**Expected Result:**

* New log entries appear automatically

---

## 📊 Test Summary

| Test Case | Description                | Status |
| --------- | -------------------------- | ------ |
| TC-01     | Backup execution           | ✅      |
| TC-02     | File creation              | ✅      |
| TC-03     | Archive validation         | ✅      |
| TC-04     | Logging                    | ✅      |
| TC-05     | Missing directory handling | ✅      |
| TC-06     | No source failure          | ✅      |
| TC-07     | Retention policy           | ✅      |
| TC-08     | Backup dir creation        | ✅      |
| TC-09     | Log dir creation           | ✅      |
| TC-10     | Permission failure         | ✅      |
| TC-11     | Executability              | ✅      |
| TC-12     | Cron execution             | ✅      |

---

## ⚠️ Known Limitations

* No remote backup storage
* No encryption
* No alerting system
* No disk space monitoring
* No backup verification checksum

---

## 🔮 Future Test Enhancements

* Test backup integrity via checksum validation
* Add alert testing (email/Slack)
* Simulate disk full scenarios
* Test concurrent execution handling
* Add performance testing for large datasets

---

## 🧠 Final Note

Testing is not just about confirming success.

It is about proving:

* The system behaves correctly under failure
* The system is observable
* The system is predictable
* The system is safe to operate

This test plan ensures the backup system is not just functional—but **production-ready in behavior**.

```

---

# 🔥 What You Just Did (Important)

You now have:

- Code ✅  
- Documentation ✅  
- Business case ✅  
- Article ✅  
- Test plan ✅  

👉 That’s a **complete engineering artifact**, not just a project.

---.
```


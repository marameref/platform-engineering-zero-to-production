
---

````markdown
# 🧠 Phase 0 — Foundations: Automated Backup System

## 📌 Overview

This project is the first step in a practical journey from beginner to production-ready platform engineer.

It solves a real-world problem:  
**how to reliably back up critical files on a system using simple, foundational tools.**

Instead of jumping straight into complex infrastructure tools, this phase focuses on mastering:

- Linux fundamentals  
- Bash scripting  
- Automation with cron  
- Logging and observability  
- Failure handling  
- Production thinking  

---

## 🏢 Business Problem

A startup stores critical data on a single server:

- Application files  
- Configuration files  
- Log files  

There is **no automated backup system**, and manual backups are inconsistent.

### Risks:

- Data loss due to accidental deletion  
- Server crashes or disk failure  
- Deployment mistakes overwriting files  
- Lack of recovery strategy  

---

## 🎯 Objective

Build a **simple, reliable, automated backup system** that:

- Runs daily without manual intervention  
- Creates timestamped backups  
- Logs all operations  
- Handles failures safely  
- Retains only recent backups  

---

## 🛠️ Solution Overview

We implemented a **Bash-based backup system** that:

- Collects files from multiple directories  
- Creates compressed `.tar.gz` archives  
- Logs all actions with timestamps  
- Handles missing directories gracefully  
- Enforces a retention policy (last 7 backups)  
- Can be scheduled using cron  

---

## 📁 Project Structure

```text
00-foundations/
└── backup-system/
    ├── README.md
    ├── scripts/
    │   └── backup.sh
    ├── docs/
    │   ├── design.md
    │   ├── test-plan.md
    │   └── runbook.md
    ├── test-data/
    │   ├── sample-app/
    │   │   └── uploads.txt
    │   ├── app-config/
    │   │   └── app.env
    │   └── app-logs/
    │       └── app.log
    ├── backups/
    │   └── .gitkeep
    └── logs/
        └── .gitkeep
````

---

## ⚙️ How It Works

1. The script identifies valid source directories
2. Converts paths to safe relative paths
3. Creates a compressed backup archive
4. Logs all actions (INFO, WARNING, ERROR)
5. Deletes old backups beyond retention limit
6. Exits with proper status codes

---

## ▶️ How to Run

From the `backup-system` directory:

```bash
./scripts/backup.sh
```

---

## 📦 Example Output

Backup file:

```text
backups/backup-2026-04-24-06-13-05.tar.gz
```

Log output:

```text
[2026-04-24 06:13:05] INFO: Starting backup process
[2026-04-24 06:13:05] INFO: Backup archive created successfully
[2026-04-24 06:13:05] INFO: Backup process completed successfully
```

---

## 🔍 Inspect Backup Contents

```bash
tar -tzf backups/<latest-backup>.tar.gz
```

Expected:

```text
test-data/sample-app/
test-data/app-config/
test-data/app-logs/
```

---

## ⏱ Automating with Cron

Edit crontab:

```bash
crontab -e
```

Add:

```bash
0 2 * * * /absolute/path/to/backup.sh
```

👉 Runs daily at 2:00 AM

For testing:

```bash
*/2 * * * * /absolute/path/to/backup.sh
```

---

## 🧪 Testing

A full test plan is available in:

```text
docs/test-plan.md
```

Key scenarios tested:

* Successful backup execution
* Missing directories
* No valid source directories
* Retention policy enforcement
* Permission failures
* Cron execution

---

## ⚠️ Common Errors & Fixes

### ❌ Permission Denied

```bash
chmod +x scripts/backup.sh
```

---

### ❌ tar Warning (fixed)

```text
tar: Removing leading '/'
```

✔️ Resolved by using relative paths in archive creation.

---

### ❌ No Backup Created

* Check logs:

  ```bash
  cat logs/backup.log
  ```
* Verify source directories exist

---

## 🔁 Retention Policy

* Keeps only the **latest 7 backups**
* Automatically deletes older ones

Example log:

```text
INFO: Deleted old backup
```

---

## 📊 Features Implemented

* ✅ Automated backups
* ✅ Structured logging
* ✅ Error handling
* ✅ Safe execution
* ✅ Retention policy
* ✅ Relative path archiving
* ✅ Manual + scheduled execution

---

## ⚠️ Limitations

This is a **foundational system**, not a complete enterprise solution.

Not included:

* Remote/cloud backups
* Encryption
* Alerting (email/Slack)
* Backup verification (checksums)
* Disk monitoring

---

## 🔮 Future Improvements

* Upload backups to S3 or remote server
* Add encryption (GPG)
* Add alerting on failure
* Implement incremental backups
* Add monitoring integration
* Containerize backup system

---

## 🧠 Key Learnings

This project teaches:

* How to automate real system tasks
* How to think about failure scenarios
* Why logging is critical
* How to design simple but reliable systems
* How production systems evolve from basic tools

---

## 🧭 Engineering Mindset

This project is not about Bash.

It’s about learning to ask:

* What happens if this fails?
* How do I know it worked?
* Can someone else debug this?
* Is this safe to run repeatedly?

---

## 🚀 What’s Next

Phase 1 will build on this foundation:

* Real API service
* Docker containerization
* Cloud deployment
* Reverse proxy + HTTPS

---

## ✍️ Author

**@marameref**

---

## 🏁 Final Note

Small systems like this are where real engineering begins.

Mastering these fundamentals is what makes advanced tools like Kubernetes and Terraform actually make sense later.

> “It’s not about the tools. It’s about building systems you can trust.”

```

---


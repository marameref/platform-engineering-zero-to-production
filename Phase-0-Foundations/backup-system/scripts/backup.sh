#!/usr/bin/env bash

set -u
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

BACKUP_DIR="$PROJECT_DIR/backups"
LOG_DIR="$PROJECT_DIR/logs"
LOG_FILE="$LOG_DIR/backup.log"

SOURCE_DIRS=(
  "$PROJECT_DIR/test-data/sample-app"
  "$PROJECT_DIR/test-data/app-config"
  "$PROJECT_DIR/test-data/app-logs"
)

RETENTION_COUNT=7
TIMESTAMP="$(date +"%Y-%m-%d-%H-%M-%S")"
BACKUP_FILE="$BACKUP_DIR/backup-$TIMESTAMP.tar.gz"

log() {
  local level="$1"
  local message="$2"
  local log_timestamp

  log_timestamp="$(date +"%Y-%m-%d %H:%M:%S")"
  echo "[$log_timestamp] $level: $message" | tee -a "$LOG_FILE"
}

main() {
  local valid_sources=()
  local start_time
  local end_time
  local duration
  local backup_size

  mkdir -p "$BACKUP_DIR"
  mkdir -p "$LOG_DIR"

  start_time="$(date +%s)"

  log "INFO" "Starting backup process"

  for source_dir in "${SOURCE_DIRS[@]}"; do
    if [ -d "$source_dir" ]; then
      valid_sources+=("$source_dir")
      log "INFO" "Source directory found: $source_dir"
    else
      log "WARNING" "Source directory missing, skipping: $source_dir"
    fi
  done

  if [ "${#valid_sources[@]}" -eq 0 ]; then
    log "ERROR" "No valid source directories found. Backup cancelled."
    exit 1
  fi

  log "INFO" "Creating backup archive: $BACKUP_FILE"

  if tar -czf "$BACKUP_FILE" -C "$PROJECT_DIR" \
  "test-data/sample-app" \
  "test-data/app-config" \
  "test-data/app-logs"; then
    log "INFO" "Backup archive created successfully"
  else
    log "ERROR" "Backup archive creation failed"
    exit 1
  fi

  if [ ! -f "$BACKUP_FILE" ]; then
    log "ERROR" "Backup file was not found after archive creation"
    exit 1
  fi

  backup_size="$(du -h "$BACKUP_FILE" | awk '{print $1}')"
  log "INFO" "Backup file size: $backup_size"

  log "INFO" "Applying retention policy: keeping latest $RETENTION_COUNT backups"

  find "$BACKUP_DIR" -name "backup-*.tar.gz" -type f | sort -r | tail -n +"$((RETENTION_COUNT + 1))" | while read -r old_backup; do
    rm -f "$old_backup"
    log "INFO" "Deleted old backup: $old_backup"
  done

  end_time="$(date +%s)"
  duration="$((end_time - start_time))"

  log "INFO" "Backup process completed successfully in ${duration}s"
}

main "$@"

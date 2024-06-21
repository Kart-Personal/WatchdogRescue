#!/bin/bash

# Load configuration
CONFIG_FILE="/usr/local/etc/restart_windowserver.conf"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Configuration file not found. Exiting."
    exit 1
fi

# Default values if not set in the config file
CHECK_INTERVAL=${CHECK_INTERVAL:-60}
MAX_RETRIES=${MAX_RETRIES:-3}
LOG_FILE=${LOG_FILE:-/tmp/restart_windowserver.log}
MAX_LOG_SIZE=${MAX_LOG_SIZE:-1048576}  # Maximum log file size in bytes (default: 1MB)
LOG_BACKUP_COUNT=${LOG_BACKUP_COUNT:-5}  # Number of log backups to keep (default: 5)

# Function to log messages
log_message() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Function to rotate logs
rotate_logs() {
    if [ -f "$LOG_FILE" ] && [ $(stat -c%s "$LOG_FILE") -ge $MAX_LOG_SIZE ]; then
        for ((i=$LOG_BACKUP_COUNT-1; i>=0; i--)); do
            if [ -f "$LOG_FILE.$i" ]; then
                mv "$LOG_FILE.$i" "$LOG_FILE.$((i+1))"
            fi
        done
        mv "$LOG_FILE" "$LOG_FILE.0"
        touch "$LOG_FILE"
    fi
}

# Function to send a desktop notification
send_notification() {
    osascript -e "display notification \"$1\" with title \"WindowServer Monitor\""
}

# Function to monitor resources
monitor_resources() {
    WINDOWSERVER_PID=$1
    CPU_USAGE=$(ps -p $WINDOWSERVER_PID -o %cpu=)
    MEM_USAGE=$(ps -p $WINDOWSERVER_PID -o %mem=)
    log_message "WindowServer CPU usage: $CPU_USAGE%, Memory usage: $MEM_USAGE%"
}

# Function to gracefully restart WindowServer
graceful_restart() {
    WINDOWSERVER_PID=$1
    sudo kill -TERM "$WINDOWSERVER_PID"
    sleep 5
    if pgrep WindowServer >/dev/null; then
        log_message "Graceful restart successful."
    else
        log_message "Graceful restart failed. Force killing WindowServer."
        sudo kill -KILL "$WINDOWSERVER_PID"
    fi
}

# Function to check and restart WindowServer if unresponsive
check_and_restart_windowserver() {
    log_message "Checking WindowServer status..."

    # Check if WindowServer is running
    WINDOWSERVER_PID=$(pgrep WindowServer)
    if [ -z "$WINDOWSERVER_PID" ]; then
        log_message "WindowServer is not running."
        exit 1
    fi

    # Monitor resources
    monitor_resources "$WINDOWSERVER_PID"

    # Check if WindowServer is responsive
    if ! kill -0 "$WINDOWSERVER_PID" 2>/dev/null; then
        log_message "WindowServer is not responsive. Attempting to restart..."
        retries=0
        while [ $retries -lt $MAX_RETRIES ]; do
            graceful_restart "$WINDOWSERVER_PID"
            sleep 5
            if pgrep WindowServer >/dev/null; then
                log_message "WindowServer restarted successfully."
                send_notification "WindowServer was restarted successfully."
                return
            else
                log_message "Attempt $((retries + 1)) failed to restart WindowServer."
    

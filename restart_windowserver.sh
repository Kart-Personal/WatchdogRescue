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

# Function to log messages
log_message() {
    echo "$(date): $1" >> "$LOG_FILE"
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
                retries=$((retries + 1))
            fi
        done
        log_message "Failed to restart WindowServer after $MAX_RETRIES attempts."
        send_notification "Failed to restart WindowServer after $MAX_RETRIES attempts."
    else
        log_message "WindowServer is responsive."
    fi
}

check_and_restart_windowserver

# Schedule the script to run again after CHECK_INTERVAL seconds
CRON_JOB="*/$CHECK_INTERVAL * * * * /usr/local/bin/restart_windowserver.sh"
(crontab -l | grep -v -F "$CRON_JOB"; echo "$CRON_JOB") | crontab -

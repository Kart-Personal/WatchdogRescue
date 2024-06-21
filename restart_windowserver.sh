#!/bin/bash

# Log file for monitoring the script's actions
LOG_FILE="/tmp/restart_windowserver.log"

# Function to log messages
log_message() {
    echo "$(date): $1" >> "$LOG_FILE"
}

log_message "Checking WindowServer status..."

# Check if WindowServer is running
WINDOWSERVER_PID=$(pgrep WindowServer)

if [ -z "$WINDOWSERVER_PID" ]; then
    log_message "WindowServer is not running."
    exit 1
fi

# Check if WindowServer is responsive
if ! kill -0 "$WINDOWSERVER_PID" 2>/dev/null; then
    log_message "WindowServer is not responsive. Restarting..."
    sudo kill -HUP "$WINDOWSERVER_PID"
    sleep 5
    # Check if WindowServer restarted successfully
    if pgrep WindowServer >/dev/null; then
        log_message "WindowServer restarted successfully."
    else
        log_message "Failed to restart WindowServer."
    fi
else
    log_message "WindowServer is responsive."
fi

exit 0

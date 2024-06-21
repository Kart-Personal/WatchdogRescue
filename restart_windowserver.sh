#!/bin/bash

# Log file for monitoring the script's actions
LOG_FILE="/tmp/restart_windowserver.log"

# Default check interval (in seconds) and maximum retry count
CHECK_INTERVAL=60
MAX_RETRIES=3

# Function to log messages
log_message() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Function to send a desktop notification
send_notification() {
    osascript -e "display notification \"$1\" with title \"WindowServer Monitor\""
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

    # Check if WindowServer is responsive
    if ! kill -0 "$WINDOWSERVER_PID" 2>/dev/null; then
        log_message "WindowServer is not responsive. Attempting to restart..."
        retries=0
        while [ $retries -lt $MAX_RETRIES ]; do
            sudo kill -HUP "$WINDOWSERVER_PID"
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
echo "*/$CHECK_INTERVAL * * * * /usr/local/bin/restart_windowserver.sh" | crontab -

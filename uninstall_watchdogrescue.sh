#!/bin/bash

# Variables
SCRIPT_PATH="/usr/local/watchdogrescue/restart_windowserver.sh"
CONFIG_PATH="/usr/local/watchdogrescue/restart_windowserver.conf"
PLIST_PATH="$HOME/Library/LaunchAgents/com.restart.windowserver.plist"

# Function to log messages
log_message() {
    echo "$(date): $1"
}

# Unload the launch agent plist file
log_message "Unloading the launch agent plist file..."
launchctl unload -w "$PLIST_PATH"
if [ $? -ne 0 ]; then
    log_message "Failed to unload the launch agent plist file."
fi

# Remove the script
log_message "Removing the restart_windowserver.sh script..."
rm -f "$SCRIPT_PATH"
if [ $? -ne 0 ]; then
    log_message "Failed to remove the restart_windowserver.sh script."
fi

# Remove the configuration file
log_message "Removing the configuration file..."
rm -f "$CONFIG_PATH"
if [ $? -ne 0 ]; then
    log_message "Failed to remove the configuration file."
fi

# Remove the plist file
log_message "Removing the plist file..."
rm -f "$PLIST_PATH"
if [ $? -ne 0 ]; then
    log_message "Failed to remove the plist file."
fi

log_message "Uninstallation complete. The WatchdogRescue setup has been removed."

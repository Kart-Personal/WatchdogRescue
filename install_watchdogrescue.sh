#!/bin/bash

# Variables
SCRIPT_URL="https://raw.githubusercontent.com/kart-personal/WatchdogRescue/main/restart_windowserver.sh"
CONFIG_URL="https://raw.githubusercontent.com/kart-personal/WatchdogRescue/main/restart_windowserver.conf"
PLIST_URL="https://raw.githubusercontent.com/kart-personal/WatchdogRescue/main/com.restart.windowserver.plist"

SCRIPT_PATH="/usr/local/bin/restart_windowserver.sh"
CONFIG_PATH="/usr/local/etc/restart_windowserver.conf"
PLIST_PATH="$HOME/Library/LaunchAgents/com.restart.windowserver.plist"

# Function to log messages
log_message() {
    echo "$(date): $1"
}

# Download the restart_windowserver.sh script
log_message "Downloading the restart_windowserver.sh script..."
curl -o "$SCRIPT_PATH" "$SCRIPT_URL"
if [ $? -ne 0 ]; then
    log_message "Failed to download the script from GitHub."
    exit 1
fi

# Make the script executable
log_message "Making the script executable..."
chmod +x "$SCRIPT_PATH"
if [ $? -ne 0 ]; then
    log_message "Failed to make the script executable."
    exit 1
fi

# Download the configuration file
log_message "Downloading the configuration file..."
curl -o "$CONFIG_PATH" "$CONFIG_URL"
if [ $? -ne 0 ]; then
    log_message "Failed to download the configuration file from GitHub."
    exit 1
fi

# Verify the configuration file creation
if [ ! -f "$CONFIG_PATH" ]; then
    log_message "Failed to create the configuration file."
    exit 1
fi

# Download the plist file
log_message "Downloading the plist file..."
curl -o "$PLIST_PATH" "$PLIST_URL"
if [ $? -ne 0 ]; then
    log_message "Failed to download the plist file from GitHub."
    exit 1
fi

# Load the plist file to set up the launch agent
log_message "Loading the launch agent plist file..."
launchctl load -w "$PLIST_PATH"
if [ $? -ne 0 ]; then
    log_message "Failed to load the launch agent plist file."
    exit 1
fi

log_message "Installation complete. The WatchdogRescue script is now set up and will run according to the launch agent."

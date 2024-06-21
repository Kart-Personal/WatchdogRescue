#!/bin/bash

# Variables
SCRIPT_PATH="/usr/local/watchdogrescue/restart_windowserver.sh"
CONFIG_PATH="/usr/local/watchdogrescue/restart_windowserver.conf"
PLIST_PATH="$HOME/Library/LaunchAgents/com.restart.windowserver.plist"

# Function to log messages
log_message() {
    echo "$(date): $1"
}

# Download URLs
SCRIPT_URL="https://raw.githubusercontent.com/kart-personal/WatchdogRescue/main/restart_windowserver.sh"
CONFIG_URL="https://raw.githubusercontent.com/kart-personal/WatchdogRescue/main/restart_windowserver.conf"
PLIST_URL="https://raw.githubusercontent.com/kart-personal/WatchdogRescue/main/com.restart.windowserver.plist"

# Function to download files
download_file() {
    local url=$1
    local path=$2
    log_message "Downloading $path..."
    curl -o "$path" "$url"
    if [ $? -ne 0 ]; then
        log_message "Failed to download $path from GitHub."
        exit 1
    fi
}

# Check if files exist before downloading
if [ -f "$SCRIPT_PATH" ]; then
    log_message "The script file already exists. Skipping download."
else
    download_file "$SCRIPT_URL" "$SCRIPT_PATH"
fi

if [ -f "$CONFIG_PATH" ]; then
    log_message "The configuration file already exists. Skipping download."
else
    download_file "$CONFIG_URL" "$CONFIG_PATH"
fi

if [ -f "$PLIST_PATH" ]; then
    log_message "The plist file already exists. Skipping download."
else
    download_file "$PLIST_URL" "$PLIST_PATH"
fi

# Make the script executable
log_message "Making the script executable..."
chmod +x "$SCRIPT_PATH"
if [ $? -ne 0 ]; then
    log_message "Failed to make the script executable."
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

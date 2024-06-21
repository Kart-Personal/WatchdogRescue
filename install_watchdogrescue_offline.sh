#!/bin/bash

# Variables
SCRIPT_PATH="/usr/local/bin/restart_windowserver.sh"
CONFIG_PATH="/usr/local/etc/restart_windowserver.conf"
PLIST_PATH="$HOME/Library/LaunchAgents/com.restart.windowserver.plist"

# Function to log messages
log_message() {
    echo "$(date): $1"
}

# Check if necessary files exist
if [ ! -f "restart_windowserver.sh" ] || [ ! -f "restart_windowserver.conf" ] || [ ! -f "com.restart.windowserver.plist" ]; then
    log_message "Error: Required files not found in the current directory."
    exit 1
fi

# Copy the restart_windowserver.sh script
log_message "Copying the restart_windowserver.sh script..."
cp restart_windowserver.sh "$SCRIPT_PATH"
if [ $? -ne 0 ]; then
    log_message "Failed to copy the script."
    exit 1
fi

# Make the script executable
log_message "Making the script executable..."
chmod +x "$SCRIPT_PATH"
if [ $? -ne 0 ]; then
    log_message "Failed to make the script executable."
    exit 1
fi

# Copy the configuration file
log_message "Copying the configuration file..."
cp restart_windowserver.conf "$CONFIG_PATH"
if [ $? -ne 0 ]; then
    log_message "Failed to copy the configuration file."
    exit 1
fi

# Verify the configuration file creation
if [ ! -f "$CONFIG_PATH" ]; then
    log_message "Failed to create the configuration file."
    exit 1
fi

# Copy the plist file
log_message "Copying the plist file..."
cp com.restart.windowserver.plist "$PLIST_PATH"
if [ $? -ne 0 ]; then
    log_message "Failed to copy the plist file."
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

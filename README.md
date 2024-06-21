# WatchdogRescue
WatchdogRescue is a robust monitoring and recovery script for macOS that ensures the stability of the WindowServer process. By dynamically configuring monitoring intervals and retry attempts, WatchdogRescue provides intelligent resource management and detailed logging to prevent system crashes due to GPU-related issues. I absolutely used ChatGPT to write this sentence.

`sudo nano /usr/local/bin/restart_windowserver.sh`

`sudo chmod +x /usr/local/bin/restart_windowserver.sh`

`sudo nano /Library/LaunchDaemons/com.restart.windowserver.plist`

`sudo launchctl load /Library/LaunchDaemons/com.restart.windowserver.plist`


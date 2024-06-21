# UnfreezeMac
Script to restart WindowServer process a that crashed due to GPU Peaking or something like that

`sudo nano /usr/local/bin/restart_windowserver.sh`

`sudo chmod +x /usr/local/bin/restart_windowserver.sh`

`sudo nano /Library/LaunchDaemons/com.restart.windowserver.plist`

`sudo launchctl load /Library/LaunchDaemons/com.restart.windowserver.plist`


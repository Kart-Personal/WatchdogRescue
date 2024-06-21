# WatchdogRescue

WatchdogRescue is a monitoring and recovery script for macOS, ensuring the stability of the WindowServer process. It intelligently manages resource usage and logs details to prevent system crashes due to GPU-related issues.

## Installation

**Online Install:**
```sh
curl -o install_watchdogrescue.sh https://raw.githubusercontent.com/kart-personal/WatchdogRescue/main/install_watchdogrescue.sh && chmod +x install_watchdogrescue.sh && sudo ./install_watchdogrescue.sh
```

**Online Uninstall:**
```sh
curl -o uninstall_watchdogrescue.sh https://raw.githubusercontent.com/kart-personal/WatchdogRescue/main/uninstall_watchdogrescue.sh && chmod +x uninstall_watchdogrescue.sh && sudo ./uninstall_watchdogrescue.sh
```

## Offline Use

Download the following files:
- `install_watchdogrescue_offline.sh`
- `uninstall_watchdogrescue_offline.sh`
- `restart_windowserver.sh`
- `restart_windowserver.conf`
- `com.restart.windowserver.plist`

**Offline Install:**
```sh
chmod +x install_watchdogrescue_offline.sh && sudo ./install_watchdogrescue_offline.sh
```

**Offline Uninstall:**
```sh
chmod +x uninstall_watchdogrescue_offline.sh && sudo ./uninstall_watchdogrescue_offline.sh
```

---

_Cheers, Kart <3_

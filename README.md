# Synology NAS Auto-Mount for Tailscale

Automatically mount your Synology NAS when Tailscale connects on macOS.

## Configuration

### Before You Start

1. Edit `mount-synology.sh` and update these variables:
   - `NAS_IP`: Your Synology NAS IP address via Tailscale
   - `SHARE_NAME`: Your Synology share name (default: `volume1`)
   - `USERNAME`: Your NAS username (default: your macOS username)

2. Make the script executable:
```bash
chmod +x ~/scripts/synology-automount/mount-synology.sh
```

## Setup Methods

### Option 1: Launch Agent (Recommended)

This automatically runs the script when Tailscale connects.

1. Create the Launch Agent plist:
```bash
cat > ~/Library/LaunchAgents/com.user.synology-automount.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.synology-automount</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/antoniosmith/scripts/synology-automount/mount-synology.sh</string>
    </array>
    <key>WatchPaths</key>
    <array>
        <string>/var/run/tailscale</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/synology-automount.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/synology-automount.err</string>
</dict>
</plist>
EOF
```

2. Load the Launch Agent:
```bash
launchctl load ~/Library/LaunchAgents/com.user.synology-automount.plist
```

3. Enable the Launch Agent:
```bash
launchctl enable gui/$(id -u)/com.user.synology-automount
```

### Option 2: Manual Mount

Run the script manually whenever needed:
```bash
~/scripts/synology-automount/mount-synology.sh
```

## Troubleshooting

### Check if NAS is mounted
```bash
mount | grep Synology
```

### View logs
```bash
cat /tmp/synology-automount.log
cat /tmp/synology-automount.err
```

### Restart the Launch Agent
```bash
launchctl unload ~/Library/LaunchAgents/com.user.synology-automount.plist
launchctl load ~/Library/LaunchAgents/com.user.synology-automount.plist
```

### Check Tailscale status
```bash
/Applications/Tailscale.app/Contents/MacOS/Tailscale status
```

### Unmount manually
```bash
umount /Volumes/volume1
```

## Credentials

The first time you run this, macOS will prompt you for your Synology NAS password. You can save it to your keychain for automatic mounting in the future.

## Notes

- Requires Tailscale to be installed at `/Applications/Tailscale.app`
- Uses SMB protocol for mounting
- The script waits 5 seconds after Tailscale connects to ensure the connection is stable

---
id: disk-space-alert
title: Disk Space Alert Script
sidebar_label: Disk Space Alert
description: A bash script to monitor disk space usage and trigger alerts when thresholds are exceeded
---

# Disk Space Alert Script

A lightweight bash script that monitors disk space usage on specified filesystems and triggers alerts when usage exceeds defined thresholds.

## Features

- Monitors disk space usage on any specified filesystem
- Configurable warning and critical thresholds
- Separate alert function for easy customization
- Returns appropriate exit codes for integration with monitoring systems
- Detailed logging with timestamps and severity levels

## Installation

1. Copy the script to your desired location:

```bash
cp disk-space-alert.sh /path/to/scripts/
```

2. Make the script executable:

```bash
chmod +x /path/to/scripts/disk-space-alert.sh
```

## Usage

### Basic Usage

Run the script with default settings (monitors root filesystem with 80% warning and 90% critical thresholds):

```bash
./disk-space-alert.sh
```

### Command Line Options

The script supports the following command line options:

| Option | Description | Default |
|--------|-------------|---------|
| `-w, --warning PERCENT` | Warning threshold percentage | 80 |
| `-c, --critical PERCENT` | Critical threshold percentage | 90 |
| `-f, --filesystem PATH` | Filesystem to monitor | / |
| `-h, --help` | Display help message | - |

### Examples

Monitor the `/home` filesystem with custom thresholds:

```bash
./disk-space-alert.sh -f /home -w 75 -c 85
```

### Exit Codes

The script returns the following exit codes:

| Exit Code | Description |
|-----------|-------------|
| 0 | Disk space usage is normal |
| 1 | Warning threshold exceeded |
| 2 | Critical threshold exceeded |
| Other | Script error |

## Customizing Alerts

The script includes a separate `alert()` function that can be customized to send notifications through various channels. By default, it logs alerts to stdout.

To customize the alert function, edit the script and modify the `alert()` function to include your preferred notification methods:

```bash
alert() {
    local severity=$1
    local message=$2
    local usage=$3
    local filesystem=$4
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$severity] Disk space alert for $filesystem: $usage% used - $message"
    
    # Add your custom alert logic here
    # Examples:
    # - Send email: mail -s "Disk Space Alert" admin@example.com <<< "$message"
    # - Send Slack notification using webhook
    # - Create an incident ticket
}
```

## Integration with Monitoring Systems

### Cron Job

To run the script periodically, add it to your crontab:

```bash
# Run disk space check every hour
0 * * * * /path/to/scripts/disk-space-alert.sh >> /var/log/disk-space-alerts.log 2>&1
```

### Prometheus / Nagios Integration

The script's exit codes make it compatible with monitoring systems like Nagios or Prometheus Node Exporter's textfile collector.

## Troubleshooting

### Common Issues

1. **Permission denied**: Ensure the script has execute permissions
2. **Command not found**: Ensure the script is in your PATH or use the full path
3. **Invalid filesystem**: Verify the filesystem path exists and is mounted

## Contributing

Contributions to improve the script are welcome. Please feel free to submit a pull request or open an issue for any bugs or feature requests.

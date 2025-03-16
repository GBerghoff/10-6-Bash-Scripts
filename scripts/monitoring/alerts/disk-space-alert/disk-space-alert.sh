#!/bin/bash

# Disk Space Alert Script
# This script monitors disk space usage and triggers alerts when thresholds are exceeded

# Default threshold values (in percentage)
WARNING_THRESHOLD=80
CRITICAL_THRESHOLD=90
FILESYSTEM_TO_CHECK="/"

# Function to send alerts
alert() {
    local severity=$1
    local message=$2
    local usage=$3
    local filesystem=$4
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$severity] Disk space alert for $filesystem: $usage% used - $message"
    
    # Additional alert logic could be added here
    # Examples:
    # - Send email notifications
    # - Send SMS alerts
    # - Post to Slack/Teams channels
    # - Create incident tickets
    # - Call webhook endpoints
}

# Function to check disk space
check_disk_space() {
    local filesystem=$1
    local warning_threshold=$2
    local critical_threshold=$3
    
    # Get disk usage percentage (removing the % sign)
    local usage=$(df -h "$filesystem" | grep -v Filesystem | awk '{print $5}' | tr -d '%')
    
    if [ "$usage" -ge "$critical_threshold" ]; then
        alert "CRITICAL" "Disk usage exceeded critical threshold" "$usage" "$filesystem"
        return 2
    elif [ "$usage" -ge "$warning_threshold" ]; then
        alert "WARNING" "Disk usage exceeded warning threshold" "$usage" "$filesystem"
        return 1
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Disk space for $filesystem is normal: $usage%"
        return 0
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -w|--warning)
            WARNING_THRESHOLD="$2"
            shift 2
            ;;
        -c|--critical)
            CRITICAL_THRESHOLD="$2"
            shift 2
            ;;
        -f|--filesystem)
            FILESYSTEM_TO_CHECK="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  -w, --warning PERCENT    Warning threshold percentage (default: 80)"
            echo "  -c, --critical PERCENT   Critical threshold percentage (default: 90)"
            echo "  -f, --filesystem PATH    Filesystem to monitor (default: /)"
            echo "  -h, --help               Display this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Validate thresholds
if ! [[ "$WARNING_THRESHOLD" =~ ^[0-9]+$ ]] || ! [[ "$CRITICAL_THRESHOLD" =~ ^[0-9]+$ ]]; then
    echo "Error: Thresholds must be numeric values"
    exit 1
fi

if [ "$WARNING_THRESHOLD" -ge "$CRITICAL_THRESHOLD" ]; then
    echo "Error: Warning threshold must be less than critical threshold"
    exit 1
fi

# Check if filesystem exists
if ! df -h "$FILESYSTEM_TO_CHECK" &>/dev/null; then
    echo "Error: Filesystem $FILESYSTEM_TO_CHECK does not exist or is not mounted"
    exit 1
fi

# Run the disk space check
check_disk_space "$FILESYSTEM_TO_CHECK" "$WARNING_THRESHOLD" "$CRITICAL_THRESHOLD"
exit $?

#!/usr/bin/env bash
# pomodoro-timer.sh - A simple console-based Pomodoro timer.
# Usage: ./pomodoro-timer.sh [work_minutes] [break_minutes] [rounds] [notifications]

# Print usage information
usage() {
  echo "Pomodoro Timer - A simple console-based Pomodoro timer"
  echo ""
  echo "Usage: $0 [work_minutes] [break_minutes] [rounds] [notifications]"
  echo ""
  echo "Options:"
  echo "  work_minutes    Duration of each work period in minutes (default: 25)"
  echo "  break_minutes   Duration of each break period in minutes (default: 5)"
  echo "  rounds          Number of work-break cycles to complete (default: 4)"
  echo "  notifications   Enable desktop notifications: yes/no (default: yes)"
  echo ""
  echo "If no arguments are provided, interactive mode will be used with the"
  echo "following features:"
  echo "  - Customizable work and break periods"
  echo "  - Option to enable/disable desktop notifications"
  echo ""
  echo "Features:"
  echo "  - Visual alerts with flashing screen"
  echo "  - Sound alerts when periods end"
  echo "  - Desktop notifications (if supported by your system)"
  echo "  - Cross-platform support (Linux, macOS, Windows)"
  echo ""
  echo "Examples:"
  echo "  $0                      # Run in interactive mode"
  echo "  $0 25 5 4              # Standard Pomodoro with notifications"
  echo "  $0 50 10 3 yes         # Longer work sessions with notifications"
  echo "  $0 25 5 4 no           # Standard Pomodoro without notifications"
  exit 1
}

# Function to get a valid positive integer input
get_positive_integer() {
  local prompt=$1
  local default=$2
  local input

  while true; do
    read -p "$prompt [$default]: " input
    input=${input:-$default}
    
    if [[ "$input" =~ ^[0-9]+$ ]]; then
      echo "$input"
      return 0
    else
      echo "Error: Please enter a positive integer."
    fi
  done
}

# Function to get a yes/no input
get_yes_no() {
  local prompt=$1
  local default=$2
  local input

  while true; do
    read -p "$prompt [$default]: " input
    input=${input:-$default}
    
    if [[ "$input" =~ ^[Yy]([Ee][Ss])?$ ]]; then
      echo "yes"
      return 0
    elif [[ "$input" =~ ^[Nn][Oo]?$ ]]; then
      echo "no"
      return 0
    else
      echo "Error: Please enter yes or no."
    fi
  done
}

# Function to validate yes/no input
validate_yes_no() {
  local input=$1
  
  if [[ "$input" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    echo "yes"
    return 0
  elif [[ "$input" =~ ^[Nn][Oo]?$ ]]; then
    echo "no"
    return 0
  else
    echo ""
    return 1
  fi
}

# Function to clear the console screen
clear_screen() {
  clear
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to flash the terminal screen
flash_screen() {
  local message=$1
  local times=${2:-5}
  local delay=${3:-0.2}
  
  # Save current terminal settings
  tput smcup
  
  for ((i=1; i<=times; i++)); do
    # Flash background to white with black text
    tput setab 7
    tput setaf 0
    clear
    echo -e "\n\n\n"
    echo -e "                 $message                 "
    echo -e "\n\n\n"
    sleep $delay
    
    # Flash background to black with white text
    tput setab 0
    tput setaf 7
    clear
    echo -e "\n\n\n"
    echo -e "                 $message                 "
    echo -e "\n\n\n"
    sleep $delay
  done
  
  # Restore terminal settings
  tput rmcup
  tput sgr0
}

# Function to send desktop notification
send_notification() {
  local title=$1
  local message=$2
  
  if command_exists notify-send; then
    # Linux with notify-send
    notify-send "$title" "$message"
  elif command_exists osascript; then
    # macOS
    osascript -e "display notification \"$message\" with title \"$title\""
  elif command_exists powershell.exe; then
    # Windows with PowerShell
    powershell.exe -Command "New-BurntToastNotification -Text '$title', '$message'" >/dev/null 2>&1 || \
    powershell.exe -Command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('$message', '$title')" >/dev/null 2>&1
  fi
}

# Function to play alert sound
play_sound() {
  if command_exists paplay; then
    # Linux with PulseAudio
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga >/dev/null 2>&1 || \
    paplay /usr/share/sounds/freedesktop/stereo/bell.oga >/dev/null 2>&1
  elif command_exists afplay; then
    # macOS
    afplay /System/Library/Sounds/Ping.aiff >/dev/null 2>&1
  elif command_exists powershell.exe; then
    # Windows with PowerShell
    powershell.exe -Command "[console]::beep(800,500)" >/dev/null 2>&1
  else
    # Fallback to ASCII bell
    echo -e "\a"
  fi
}

# Function to alert user when a period ends
alert_user() {
  local message=$1
  
  # Visual alert in terminal
  flash_screen "$message"
  
  # Sound alert
  play_sound
  
  # Desktop notification if enabled
  if [ "$USE_DESKTOP_NOTIFICATIONS" = "yes" ]; then
    send_notification "Pomodoro Timer" "$message"
  fi
}

# Countdown function: Displays a MM:SS countdown in the console.
countdown() {
  local seconds=$1
  while [ "$seconds" -gt 0 ]; do
    local mins=$(( seconds / 60 ))
    local secs=$(( seconds % 60 ))
    # \r returns to the beginning of the line for updating the same output.
    printf "\r%02d:%02d remaining" "$mins" "$secs"
    sleep 1
    seconds=$(( seconds - 1 ))
  done
  echo ""  # Move to a new line after countdown finishes.
}

# Check if we need interactive mode
if [ "$#" -eq 0 ]; then
  echo "=== Pomodoro Timer Interactive Mode ==="
  echo "Please enter your preferred settings:"
  
  WORK_MINUTES=$(get_positive_integer "Work period duration in minutes" 25)
  BREAK_MINUTES=$(get_positive_integer "Break period duration in minutes" 5)
  ROUNDS=$(get_positive_integer "Number of rounds" 4)
  USE_DESKTOP_NOTIFICATIONS=$(get_yes_no "Enable desktop notifications if available" "yes")
elif [ "$#" -eq 3 ] || [ "$#" -eq 4 ]; then
  # Validate arguments as positive integers.
  if ! [[ "$1" =~ ^[0-9]+$ && "$2" =~ ^[0-9]+$ && "$3" =~ ^[0-9]+$ ]]; then
    echo "Error: work_minutes, break_minutes, and rounds must be positive integers."
    usage
  fi
  
  WORK_MINUTES=$1
  BREAK_MINUTES=$2
  ROUNDS=$3
  
  # Handle optional notifications parameter
  if [ "$#" -eq 4 ]; then
    USE_DESKTOP_NOTIFICATIONS=$(validate_yes_no "$4")
    if [ -z "$USE_DESKTOP_NOTIFICATIONS" ]; then
      echo "Error: notifications must be 'yes' or 'no'."
      usage
    fi
  else
    USE_DESKTOP_NOTIFICATIONS="yes"  # Default to yes if not specified
  fi
else
  echo "Error: Incorrect number of arguments."
  usage
fi

# Clear the screen before starting
clear_screen

echo "Starting Pomodoro Timer:"
echo "Work time: ${WORK_MINUTES} minute(s)"
echo "Break time: ${BREAK_MINUTES} minute(s)"
echo "Rounds: ${ROUNDS}"
echo "Desktop notifications: ${USE_DESKTOP_NOTIFICATIONS}"
echo ""
sleep 2  # Give user time to read settings

for (( i = 1; i <= ROUNDS; i++ )); do
  clear_screen
  echo "Round $i: Work period starts now."
  countdown $(( WORK_MINUTES * 60 ))
  
  # Alert user that work period is over
  alert_user "WORK PERIOD COMPLETE! Time for a break!"
  
  clear_screen
  echo "Round $i: Break period starts now."
  countdown $(( BREAK_MINUTES * 60 ))
  
  # Alert user that break period is over
  if [ "$i" -lt "$ROUNDS" ]; then
    alert_user "BREAK PERIOD COMPLETE! Get ready to work again!"
  else
    alert_user "POMODORO COMPLETE! Great job!"
  fi
  
  clear_screen
  echo "Round $i: Break period complete."
  echo ""
done

echo "Pomodoro Timer complete! Great job!"

---
id: pomodoro-timer
title: Pomodoro Timer
description: A simple console-based Pomodoro timer script to help you manage your work and break cycles
sidebar_label: Pomodoro Timer
keywords: [pomodoro, timer, productivity, util, utility, bash, script]
slug: /utils/pomodoro-timer
---

# Pomodoro Timer

A simple console-based Pomodoro timer script to help you manage your work and break cycles.

## Description

This Bash script implements the Pomodoro Technique, a time management method that uses a timer to break work into intervals, traditionally 25 minutes in length, separated by short breaks. The technique aims to improve focus and productivity.

The Pomodoro Technique is a time management method developed by Francesco Cirillo in the late 1980s. It uses a timer to break work into intervals, traditionally 25 minutes in length, separated by short breaks. Each interval is known as a "pomodoro", from the Italian word for tomato, after the tomato-shaped kitchen timer Cirillo used as a university student.

## Features

- **Customizable Timing**:
  - Adjustable work period duration
  - Adjustable break period duration
  - Configurable number of rounds

- **Interactive Mode**:
  - Guided setup with sensible defaults
  - Option to enable/disable desktop notifications

- **Alert System**:
  - Visual alerts with flashing screen and high-contrast messages
  - Sound alerts when periods end (system-dependent)
  - Desktop notifications (platform-specific)

- **User Experience**:
  - Clear console display between timer phases
  - Countdown timer with minutes:seconds format
  - Distinct alerts for work completion, break completion, and final completion

- **Cross-Platform Support**:
  - Linux
  - macOS
  - Windows

## Usage

```bash
./pomodoro-timer.sh [work_minutes] [break_minutes] [rounds] [notifications]
```

### Parameters

- `work_minutes`: Duration of each work period in minutes (default: 25)
- `break_minutes`: Duration of each break period in minutes (default: 5)
- `rounds`: Number of work-break cycles to complete (default: 4)
- `notifications`: Enable desktop notifications: yes/no (default: yes)

If no parameters are provided, the script will run in interactive mode, prompting you to enter values with sensible defaults.

### Examples

Standard Pomodoro (25-minute work periods, 5-minute breaks, 4 rounds) with notifications:

```bash
./pomodoro-timer.sh 25 5 4
```

Longer work sessions (50-minute work periods, 10-minute breaks, 3 rounds) with notifications:

```bash
./pomodoro-timer.sh 50 10 3 yes
```

Standard Pomodoro without desktop notifications:

```bash
./pomodoro-timer.sh 25 5 4 no
```

Interactive mode (will prompt for values with defaults):

```bash
./pomodoro-timer.sh
```

## Alert Types

The script provides multiple types of alerts when a work or break period ends:

### 1. Visual Alerts

The terminal screen flashes with a high-contrast message, alternating between:

- White background with black text
- Black background with white text

This makes it very noticeable when a period ends, even if you're looking away from the screen.

### 2. Sound Alerts

A sound is played when each period ends. The specific sound depends on your operating system:

- **Linux**: Uses PulseAudio to play system sounds
- **macOS**: Plays the system "Ping" sound
- **Windows**: Uses PowerShell to generate a beep
- **Fallback**: ASCII bell character for systems without audio support

### 3. Desktop Notifications

If enabled and supported by your system, a desktop notification is displayed:

- **Linux**: Uses `notify-send`
- **macOS**: Uses `osascript` to display notifications
- **Windows**: Uses PowerShell's notification capabilities

Desktop notifications can be enabled or disabled via:

- Command-line parameter: `./pomodoro-timer.sh 25 5 4 yes|no`
- Interactive mode: You'll be prompted to enable/disable them

## Requirements

- Bash shell environment
- Terminal that supports ANSI escape sequences and `tput` for visual alerts
- Optional: Desktop notification capabilities for your operating system

## Installation

1. Download the script:

   ```bash
   curl -O https://raw.githubusercontent.com/yourusername/repo/main/scripts/utils/pomodoro-timer/pomodoro-timer.sh
   ```

2. Make the script executable:

   ```bash
   chmod +x pomodoro-timer.sh
   ```

## Tips for Effective Use

1. **Set Clear Tasks**: Before starting a Pomodoro, decide on the task you want to accomplish.
2. **Eliminate Distractions**: Turn off notifications and put your phone away during work periods.
3. **Respect the Break**: Take your breaks seriously - step away from your work to refresh.
4. **Adjust Timing**: The standard 25/5 timing might not work for everyone. Experiment with different durations.
5. **Track Your Progress**: Consider keeping a log of completed Pomodoros and what you accomplished.

## License

This script is provided as-is under the MIT License.

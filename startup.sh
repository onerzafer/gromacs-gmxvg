#!/bin/bash

# Log file location
LOG_FILE="/data/container.log"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

# Log container startup
log_message "Container started"
log_message "Hostname: $(hostname)"
log_message "Container ID: $(hostname)"
log_message "System info: $(uname -a)"
log_message "Container is running"

# Store the background process ID
LOGGER_PID=$!

# Function to handle container shutdown
cleanup() {
    log_message "Container is shutting down"
    kill $LOGGER_PID
    exit 0
}

# Trap SIGTERM and SIGINT signals
trap cleanup SIGTERM SIGINT

# Execute the original command
log_message "Starting main process: $@"
if [ $# -eq 0 ]; then
    log_message "No command specified, starting bash"
    exec bash
else
    exec "$@"
fi

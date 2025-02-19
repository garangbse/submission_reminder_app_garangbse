#!/bin/bash

# Source environment variables and helper functions
source "$(dirname "$0")/../config/config.env"
source "$(dirname "$0")/../modules/functions.sh"

# Path to the submissions file
submissions_file="$(dirname "$0")/../assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: "
echo "Days remaining to submit:  days"
echo "--------------------------------------------"

check_submissions 

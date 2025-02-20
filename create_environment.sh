#!/bin/bash

read -p "what is your name: " yourname

mkdir -p submission_reminder_$yourname/app
mkdir -p submission_reminder_$yourname/modules
mkdir -p submission_reminder_$yourname/assets
mkdir -p submission_reminder_$yourname/config

touch submission_reminder_$yourname/app/reminder.sh
touch submission_reminder_$yourname/modules/functions.sh
touch submission_reminder_$yourname/assets/submissions.txt
touch submission_reminder_$yourname/config/config.env

# giving the files permissions
chmod +x submission_reminder_$yourname/app/reminder.sh
chmod +x submission_reminder_$yourname/modules/functions.sh
chmod +x submission_reminder_$yourname/assets/submissions.txt 
chmod +x submission_reminder_$yourname/config/config.env
chmod +x create_environment.sh

#declaring the main directory
orig_dir="submission_reminder_$yourname"

# adding the source code to the reminder.sh file
cat > $orig_dir/app/reminder.sh << 'EOL'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env || { echo "Failed to load config.env"; exit 1; }
source ./modules/functions.sh || { echo "Failed to load functions.sh"; exit 1; }

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOL

# Creating sample student records in submissions.txt
cat > $orig_dir/assets/submissions.txt << EOL
Garang Buke, Programming Basics, submitted
Tim Chumba, Web Development, not submitted
Sid Bausffs, Database Design, submitted
Emma Hilton, Python Project, not submitted
Charlie Brown, Java Assignment, submitted
Davis Buda, Network Security, not submitted
EOL

# adding the source code to the config.env file
cat > $orig_dir/config/config.env << EOL
ASSIGNMENT="Web Development"
DAYS_REMAINING=2
EOL

# adding the source code to the functions.sh file
cat > $orig_dir/modules/functions.sh << 'EOL'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < "$submissions_file" # Skip the header
}
EOL

# Create and make startup script executable
cat > $orig_dir/startup.sh << 'EOL'
#!/bin/bash

# Navigating to the main directory
cd "$(dirname "$0")"
echo "Current directory: $(pwd)"

# Stating the necessary files
necessary_files=("app/reminder.sh" "modules/functions.sh" "assets/submissions.txt" "config/config.env")

# Loop through each file and check if it exists
for file in "${necessary_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Error: Required file not found: $file"
        echo "Current directory: $(pwd)"
        echo "Please ensure all required files are in place"
        exit 1
    fi
done

# Source environment variables and aiding functions with error handling
source "config/config.env" || { echo "Config failed to load"; exit 1; }
source "modules/functions.sh" || { echo "Functions failed to load"; exit 1; }

# Launch the reminder application
./app/reminder.sh
EOL

# Make startup script executable and run it once
chmod +x $orig_dir/startup.sh
./$orig_dir/startup.sh

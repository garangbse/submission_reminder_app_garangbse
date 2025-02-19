#!/bin/bash

read -p "what is your name: " yourname

mkdir submission_reminder_$yourname 
mkdir submission_reminder_$yourname/app
mkdir submission_reminder_$yourname/modules 
mkdir submission_reminder_$yourname/assets
mkdir submission_reminder_$yourname/config

touch submission_reminder_$yourname/app/reminder.sh
touch submission_reminder_$yourname/modules/functions.sh
touch submission_reminder_$yourname/assets/submissions.txt
touch submission_reminder_$yourname/config/config.env


# adding the source code to the reminder.sh file
cat > submission_reminder_$yourname/app/reminder.sh << EOL
#!/bin/bash

# Source environment variables and helper functions
source "\$(dirname "\$0")/../config/config.env"
source "\$(dirname "\$0")/../modules/functions.sh"

# Path to the submissions file
submissions_file="\$(dirname "\$0")/../assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOL

# adding the source code to the functions.sh file
cat > submission_reminder_$yourname/modules/functions.sh << EOL
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
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOL


# Creating sample student records in submissions.txt
cat > submission_reminder_$yourname/assets/submissions.txt << EOL
Garang Buke|Programming Basics|submitted
Tim Chumba|Web Development|not submitted
Sid Bausffs|Database Design|submitted
Emma Hilton|Python Project|not submitted
Charlie Brown|Java Assignment|submitted
Davis Buda|Network Security|not submitted
EOL


# adding the source code to the config.env file
cat > submission_reminder_$yourname/config/config.env << EOL
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOL

# Create and make startup script executable
cat > submission_reminder_$yourname/startup.sh << EOL
#!/bin/bash

cd \$(dirname "\$0")
./app/reminder.sh
EOL

chmod +x submission_reminder_$yourname/startup.sh
chmod +x submission_reminder_$yourname/app/reminder.sh
chmod +x submission_reminder_$yourname/modules/functions.sh
chmod +x submission_reminder_$yourname/assets/submissions.txt
chmod +x submission_reminder_$yourname/config/config.env
chmod +x create_environment.sh


./submission_reminder_$yourname/modules/functions.sh
./submission_reminder_$yourname/startup.sh



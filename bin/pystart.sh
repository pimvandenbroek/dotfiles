#!/bin/bash

# Check if a project name was provided
if [ -z "$1" ]; then
  echo "Usage: $0 <project_name>"
  exit 1
fi

# Set the project name from the argument
PROJECT_NAME=$1

# Create the project directory
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# Create a virtual environment
python3 -m venv .venv

# Create the app.py file
echo 'print("Hello, World!")' > app.py
echo '.venv' > .gitignore

# Create an empty requirements.txt file
touch requirements.txt

# Print a success message
echo "Basic Python project setup completed in '$PROJECT_NAME'!"
echo "Activate the venv by running 'source .venv/bin/activate'"
echo "To deactivate, run: deactivate"

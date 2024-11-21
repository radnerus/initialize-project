#!/bin/bash

# Check if a name argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <project_name>"
  exit 1
fi

# Variables
PROJECT_NAME=$1
DESKTOP_PATH="$HOME/Desktop"
PROJECT_PATH="$DESKTOP_PATH/$PROJECT_NAME"
REPO_URL=""

# Create folder on Desktop
echo "Creating project folder at $PROJECT_PATH..."
mkdir -p "$PROJECT_PATH"

# Add README.md
echo "Adding README.md..."
echo "# $PROJECT_NAME" > "$PROJECT_PATH/README.md"

# Open folder in VSCode
echo "Opening project in VSCode..."
code "$PROJECT_PATH"

# Navigate to the project directory
cd "$PROJECT_PATH" || exit

# Initialize a git repository
echo "Initializing Git repository..."
git init

# Add the README.md file
git add README.md

# Commit the changes
echo "Committing changes..."
git commit -m "Initial commit with README.md"

# Create a GitHub repository (using GitHub CLI)
if command -v gh > /dev/null; then
  echo "Creating GitHub repository..."
  gh repo create "$PROJECT_NAME" --public --source=. --remote=  
  REPO_URL=$(git config --get remote.origin.url)
  echo "REPO_URL - $REPO_URL"
else
  echo "GitHub CLI (gh) is not installed. Please install it to create the repository."
fi

# Push changes to the remote repository
if [ -n "$REPO_URL" ]; then
  echo "Pushing to GitHub repository..."
  git push -u origin main
  echo "Repository created and pushed: $REPO_URL"
else
  echo "Repository not pushed. Set up a remote repository manually."
fi

echo "Project setup complete."
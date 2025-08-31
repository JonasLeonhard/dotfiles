#!/bin/bash
# Prompt the user for the new name using tofi
# The prompt will show which workspace number is being renamed
new_name_input=$("" | tofi --prompt-text "Rename Workspace to: ")
echo $new_name_input

# If the user pressed Esc or submitted an empty string, exit the script
if [ -z "$new_name_input" ]; then
    exit 0
fi

niri msg action set-workspace-name "$new_name_input"

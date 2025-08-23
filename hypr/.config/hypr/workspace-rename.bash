#!/bin/bash

# Get the ID of the currently active workspace
active_ws_id=$(hyprctl -j activeworkspace | jq .id)

# Check if we successfully got a workspace ID
if [ -z "$active_ws_id" ]; then
    notify-send "Workspace Rename" "Error: Could not determine active workspace."
    exit 1
fi

# Prompt the user for the new name using tofi
# The prompt will show which workspace number is being renamed
new_name_input=$(tofi --prompt-text "Rename Workspace $active_ws_id to: ")

# If the user pressed Esc or submitted an empty string, exit the script
if [ -z "$new_name_input" ]; then
    exit 0
fi

# Construct the final workspace name: "{number} {input}"
# We use quotes to handle names with spaces
final_name="$active_ws_id $new_name_input"

# Use hyprctl to dispatch the rename command
hyprctl dispatch renameworkspace "$active_ws_id" "$final_name"

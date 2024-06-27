#!/bin/bash

# Define the directory
DIR="/opt/odoo/custom_addons"

# SSH command to execute on the remote machine
SSH_COMMAND="ssh -i /home/marwa/.ssh/id_rsa marwa@172.20.10.4"

# Check if $DIR is provided
if [ -z "$DIR" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Check if the directory exists
if ${SSH_COMMAND} "[ -d \"$DIR\" ]"; then
  echo "Directory $DIR already exists."
else
  # Create the directory using sudo (if necessary)
  ${SSH_COMMAND} "sudo mkdir -p \"$DIR\" && sudo chown -R marwa:marwa \"$DIR\""

  # Check if directory creation was successful
  if ${SSH_COMMAND} "[ -d \"$DIR\" ]"; then
    echo "Directory $DIR created successfully."
  else
    echo "Failed to create directory $DIR. Exiting."
    exit 1
  fi
fi

# Clone the Git repository into the directory
git clone git@github.com:Marwajouili/Customaddons.git "$DIR"

echo "Done."

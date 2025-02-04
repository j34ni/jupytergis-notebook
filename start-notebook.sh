#!/bin/bash

set -e

# Normalize username if JUPYTERHUB_USER is set
if [ -n "$JUPYTERHUB_USER" ]; then
  REAL_JUPYTERHUB_USER=$JUPYTERHUB_USER
  JUPYTERHUB_USER=$(python /usr/local/bin/normalize-username.py $JUPYTERHUB_USER)
fi

# Set HOME directory
HOME=$(eval echo "$HOME")
if [ -n "$REAL_JUPYTERHUB_USER" ]; then
  JUPYTERHUB_USER=$REAL_JUPYTERHUB_USER
fi

# Ensure user's home directory exists
mkdir -p "$HOME"

# Create or update symbolic link for notebook
if [ ! -L "/home/notebook/notebook" ]; then
    rm -rf "/home/notebook/notebook" 2>/dev/null
    ln -snf "$HOME" /home/notebook/notebook
fi

# Copy .jupyter directory if it doesn't exist
if [ ! -d "$HOME/.jupyter" ]; then
    cp -r "/opt/.jupyter" "$HOME/.jupyter"
fi

# Copy ipcontroller-client.json if it exists
if [ -f "/tmp/ipcontroller-client.json" ]; then
  mkdir -p "$HOME/.ipython/profile_default/security/"
  cp "/tmp/ipcontroller-client.json" "$HOME/.ipython/profile_default/security/" || true
fi

# Copy jupyter_notebook_config.py if it doesn't exist
if [ ! -f "$HOME/.jupyter/jupyter_notebook_config.py" ]; then
    cp "/opt/.jupyter/jupyter_notebook_config.py" "$HOME/.jupyter"
fi

# Handle shared data directories
if [ -d "/mnt" ]; then
    for dir in /mnt/*/; do
      if [ -d "$dir" ]; then
        dirname=${dir##*/}
        ln -snf "$dir" "$HOME/shared-$dirname"
      fi
    done
fi

# Change to the user's home directory
cd "$HOME"

# Start JupyterLab
jupyter-notebook --config "$HOME/.jupyter/jupyter_notebook_config.py"

#!/bin/bash

# Activate Conda environment
. /opt/conda/etc/profile.d/conda.sh
conda activate

# Set CONFIG_FILE to the bind-mounted path
CONFIG_FILE="/mnt/config/config.py"
DEFAULT_CONFIG_FILE="/etc/jupyter/jupyter_lab_config.py"

# Debug: Log environment variables
echo "Inside container: CONFIG_FILE=$CONFIG_FILE"
echo "Inside container: HOME=$HOME"
echo "Inside container: UID=$(id -u), GID=$(id -g)"

# Adjust ownership of HOME if writable and UID differs from jovyan (1000)
if [ -w "$HOME" ] && [ "$(id -u)" -ne 1000 ]; then
    chown -R "$(id -u):$(id -g)" "$HOME"
fi

# Use the resolved HOME for runtime, config, and data if writable, else /tmp
if [ -w "$HOME" ]; then
    export JUPYTER_RUNTIME_DIR=${JUPYTER_RUNTIME_DIR:-$HOME/.jupyter/runtime}
    export JUPYTER_CONFIG_DIR=${JUPYTER_CONFIG_DIR:-$HOME/.jupyter}
    export JUPYTER_DATA_DIR=${JUPYTER_DATA_DIR:-$HOME/.jupyter/data}
else
    export JUPYTER_RUNTIME_DIR=${JUPYTER_RUNTIME_DIR:-/tmp/jupyter_runtime}
    export JUPYTER_CONFIG_DIR=${JUPYTER_CONFIG_DIR:-/tmp/jupyter_config}
    export JUPYTER_DATA_DIR=${JUPYTER_DATA_DIR:-/tmp/jupyter_data}
fi
mkdir -p "$JUPYTER_RUNTIME_DIR" "$JUPYTER_CONFIG_DIR" "$JUPYTER_DATA_DIR"

# Check if CONFIG_FILE exists (set by bind mount)
if [ -f "$CONFIG_FILE" ]; then
    echo "Using OOD-generated config file: $CONFIG_FILE"
    echo "Contents of $CONFIG_FILE:"
    cat "$CONFIG_FILE"  # Debug: Print the config file contents
    exec jupyter-lab --config="$CONFIG_FILE" --allow-root
else
    # Use JUPYTER_PORT environment variable if set, default to 8888
    PORT=${JUPYTER_PORT:-8888}
    echo "No OOD config found, using default config on port $PORT: $DEFAULT_CONFIG_FILE"
    exec jupyter-lab --config="$DEFAULT_CONFIG_FILE" --port="$PORT" --allow-root --no-browser
fi

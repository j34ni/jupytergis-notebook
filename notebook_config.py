#!/bin/bash

# Activate Conda environment
. /opt/conda/etc/profile.d/conda.sh
conda activate

# Debug: Log environment variables
echo "Inside container: CONFIG_FILE=$CONFIG_FILE"

# Use user's home for runtime, config, and data if writable, else /tmp
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

# Check if CONFIG_FILE is set (set by before.sh.erb)
if [ -n "$CONFIG_FILE" ]; then
    echo "Using OOD-generated config file: $CONFIG_FILE"
    exec jupyter-lab --config="$CONFIG_FILE" --allow-root
else
    echo "No CONFIG_FILE set, running with default config"
    exec jupyter-lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser
fi

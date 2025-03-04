#!/bin/bash

# Activate Conda environment
. /opt/conda/etc/profile.d/conda.sh
conda activate

# Set default port if not provided
JUPYTER_PORT=${JUPYTER_PORT:-8888}

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

# Check if JUPYTERHUB_SERVICE_URL is set
if [ -z "$JUPYTERHUB_SERVICE_URL" ]; then
    echo "Running standalone JupyterLab (not under JupyterHub) on port $JUPYTER_PORT"
    exec jupyter-lab --ip=0.0.0.0 --port="$JUPYTER_PORT" --allow-root --no-browser
else
    echo "Running under JupyterHub"
    exec jupyterhub-singleuser --config="$JUPYTER_CONFIG_DIR/notebook_config.py" --SingleUserLabApp.default_url=/lab
fi

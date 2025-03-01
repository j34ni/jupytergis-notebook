#!/bin/bash

# Check if JUPYTERHUB_SERVICE_URL is set
if [ -z "$JUPYTERHUB_SERVICE_URL" ]; then
    echo "Running standalone JupyterLab (not under JupyterHub)"
    exec jupyter-lab --ip=0.0.0.0 --port=8888 --allow-root --NotebookApp.token='' --NotebookApp.base_url=/
else
    echo "Running under JupyterHub"
    exec jupyterhub-singleuser --config=/home/jovyan/.jupyter/notebook_config.py --SingleUserLabApp.default_url=/lab
fi

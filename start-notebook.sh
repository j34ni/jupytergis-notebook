#!/bin/bash

# Start JupyterHub single-user server
exec jupyterhub-singleuser --config=/home/jovyan/.jupyter/notebook_config.py --SingleUserLabApp.default_url=/lab

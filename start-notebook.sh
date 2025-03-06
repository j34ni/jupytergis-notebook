#!/bin/bash

cp /opt/uio/notebook_config.py /home/notebook/.jupyter/
jupyterhub-singleuser --config "/home/notebook/.jupyter/notebook_config.py" --SingleUserLabApp.default_url="/lab"

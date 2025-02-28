#!/bin/bash

jupyterhub-singleuser --config "/home/notebook/.jupyter/notebook_config.py" --SingleUserLabApp.default_url="/lab"

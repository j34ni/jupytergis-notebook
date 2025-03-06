#!/bin/bash

jupyterhub-singleuser --config "/opt/uio/notebook_config.py" --SingleUserLabApp.default_url="/lab"

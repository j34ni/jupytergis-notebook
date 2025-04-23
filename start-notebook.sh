#!/bin/bash

cp /opt/uio/notebook_config.py /home/notebook/.jupyter/
jupyter lab --config "/home/notebook/.jupyter/notebook_config.py"

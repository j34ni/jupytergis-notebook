FROM ubuntu:22.04

LABEL maintainer="jeani@nris.no"
USER root

# Install basic packages
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends tzdata wget && \
    apt clean

# Install Miniforge3
RUN wget -q -nc --no-check-certificate -P /var/tmp https://github.com/conda-forge/miniforge/releases/download/24.9.2-0/Miniforge3-24.9.2-0-Linux-x86_64.sh && \
    bash /var/tmp/Miniforge3-24.9.2-0-Linux-x86_64.sh -b -p /opt/conda

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
    APP_GID=999 \
    PKG_JUPYTER_LAB_VERSION=4.3.5

# Create a dedicated user for Jupyter
RUN groupadd -g "$APP_GID" notebook && \
    useradd -m -s /bin/bash -N -u "$APP_UID" -g notebook notebook && \
    usermod -G users notebook && chmod go+rwx -R "$CONDA_DIR/bin"

ENV TZ="Europe/Oslo"

# Minimal setup for Jupyter environment
ENV HOME=/home/notebook \
    XDG_CACHE_HOME=/home/notebook/.cache/

# Copy scripts and configurations
COPY normalize-username.py /usr/local/bin/

# Install GIS tools and fix SQLite issue directly in the base environment
RUN . /opt/conda/etc/profile.d/conda.sh && conda activate && \
    mamba install -c conda-forge -y \
    escapism \
    geopandas \
    jupytergis=0.2.0 \
    jupyterhub==4.* \
    nb_conda_kernels \
    notebook \
    pycrdt \
    qgis \
    sqlite=3.45 && \
    mamba clean --all -y

# Ensure Conda is configured for the notebook user
USER notebook
WORKDIR $HOME
COPY jupyter_lab_config.py $HOME/

# Create the script in the notebook user's home directory
RUN echo '#!/bin/bash\n\
set -e\n\
. /opt/conda/etc/profile.d/conda.sh\n\
conda activate\n\
jupyter lab --config "$HOME/jupyter_lab_config.py"' > $HOME/start-notebook.sh \
    && chmod +x /home/notebook/start-notebook.sh

# Set the default command to run the script 
CMD ["./start-notebook.sh"]

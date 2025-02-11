FROM jupyter/base-notebook:x86_64-ubuntu-22.04

LABEL maintainer="jeani@nris.no"
USER root

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
    APP_GID=999 \
    PKG_JUPYTER_NOTEBOOK_VERSION=7.0.6

# Create a dedicated user for Jupyter
RUN groupadd -g "$APP_GID" notebook && \
    useradd -m -s /bin/bash -N -u "$APP_UID" -g notebook notebook && \
    usermod -G users notebook

# Install basic system utilities and necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    net-tools \
    openssh-client \
    sudo \
    tzdata && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

ENV TZ="Europe/Oslo"

# Minimal setup for Jupyter environment
ENV HOME=/home/notebook \
    XDG_CACHE_HOME=/home/notebook/.cache/
COPY normalize-username.py /usr/local/bin/
COPY --chown=notebook:notebook .jupyter/ /opt/.jupyter/

# Ensure Conda is configured for the notebook user
USER notebook
WORKDIR $HOME

# Set up directories and permissions
RUN mkdir -p /home/notebook/.ipython/profile_default/security/ /home/notebook/work

# Install all GIS tools and necessary packages directly into the base environment
RUN mamba install -c conda-forge -y \
    escapism \
    geopandas \
    jupytergis=0.2.0 \
    nb_conda_kernels \
    pycrdt \
    python=3.11 \
    qgis \
    sqlite=3.45 && \
    mamba clean --all -y

COPY start-notebook.sh /home/notebook/

# Set the command to run the start-notebook.sh script
CMD ["/home/notebook/start-notebook.sh"]

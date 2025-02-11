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
    usermod -G users notebook && chmod go+rwx -R "$CONDA_DIR/bin"

# Install basic system utilities and necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    less \
    micro \
    net-tools \
    openssh-client \
    screen \
    sudo \
    tzdata \
    vim && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime

ENV TZ="Europe/Oslo"

# Minimal setup for Jupyter environment
ENV HOME=/home/notebook \
    XDG_CACHE_HOME=/home/notebook/.cache/
COPY normalize-username.py start-notebook.sh /usr/local/bin/
COPY --chown=notebook:notebook .jupyter/ /opt/.jupyter/

# Set up directories and permissions
RUN mkdir -p /home/notebook/.ipython/profile_default/security/ && \
    mkdir -p /home/notebook/work && \
    chown -R notebook:notebook "$CONDA_DIR/bin" "$HOME" /home/notebook/work && \
    chmod -R 755 "$CONDA_DIR" "$HOME" /home/notebook/work && \
    chmod go+rwx -R "$CONDA_DIR/bin" && \
    mkdir -p "$CONDA_DIR/.condatmp" && \
    chmod go+rwx "$CONDA_DIR/.condatmp" && \
    chown notebook:notebook "$CONDA_DIR"

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

# Ensure Conda is configured for the notebook user
USER notebook
WORKDIR $HOME

# Set the command to run the start-notebook.sh script
CMD ["/usr/local/bin/start-notebook.sh"]

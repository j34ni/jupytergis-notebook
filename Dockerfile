FROM jupyter/base-notebook:latest

LABEL maintainer="jeani@nris.no"

USER root

# Install additional system dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Enhance existing Conda with mamba and update environment
RUN /opt/conda/bin/conda config --add channels conda-forge \
    && /opt/conda/bin/conda config --set always_yes yes \
    && /opt/conda/bin/conda update -n base conda \
    && /opt/conda/bin/conda install -n base mamba

# Install Python packages with mamba, pinning jupytergis=0.4.1
RUN mamba install -y ipyleaflet jupyterlab jupytergis=0.4.1 geopandas \
    && mamba clean --all -y

# Copy configuration and startup script
COPY notebook_config.py /home/jovyan/.jupyter/
COPY start-notebook.sh /home/jovyan/

# Set permissions, avoiding problematic directories
RUN chown -R jovyan:users /opt/conda/share/proj/ \
    && chown -R jovyan:users /home/jovyan \
    && chmod -R 755 /home/jovyan

WORKDIR /home/jovyan

USER jovyan

# Command to start the single-user server
CMD ["/home/jovyan/start-notebook.sh"]

FROM jupyter/base-notebook:latest

LABEL maintainer="jeani@nris.no"

USER root

# Install additional system dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Enhance existing Conda with mamba and update environment
RUN conda config --add channels conda-forge \
    && conda config --set always_yes yes \
    && conda update -n base conda \
    && conda install -n base mamba

# Install Python packages with mamba, pinning jupytergis=0.4.1
RUN mamba install -y ipyleaflet jupyterlab jupytergis=0.4.1 geopandas \
    && mamba clean --all -y

# Copy configuration and startup script
COPY start-notebook.sh /home/jovyan/

# Set permissions
RUN chown -R jovyan:users /home/jovyan \
    && chmod -R 755 /home/jovyan

WORKDIR /home/jovyan

USER jovyan

# Expose default port (will be overridden by JUPYTER_PORT if set)
EXPOSE 8888

# Command to start the notebook server
CMD ["/home/jovyan/start-notebook.sh"]

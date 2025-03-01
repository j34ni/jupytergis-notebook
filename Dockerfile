# Use the latest Jupyter base image
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
    && conda install -n base mamba \
    && mamba update -c conda-forge --all

# Switch to jovyan user for package installation and build
USER $NB_USER

# Install Python packages with mamba, pinning jupytergis=0.4.1
RUN mamba install -y jupyterlab jupytergis=0.4.1 geopandas \
    && mamba install -y folium gdal proj proj-data shapely rasterio xarray dask pydeck h3 \
    && mamba install -y ipyleaflet --force-reinstall \
    && mamba clean --all -y 

# Copy configuration and startup script
COPY notebook_config.py /home/$NB_USER/.jupyter/
COPY start-notebook.sh /home/$NB_USER/

# Set permissions, ignoring errors for unchangeable files
RUN chown -R $NB_USER:users /home/$NB_USER -f \
    && chmod -R 755 /home/$NB_USER \
    && chown -R $NB_USER:users /opt/conda/share/proj/ -f

WORKDIR /home/$NB_USER

# Command to start the single-user server
CMD ["/home/$NB_USER/start-notebook.sh"]

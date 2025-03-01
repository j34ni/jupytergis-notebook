FROM jupyter/base-notebook:latest

LABEL maintainer="jeani@nris.no"

USER root

# Install additional system dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Enhance existing Conda with mamba and update to a specific version
RUN /opt/conda/bin/conda config --add channels conda-forge \
    && /opt/conda/bin/conda config --set always_yes yes \
    && /opt/conda/bin/conda install -n base conda=25.1.1 \
    && /opt/conda/bin/conda update -n base conda \
    && /opt/conda/bin/conda install -n base mamba

# Install Python packages with mamba, pinning jupytergis=0.4.1
RUN /opt/conda/bin/mamba install -y python=3.11 jupyterlab jupytergis=0.4.1 geopandas folium gdal proj proj-data shapely rasterio xarray dask pydeck h3 \
    && /opt/conda/bin/mamba install -y ipyleaflet --force-reinstall \
    && /opt/conda/bin/mamba clean --all -y \
    && /opt/conda/bin/jupyter lab build

# Install JupyterHub
RUN pip install jupyterhub

# Copy configuration and startup script
COPY notebook_config.py /home/jovyan/.jupyter/
COPY start-notebook.sh /home/jovyan/

# Set permissions and working directory
RUN chown -R jovyan:users /opt/conda/share/proj/ \
    && chown -R jovyan:users /home/jovyan \
    && chmod -R 755 /home/jovyan

WORKDIR /home/jovyan

USER jovyan

# Command to start the single-user server
CMD ["/home/jovyan/start-notebook.sh"]

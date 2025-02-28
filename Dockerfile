FROM sigma2as/jupyterhub-singleuser-base-notebook:20231017-75e6934

LABEL maintainer="jeani@nris.no"

USER root

RUN mamba install -c conda-forge -y \
    escapism \
    geopandas \
    jupyterhub \
    jupyter_server \
    jupyterlab=3.6.* \
    jupytergis=0.2.0 \
    nb_conda_kernels \
    pycrdt \
    python=3.11 \
    qgis \
    ipyleaflet=0.17.0 \
    folium \
    gdal=3.6.* \
    proj=9.* \
    proj-data \
    shapely \
    rasterio \
    xarray \
    dask \
    pydeck \
    h3 \
    unzip \
    && mamba clean --all -y \
    && ls -l /opt/conda/share/proj/  # Debug: Check contents

COPY notebook_config.py /home/notebook/.jupyter/
COPY start-notebook.sh /home/notebook/

RUN chown -R notebook:notebook /home/notebook/
RUN chmod -R 777 /home/notebook/

WORKDIR /home/notebook

USER notebook

CMD ["/home/notebook/start-notebook.sh"]

FROM sigma2as/jupyterhub-singleuser-base-notebook:20231017-75e6934

LABEL maintainer="jeani@nris.no"

USER root

RUN mamba install -c conda-forge -y \
    geopandas \
    jupytergis \
    jupyterlab \
    ipyleaflet \
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
    && mamba clean --all -y

RUN jupyter lab build

COPY notebook_config.py /opt/uio
COPY start-notebook.sh /opt/uio

RUN chown -R notebook:notebook /opt/uio
RUN chmod -R 777 /opt/uio

WORKDIR /home/notebook

USER notebook

CMD ["/opt/uio/start-notebook.sh"]

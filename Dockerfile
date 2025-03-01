FROM sigma2as/jupyterhub-singleuser-base-notebook:20231017-75e6934

LABEL maintainer="jeani@nris.no"

USER root

# Install only necessary packages, avoiding redundancy
RUN mamba install -c conda-forge -y \
    geopandas \
    jupytergis=0.2.0 \
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
    && mamba clean --all -y 

COPY notebook_config.py /home/notebook/.jupyter/
COPY start-notebook.sh /home/notebook/

RUN chown -R notebook:notebook /home/notebook/
RUN chmod -R 777 /home/notebook/

WORKDIR /home/notebook

USER notebook

CMD ["/home/notebook/start-notebook.sh"]

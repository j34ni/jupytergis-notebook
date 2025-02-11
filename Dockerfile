FROM sigma2as/jupyterhub-singleuser-base-notebook:20231017-75e6934

LABEL maintainer="jeani@nris.no"

USER root
COPY --chown=notebook:notebook jupyter_server_config.py /opt/.jupyter/

USER notebook
WORKDIR $HOME

# Install all GIS tools and necessary packages directly into the base environment
RUN mamba install -c conda-forge -y \
    escapism \
    geopandas \
    ipyparallel \
    jupytergis \
    nb_conda_kernels \
    pycrdt \
    python=3.11 \
    qgis \
    sqlite=3.45 && \
    mamba clean --all -y

COPY start-notebook.sh /home/notebook/

# Set the command to run the start-notebook.sh script
CMD ["/home/notebook/start-notebook.sh"]

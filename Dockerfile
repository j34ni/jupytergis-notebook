FROM sigma2as/jupyterhub-singleuser-base-notebook:20231017-75e6934

LABEL maintainer="jeani@nris.no"

USER root
<<<<<<< HEAD
=======
COPY --chown=notebook:notebook jupyter_server_config.py $HOME/.jupyter/
>>>>>>> cd01a6d49b3390db333951165dc74efb20636c6c

COPY --chown=notebook:notebook jupyter_server_config.py $HOME/.jupyter/

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

COPY notebook_config.py /home/notebook/.jupyter/
COPY start-notebook.sh /home/notebook/

RUN chown -R notebook:notebook /home/notebook/ 
RUN chmod -R 777 /home/notebook/

WORKDIR /home/notebook

USER notebook

CMD ["/home/notebook/start-notebook.sh"]

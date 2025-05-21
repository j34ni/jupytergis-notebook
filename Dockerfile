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

# Install Python packages with mamba, pinning jupytergis=0.5.0
RUN mamba install -y bottleneck cartopy folium fsspec graphviz ipyleaflet jupyterlab jupytergis=0.5.0 geopandas mapclassify matplotlib matplotlib-inline mystmd numpy xarray \
    && mamba clean --all -y

# Add a default configuration file to enable RTC and JupyterGIS
RUN mkdir -p /etc/jupyter \
    && echo "import os" > /etc/jupyter/jupyter_lab_config.py \
    && echo "c.JupyterLabApp.collaborative = True" >> /etc/jupyter/jupyter_lab_config.py \
    && echo "c.ServerApp.allow_origin = '*'" >> /etc/jupyter/jupyter_lab_config.py \
    && echo "c.ServerApp.disable_check_xsrf = True" >> /etc/jupyter/jupyter_lab_config.py \
    && echo "c.ServerApp.ip = '0.0.0.0'" >> /etc/jupyter/jupyter_lab_config.py \
    && echo "c.ServerApp.allow_remote_access = True" >> /etc/jupyter/jupyter_lab_config.py \
    && echo "c.ServerApp.allow_root = False" >> /etc/jupyter/jupyter_lab_config.py \
    && echo "c.ServerApp.token = ''" >> /etc/jupyter/jupyter_lab_config.py \
    && echo "c.ServerApp.password = ''" >> /etc/jupyter/jupyter_lab_config.py \
    && echo "c.ServerApp.base_url = os.environ.get('JUPYTERHUB_BASE_URL', os.environ.get('PROXY_PREFIX', '/user/' + os.environ.get('JUPYTERHUB_USER', 'default') + '/'))" >> /etc/jupyter/jupyter_lab_config.py \
    && echo "c.ServerApp.static_url_prefix = c.ServerApp.base_url + 'static/'" >> /etc/jupyter/jupyter_lab_config.py \
    && echo "c.ServerApp.port = int(os.environ.get('JUPYTER_PORT', 8888))" >> /etc/jupyter/jupyter_lab_config.py \
    && echo "c.ServerApp.root_dir = os.environ.get('JUPYTER_ROOT_DIR', os.path.expanduser('~/jupytergis_notebooks'))" >> /etc/jupyter/jupyter_lab_config.py \
    && echo "c.LabApp.extensions = {'jupytergis': True}" >> /etc/jupyter/jupyter_lab_config.py \
    && echo "c.ServerApp.log_level = 'DEBUG'" >> /etc/jupyter/jupyter_lab_config.py

# Copy the startup script
COPY start-notebook.sh /home/jovyan/

# Set permissions to be more permissive for host user mapping
RUN chown -R 1000:100 /home/jovyan \
    && chmod -R 755 /home/jovyan \
    && chmod -R u+rwX /home/jovyan

WORKDIR /home/jovyan

# Switch to jovyan as default, but rely on runtime user mapping
USER jovyan

# Expose default port (used as fallback; OOD assigns a dynamic port)
EXPOSE 8888

# Command to start the notebook server
CMD ["/home/jovyan/start-notebook.sh"]

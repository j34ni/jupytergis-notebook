FROM quay.io/galaxy/docker-jupyter-notebook:25.12.1

RUN conda install --yes \
    bioblend galaxy-ie-helpers qgis && \
    conda clean --all -y --force-pkgs-dirs && \
    find /opt/conda -type l -xtype l -delete && \
    fix-permissions /opt/conda

RUN pip install jupytergis==0.13.2

ADD jupyter_notebook_config.py /home/$NB_USER/.jupyter/
ADD jupyter_lab_config.py /home/$NB_USER/.jupyter/

RUN chown -R $NB_USER:users /home/$NB_USER/ /import /export/ && \
    chmod -R 777 /home/$NB_USER/ /import /export/

WORKDIR /import

CMD /startup.sh

FROM quay.io/galaxy/docker-jupyter-notebook:25.12.1

RUN conda install --yes \ 
    bioblend galaxy-ie-helpers \
    qgis && \
    conda clean --all -y  && \
    fix-permissions /opt/conda

RUN pip install jupytergis==0.13.2 'jupyter-ai[all]'

ADD jupyter_notebook_config.py /home/$NB_USER/.jupyter/
ADD jupyter_lab_config.py /home/$NB_USER/.jupyter/

RUN chown -R $NB_USER:users /home/$NB_USER/ /import /export/ && \
    chmod -R 777 /home/$NB_USER/ /import /export/

RUN mkdir -p /opt/ollama/bin /opt/ollama/models && \
    chown -R $NB_USER:users /opt/ollama

RUN cd /opt/ollama && \
    curl -L https://ollama.com/download/ollama-linux-amd64.tgz -o ollama-linux-amd64.tgz && \
    tar -xzf ollama-linux-amd64.tgz && \
    rm ollama-linux-amd64.tgz

ENV PATH="/opt/ollama/bin:${PATH}"

RUN ollama serve & \
    until curl -s http://localhost:11434/api/tags > /dev/null; do sleep 1; done && \
    ollama pull llama3.2 && \
    pkill ollama

WORKDIR /import

COPY start-ollama.sh /usr/local/bin/start-ollama.sh
RUN chmod +x /usr/local/bin/start-ollama.sh

CMD /startup.sh

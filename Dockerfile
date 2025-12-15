FROM mambaorg/micromamba:1.5.10-noble
COPY --chown=$MAMBA_USER:$MAMBA_USER conda.yml /tmp/conda.yml
RUN micromamba install -y -n base -f /tmp/conda.yml \
    && micromamba install -y -n base conda-forge::procps-ng \
    && micromamba env export --name base --explicit > environment.lock \
    && echo ">> CONDA_LOCK_START" \
    && cat environment.lock \
    && echo "<< CONDA_LOCK_END" \
    && micromamba clean -a -y
USER root
ENV PATH="$MAMBA_ROOT_PREFIX/bin:$PATH"

ENV XDG_CACHE_HOME=/tmp/cache
ENV XDG_CONFIG_HOME=/tmp/config
ENV XDG_DATA_HOME=/tmp/share

RUN mkdir -p /tmp/cache /tmp/config /tmp/share

# ADD IF YOU ARE INCLUDING A SCRIPT
RUN mkdir -p /opt/script

COPY script.sh /opt/script/script.sh

RUN chmod +x /opt/script/script.sh && \
    ln -s /opt/script/script.sh /usr/local/bin/script

USER $MAMBA_USER
ENV PATH="$MAMBA_ROOT_PREFIX/bin:$PATH"

CMD ["/bin/bash"]
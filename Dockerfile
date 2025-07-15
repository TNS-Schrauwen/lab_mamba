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

ENV HOME=/tmp
# ABOVE IS THE BASE AND NORMALLY YOU WOULD NOT CHANGE THIS

#ADD IF YOU ARE USING PYTHON OR R PACKAGES

# Create cache directories
RUN mkdir -p /tmp/cache/pip && \
    mkdir -p /tmp/cache/R && \
    mkdir -p /tmp/cache/mamba && \
    chmod -R 777 /tmp/cache

# Python caches
ENV PIP_CACHE_DIR=/tmp/cache/pip
ENV PYTHONUSERBASE=/tmp/cache/python
ENV PYTHONDONTWRITEBYTECODE=1

# R caches and config
ENV R_LIBS_USER=/tmp/cache/R
ENV R_LIBS_SITE=/tmp/cache/R
ENV R_ENVIRON_USER=/tmp/.Renviron
ENV R_PROFILE_USER=/tmp/.Rprofile

# ADD IF YOU ARE INCLUDING A SCRIPT
RUN mkdir -p /home/mambauser

COPY script.sh /home/mambauser/script.sh

RUN chmod +x /home/mambauser/script.sh && \
    ln -s /home/mambauser/script.sh /usr/local/bin/script.sh && \
    ln -s /usr/local/bin/script.sh /usr/local/bin/script

CMD ["/bin/bash"]
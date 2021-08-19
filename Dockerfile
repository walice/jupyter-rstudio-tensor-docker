FROM jupyter/scipy-notebook:70178b8e48d7

# START binder compatibility
# from https://mybinder.readthedocs.io/en/latest/tutorials/dockerfile.html

ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

COPY . ${HOME}/work
USER root
RUN chown -R ${NB_UID} ${HOME}

# END binder compatibility code

# Add modification code below

USER ${NB_USER}

# Jupyter notebook extensions
RUN \
    pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --sys-prefix && \
    \
    jupyter nbextension enable toc2/main --sys-prefix && \
    jupyter nbextension enable export_embedded/main --sys-prefix

RUN \
    jupyter nbextensions_configurator enable --sys-prefix && \
    \
    pip install --pre rise && \
    jupyter nbextension install rise --py --sys-prefix && \
    jupyter nbextension enable rise --py --sys-prefix && \
    \
    pip install nbzip && \
    jupyter serverextension enable nbzip --py --sys-prefix && \
    jupyter nbextension install nbzip --py --sys-prefix && \
    jupyter nbextension enable nbzip --py --sys-prefix

# Jupyter Lab extensions
RUN jupyter labextension install @jupyterlab/toc --clean && \
    jupyter labextension install nbdime-jupyterlab
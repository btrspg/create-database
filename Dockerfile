FROM continuumio/miniconda2

MAINTAINER CHEN, Yuelong <yuelong.chen.btr@gmail.com>


WORKDIR /opt/create_database
ADD ./* ./
RUN . activate base \
    && conda env update  -f conda-env.yml -n base

ENV PATH "$PATH:/opt/create_database/"

CMD bash
FROM continuumio/miniconda2

MAINTAINER CHEN, Yuelong <yuelong.chen.btr@gmail.com>

RUN source activate base \
    && conda install -y -c bioconda bwa samtools hisat2 picard

WORKDIR /opt/create_database
ADD ./*sh ./
ENV PATH "$PATH:/opt/create_database/"

CMD bash
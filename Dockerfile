FROM everware/base
MAINTAINER Tim Head <betatim@gmail.com>

USER root
RUN apt-get -y update
# Things needed to build ROOT
RUN apt-get -y --force-yes install libx11-dev libxpm-dev libxft-dev libxext-dev libpng3 libjpeg8 gfortran libssl-dev libpcre3-dev libgl1-mesa-dev libglew1.5-dev libftgl-dev libmysqlclient-dev libfftw3-dev libcfitsio3-dev graphviz-dev libavahi-compat-libdnssd-dev libldap2-dev libxml2-dev libafterimage0 libafterimage-dev cmake

WORKDIR /tmp

# ROOT from source, because that is how we roll
#
# built with python2.7 take care to install all python modules for this
# version of python later on
RUN git clone --depth 1 http://root.cern.ch/git/root.git -b v6-05-02 --single-branch
RUN /bin/bash -c "source activate py27 \
    && mkdir root-build \
    && cd root-build \
    && cmake ../root -Droofit=ON -Dhdfs=OFF -Dbuiltin_xrootd=ON -DCMAKE_INSTALL_PREFIX=/usr/local \
    && make -j6 \
    && cmake --build . --target install \
    && cd .. \
    && rm -rf root root-build"

ENV LD_LIBRARY_PATH /usr/local/lib/root:$LD_LIBRARY_PATH
ENV PYTHONPATH /usr/local/lib:$PYTHONPATH

RUN conda install -n py27 --yes numpy==1.9.2
RUN conda install -n py27 --yes scipy==0.16.0
RUN conda install -n py27 --yes matplotlib==1.4.3

RUN apt-get install -y --force-yes vim emacs
RUN apt-get -y install zsh
RUN apt-get -y install libboost-all-dev
RUN apt-get -y install texlive-luatex
RUN apt-get -y install krb5-user krb5-config

# Change ownership of the conda directory so users can install
# extra packages without being root
RUN chown -R jupyter /opt/conda

ADD krb5.conf /etc/krb5.conf

RUN /bin/bash -c "source activate py27 \
       && python -c \"import os;import json;f='/usr/local/share/jupyter/kernels/python2/kernel.json';j=json.load(open(f));j['env']={'PATH': os.environ['PATH']};json.dump(j,open(f,'w'))\""

WORKDIR /home/jupyter
USER jupyter
ADD bashrc /home/jupyter/.bashrc
ADD root-kernel.json /usr/local/share/jupyter/kernels/root/kernel.json

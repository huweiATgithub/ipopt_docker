FROM python:3.8.7-buster

ARG LIB_DIR=/usr/local
RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    gfortran \
    libblas-dev liblapack-dev \
    && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
WORKDIR /src
# Install Metis
RUN git clone https://github.com/coin-or-tools/ThirdParty-Metis.git && \
    cd ThirdParty-Metis && ./get.Metis && ./configure --prefix=$LIB_DIR && make && make install
  
# These Linear algebra package no longer updated and have some problems of linking.
# TODO: compile other high performance BLAS, LAPACK
# WORKDIR /src
# RUN git clone https://github.com/coin-or-tools/ThirdParty-Blas.git
#     cd ThirdParty-Blas && ./get.Blas && ./configure --prefix=$LIB_DIR && make && make install 
# WORKDIR /src
# RUN git clone https://github.com/coin-or-tools/ThirdParty-Lapack.git
#     cd ThirdParty-Lapack && ./get.Lapack && ./configure --prefix=$LIB_DIR && make && make install

# Install HSL
ARG COINHSL_VER=2014.01.10
COPY coinhsl.tar.gz .
RUN git clone https://github.com/coin-or-tools/ThirdParty-HSL.git && \
    cd ThirdParty-HSL && \
    cp /src/coinhsl.tar.gz . && tar -xf coinhsl.tar.gz && mv coinhsl-$COINHSL_VER coinhsl && \
    ./configure --prefix=$LIB_DIR && make && make install
    
# Install IPOPT
ARG IPOPT_VER=3.13.3
RUN curl -O https://www.coin-or.org/download/source/Ipopt/Ipopt-${IPOPT_VER}.tgz && \
    tar -xf Ipopt-${IPOPT_VER}.tgz && cd Ipopt-releases-${IPOPT_VER} && \
    ./configure --prefix=$LIB_DIR && make && make install
ENV LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}

# Install cyipopt
RUN pip install --no-cache-dir --ignore-installed numpy cython future six setuptools && \
    git clone https://github.com/mechmotum/cyipopt.git && \
    cd cyipopt && python setup.py build && python setup.py install

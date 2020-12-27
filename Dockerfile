FROM python:3.8.7-buster

LIB_DIR = /usr/local
RUN apt-get update && apt-get install gfortran
WORKDIR /src
RUN git clone https://github.com/coin-or-tools/ThirdParty-Metis.git && \
    cd ThirdParty-Metis && ./get.Metis && ./configure --prefix=$LIB_DIR && make && make install

# These Linear algebra package no longer updated and have some problems of linking.
# WORKDIR /src
# RUN git clone https://github.com/coin-or-tools/ThirdParty-Blas.git
#     cd ThirdParty-Blas && ./get.Blas && ./configure --prefix=$LIB_DIR && make && make install
    
# WORKDIR /src
# RUN git clone https://github.com/coin-or-tools/ThirdParty-Lapack.git
#     cd ThirdParty-Lapack && ./get.Lapack && ./configure --prefix=$LIB_DIR && make && make install

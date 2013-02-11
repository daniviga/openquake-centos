__work in progress, not ready yet__

## System
    yum install bzip2 wget gcc gcc-c++.x86_64 compat-gcc-34-c++.x86_64 openssl-devel.x86_64 zlib*.x86_64 make.x86_64 ncurses-devel.x86_64 bzip2-devel.x86_64 readline-devel.x86_64 zip.x86_64 unzip.x86_64 nc.x86_64 curl-devel.x86_64 expat-devel.x86_64 gettext.x86_64 gettext-devel.x86_64 xmlto.x86_64

## Git
    make prefix=~/git install

## Python 2.7
    ./configure --prefix=$HOME/python
    make
    make install

## setuptools
    wget http://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg
    /bin/bash setuptools-0.6c11-py2.7.egg

## pip
    python2.7 setup.py install

## numpy
    pip install numpy

## scipy
    yum install -y gcc-gfortran.x86_64 compat-gcc-34-g77.x86_64 libgfortran.x86_64
    yum install blas*.x86_64 lapack*.x86_64
    cp /usr/lib64/libblas.so /usr/lib64/liblapack.so ~/python/lib/
    pip install scipy

## erlang
    yum install libxslt.x86_64 unixODBC-devel.x86_64
    wget http://www.erlang.org/download/otp_src_R15B03-1.tar.gz
    ./configure
    make
    make RELEASE_ROOT=~/erlang release
    cd ~/erlang && ./Install ~/erlang

## RabbitMQ
    export TARGET_DIR=~/rabbitmq
    export SBIN_DIR=~/rabbitmq/sbin
    export MAN_DIR=~/rabbitmq/man
    export MNESIA_DIR=~/rabbitmq/var
    make && make install

## Celery
    pip install Celery

## redis
    wget http://redis.googlecode.com/files/redis-2.6.9.tar.gz
    make
    make PREFIX=~/redis install
    pip install redis

## amqplib guppy python-geohash mock==0.7.2
    pip install amqplib guppy python-geohash mock==0.7.2

## Django
    pip install django

## h5py
    wget http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.10-patch1.tar.gz
    ./configure --prefix=$HOME/hdf5
    make
    make install
    export HDF5_DIR=$HOME/hdf5
    pip install h5py

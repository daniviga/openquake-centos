__work in progress, not ready yet__

Login as unprivileged user: i.e. "openquake"

## Build System
    sudo yum install bzip2 wget gcc gcc-c++.x86_64 compat-gcc-34-c++.x86_64 openssl-devel.x86_64 zlib*.x86_64 make.x86_64 ncurses-devel.x86_64 bzip2-devel.x86_64 readline-devel.x86_64 zip.x86_64 unzip.x86_64 nc.x86_64 curl-devel.x86_64 expat-devel.x86_64 gettext.x86_64 gettext-devel.x86_64 xmlto.x86_64

## Git
    wget https://github.com/git/git/archive/v1.8.1.3.tar.gz
    make prefix=$HOME/local install

## Python 2.7
    http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tgz
    ./configure --prefix=$HOME/local --enable-shared
    make
    make install

## setuptools
    wget http://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg
    /bin/bash setuptools-0.6c11-py2.7.egg

## pip
    wget http://pypi.python.org/packages/source/p/pip/pip-1.2.1.tar.gz
    python2.7 setup.py install
    
## numpy & scipy deps.
    sudo yum install -y gcc-gfortran.x86_64 compat-gcc-34-g77.x86_64 libgfortran.x86_64
    sudo yum install blas*.x86_64 lapack*.x86_64
    cp /usr/lib64/libblas.so /usr/lib64/liblapack.so ~/local/lib64

## numpy
    pip install numpy

## scipy
    pip install scipy

## erlang
    sudo yum install libxslt.x86_64 libxslt-devel.x86_64 unixODBC-devel.x86_64
    wget http://www.erlang.org/download/otp_src_R15B03-1.tar.gz
    ./configure
    make
    make RELEASE_ROOT=$HOME/local/erlang release
    cd ~/local/erlang && ./Install ~/local/erlang
    cd bin && for a in $(ls); do ln -s -t ~/local/bin ../erlang/bin/$a; done

## RabbitMQ
    wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.0.2/rabbitmq-server-3.0.2.tar.gz
    export TARGET_DIR=~/local
    export SBIN_DIR=~/local/sbin
    export MAN_DIR=~/local/share/man/
    export MNESIA_DIR=~/local/var/rabbitmq
    make && make install

## Celery
    pip install Celery

## redis
    wget http://redis.googlecode.com/files/redis-2.6.9.tar.gz
    make
    make PREFIX=$HOME/local install
    pip install redis

## pip various dep
    pip install amqplib guppy python-geohash mock==0.7.2 Shapely lxml

## Django
    pip install django

## h5py
    wget http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.10-patch1.tar.gz
    ./configure --prefix=$HOME/local
    make
    make install
    HDF5_DIR=$HOME/local pip install h5py
    
## Postgres
    wget http://ftp.postgresql.org/pub/source/v9.2.3/postgresql-9.2.3.tar.bz2
    ./configure --prefix=$HOME/local --with-python
    make
    make install
    pip install psycopg2
    
## Swig _(Geos dep.)_
    wget http://prdownloads.sourceforge.net/swig/swig-2.0.9.tar.gz
    ./configure --prefix=$HOME/local --without-alllang --with-python
    make
    make install
    
## Geos _(PostGIS dep.)_
    http://download.osgeo.org/geos/geos-3.3.7.tar.bz2
    ./configure --prefix=$HOME/local --enable-python
    make
    make install
    
## proj.4 _(PostGIS dep.)_
    http://download.osgeo.org/proj/proj-4.8.0.tar.gz
    ./configure --prefix=$HOME/local
    make
    make install
    
## GDAL _(PostGIS dep.)_
    wget http://download.osgeo.org/gdal/gdal-1.9.2.tar.gz
    ./configure --prefix=$HOME/local --with-python --with-pg --with-hdf5=$HOME/local --with-geos --with-static-proj4
    make
    make install
    
## PostGIS
    wget http://download.osgeo.org/postgis/source/postgis-2.0.2.tar.gz
    ./configure --prefix=$HOME/local --with-projdir=$HOME/local
    make
    make install
    
 - - -
## Get OpenQuake
    mkdir ~/openquake; cd ~/openquake
    git clone git://github.com/gem/openquake.git
    git clone git://github.com/gem/oq-engine.git
    git clone git://github.com/gem/oq-risklib.git
    git clone git://github.com/gem/oq-nrmllib.git
    git clone git://github.com/gem/oq-hazardlib.git

    cd openquake/oq-engine
    echo "GEOS_LIBRARY_PATH = '$HOME/local/lib/libgeos_c.so'" >> openquake/engine/settings.py
    bin/openquake
    
    /home/openquake/openquake/oq-hazardlib/openquake/hazardlib/geo/geodetic.py:437: RuntimeWarning: geodetic speedups are not available
      warnings.warn("geodetic speedups are not available", RuntimeWarning)
    /home/openquake/openquake/oq-hazardlib/openquake/hazardlib/geo/utils.py:353: RuntimeWarning: geoutils speedups are not available
      warnings.warn("geoutils speedups are not available", RuntimeWarning)

    usage: openquake [-h] [--version] [--force-inputs] [--log-file LOG_FILE]
                     [--log-level {debug,info,progress,warn,error,critical}]
                     [--no-distribute] [--run-hazard CONFIG_FILE]
                     [--list-hazard-calculations]
                     [--list-hazard-outputs HAZARD_CALCULATION_ID]
                     [--export-hazard OUTPUT_ID TARGET_DIR]
                     [--run-risk CONFIG_FILE] [--hazard-output-id HAZARD_OUTPUT]
                     [--hazard-calculation-id HAZARD_CALCULATION_ID]
                     [--list-risk-calculations]
                     [--list-risk-outputs RISK_CALCULATION_ID]
                     [--export-risk OUTPUT_ID TARGET_DIR] [--exports {xml}]

## TODO

*   Set up OpenQuake (DB...)
*   Investigate "RuntimeWarning: geodetic speedups are not available"

_ver. 2_

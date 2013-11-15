#!/bin/bash

set -e
set -o pipefail

function run_tests {
    cd ~/openquake/oq-engine
    nosetests -v --with-xunit --with-coverage --cover-package=openquake.engine --with-doctest -x tests/

    nosetests  -a 'qa,hazard,classical' -v --with-xunit --xunit-file=xunit-qa-hazard-classical.xml
    nosetests  -a 'qa,hazard,event_based' -v --with-xunit --xunit-file=xunit-qa-hazard-event-based.xml
    nosetests  -a 'qa,hazard,disagg' -v --with-xunit --xunit-file=xunit-qa-hazard-disagg.xml
    nosetests  -a 'qa,hazard,scenario' -v --with-xunit --xunit-file=xunit-qa-hazard-scenario.xml

    nosetests  -a 'qa,risk,classical' -v --with-xunit --xunit-file=xunit-qa-risk-classical.xml
    nosetests  -a 'qa,risk,event_based' -v --with-xunit --xunit-file=xunit-qa-risk-event-based.xml
    nosetests  -a 'qa,risk,classical_bcr' -v --with-xunit --xunit-file=xunit-qa-risk-classical-bcr.xml
    nosetests  -a 'qa,risk,event_based_bcr' -v --with-xunit --xunit-file=xunit-qa-risk-event-based-bcr.xml
    nosetests  -a 'qa,risk,scenario_damage' -v --with-xunit --xunit-file=xunit-qa-risk-scenario-damage.xml
    nosetests  -a 'qa,risk,scenario' -v --with-xunit --xunit-file=xunit-qa-risk-scenario.xml

    python-coverage xml --include="openquake/*"
}

function setup_env {
    ## Create base folders
    cd ~
    mkdir bin local log openquake src
    cat <<EOF >> ~/.bash_profile
PATH=$HOME/openquake/oq-engine/bin:$HOME/local/bin:$HOME/local/sbin:$PATH:$HOME/bin
LD_LIBRARY_PATH=$HOME/local/lib:$HOME/local/lib64
CPATH=$HOME/local/include

PYTHONPATH=.:$HOME/openquake/oq-engine:$HOME/openquake/oq-hazardlib:$HOME/openquake/oq-nrmllib:$HOME/openquake/oq-risklib
PGDATA=$HOME/local/var/postgresql

export PATH
export LD_LIBRARY_PATH
export CPATH

export PYTHONPATH
export PGDATA
EOF

    cat <<EOF >> ~/.screenrc
# make the shell in every window as your login shell
shell -$SHELL
EOF
    . ~/.bash_profile
}


## User environment
setup_env

## Build System (CentOS 6)
sudo yum install -y bzip2 wget gcc gcc-c++.x86_64 compat-gcc-34-c++.x86_64 openssl-devel.x86_64 zlib*.x86_64 make.x86_64 ncurses-devel.x86_64 bzip2-devel.x86_64 readline-devel.x86_64 zip.x86_64 unzip.x86_64 nc.x86_64 libcurl-devel.x86_64 expat-devel.x86_64 gettext.x86_64 gettext-devel.x86_64 xmlto.x86_64 perl-ExtUtils-MakeMaker.x86_64 pcre.x86_64 pcre-devel.x86_64 patch.x86_64 gcc-gfortran.x86_64 compat-gcc-34-g77.x86_64 libgfortran.x86_64 blas*.x86_64 lapack*.x86_64 libxslt.x86_64 libxslt-devel.x86_64 unixODBC-devel.x86_64

## Git
cd ~/src
wget https://git-core.googlecode.com/files/git-1.8.4.3.tar.gz
tar xzf git-1.8.4.3.tar.gz
cd git-1.8.4.3
make prefix=$HOME/local install

## Python 2.7
cd ~/src
wget http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tgz
tar xzf Python-2.7.6.tgz
cd Python-2.7.6
./configure --prefix=$HOME/local --enable-shared
make
make install

## setuptools
cd ~/src
wget --no-check-certificate http://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg
/bin/bash setuptools-0.6c11-py2.7.egg

## pip
cd ~/src
wget --no-check-certificate http://pypi.python.org/packages/source/p/pip/pip-1.4.1.tar.gz
tar xzf pip-1.4.1.tar.gz
cd pip-1.4.1
python2.7 setup.py install

## numpy & scipy deps.
cp /usr/lib64/libblas.so /usr/lib64/liblapack.so ~/local/lib64

## numpy (1.6.2)
pip install numpy==1.6.2

## scipy
pip install scipy==0.13.0

## erlang _(RabbitMQ dep.)_
cd ~/src
wget http://www.erlang.org/download/otp_src_R16B02.tar.gz
tar xzf otp_src_R16B02.tar.gz
cd otp_src_R16B02
./configure
make
make RELEASE_ROOT=$HOME/local/erlang release
cd ~/local/erlang && ./Install -minimal ~/local/erlang
cd bin && for a in $(ls); do ln -s -t ~/local/bin ../erlang/bin/$a; done

## RabbitMQ
cd ~/src
wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.0.2/rabbitmq-server-3.0.2.tar.gz
tar xzf rabbitmq-server-3.0.2.tar.gz
cd rabbitmq-server-3.0.2
export TARGET_DIR=~/local
export SBIN_DIR=~/local/sbin
export MAN_DIR=~/local/share/man/
export MNESIA_DIR=~/local/var/rabbitmq
make && make install

## pip various dep
pip install amqplib==1.0.2 python-geohash==0.8.4 mock==0.7.2 lxml==2.3.2 psutil==1.1.3 nose==1.3.0

## Celery
pip install Celery==2.5.5

## redis
cd ~/src
wget http://download.redis.io/releases/redis-2.6.16.tar.gz
tar xzf redis-2.6.16.tar.gz
cd redis-2.6.16
make
make PREFIX=$HOME/local install
pip install redis

## Django
pip install django==1.4.9

## Postgres (9.1)
cd ~/src
wget http://ftp.postgresql.org/pub/source/v9.1.10/postgresql-9.1.10.tar.gz
tar xzf postgresql-9.1.10.tar.gz
cd postgresql-9.1.10
./configure --prefix=$HOME/local --with-python
make
make install

## Psycopg2
pip install psycopg2==2.5.1

## Swig _(Geos dep.)_
cd ~/src
wget http://prdownloads.sourceforge.net/swig/swig-2.0.9.tar.gz
tar xzf swig-2.0.9.tar.gz
cd swig-2.0.9
./configure --prefix=$HOME/local --without-alllang --with-python
make
make install

## Geos _(PostGIS dep.)_
cd ~/src
wget http://download.osgeo.org/geos/geos-3.3.7.tar.bz2
tar xjf geos-3.3.7.tar.bz2
cd geos-3.3.7
CFLAGS="-m64" CPPFLAGS="-m64" CXXFLAGS="-m64" LDFLAGS="-m64" FFLAGS="-m64" LDFLAGS="-L/usr/lib64/" ./configure --prefix=$HOME/local --enable-python
make
make install

## proj.4 _(PostGIS dep.)_
cd ~/src
wget http://download.osgeo.org/proj/proj-4.8.0.tar.gz
tar xzf proj-4.8.0.tar.gz
cd proj-4.8.0
./configure --prefix=$HOME/local
make
make install

## GDAL _(PostGIS dep.)_
cd ~/src
wget http://download.osgeo.org/gdal/gdal-1.9.2.tar.gz
tar xzf gdal-1.9.2.tar.gz
cd gdal-1.9.2
./configure --prefix=$HOME/local --with-python --with-pg --with-geos --with-static-proj5
make
make install

## Shapely (1.2.14)
pip install Shapely==1.2.14

## PostGIS (1.5.8)
cd ~/src
wget http://download.osgeo.org/postgis/source/postgis-1.5.8.tar.gz
tar xzf postgis-1.5.8.tar.gz
cd postgis-1.5.8
./configure --prefix=$HOME/local --with-projdir=$HOME/local
make
make install
cp $HOME/src/postgis-1.5.8/doc/postgis_comments.sql $HOME/local/share/postgresql/contrib/postgis-1.5

## Get useful stuff
cd ~/src
git clone https://github.com/daniviga/openquake-centos5.git
cp -v ~/src/openquake-centos5/bin/* ~/bin/
chmod +x ~/bin/*


## Get OpenQuake
cd ~/openquake; git clone https://github.com/gem/oq-engine.git
cd ~/openquake/oq-engine; git reset --hard e62244f85173a69ba880fe94d0b53120231478ee
cd ~/openquake; git clone httos://github.com/gem/oq-hazardlib.git
cd ~/openquake/oq-hazardlib; git reset --hard b8f82fe629d6cf4315a919ba8b76165f6a2517b3
cd ~/openquake; git clone https://github.com/gem/oq-nrmllib.git
cd ~/openquake/oq-nrmllib; git reset --hard ec9b0f8796a8e4a00f59a7d11c9b3889588058ea
cd ~/openquake; git clone https://github.com/gem/oq-risklib.git
cd ~/openquake/oq-risklib; git reset --hard 1a429d09a163641655b8a83d250407c7033d3eaf

## Setup OpenQuake
cd ~/openquake/oq-engine
echo "GEOS_LIBRARY_PATH = '$HOME/local/lib/libgeos_c.so'" >> openquake/engine/settings.py

## Build hazardlib speedups
cd ~/openquake/oq-hazardlib
python setup.py build_ext

### DB setup
~/local/bin/initdb
~/bin/start-postgresql
cd ~/openquake/oq-engine/bin
patch -p0 < ~/src/openquake-centos5/oq-patches/create_oq_schema.patch
./create_oq_schema --db-user=openquaker --db-name=openquake --schema-path=$HOME/openquake/oq-engine/openquake/engine/db/schema --yes

### Start services
~/bin/stop-all
sleep 2
~/bin/start-all

echo "DONE!"

### Run a real computation test
#cd ~/openquake/oq-engine
#bin/openquake --rh=demos/hazard/SimpleFaultSourceClassicalPSHA/job.ini
#
### Extra tools
#### htop
#cd ~/src
#wget http://downloads.sourceforge.net/project/htop/htop/1.0.2/htop-1.0.2.tar.gz
#tar xzf htop-1.0.2.tar.gz
#cd htop-1.0.2
#./configure --prefix=$HOME/local
#make
#make install
#htop

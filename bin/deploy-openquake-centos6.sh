#!/bin/bash

# CentOS/RHEL OpenQuake deployment script
# Copyright (C) 2013-2014, Daniele Viganò (daniele@vigano.me), GEM Foundation
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

function pm {
    echo -e "\n### $1 ###\n"
}


## User environment

pm 'Environment setup'
setup_env

## Build System (CentOS 6)
pm 'Installing pre-requisites'
sudo yum install -y bzip2 wget gcc gcc-c++.x86_64 compat-gcc-34-c++.x86_64 openssl-devel.x86_64 zlib*.x86_64 make.x86_64 ncurses-devel.x86_64 bzip2-devel.x86_64 readline-devel.x86_64 zip.x86_64 unzip.x86_64 nc.x86_64 libcurl-devel.x86_64 expat-devel.x86_64 gettext.x86_64 gettext-devel.x86_64 xmlto.x86_64 perl-ExtUtils-MakeMaker.x86_64 pcre.x86_64 pcre-devel.x86_64 patch.x86_64 gcc-gfortran.x86_64 compat-gcc-34-g77.x86_64 libgfortran.x86_64 blas*.x86_64 lapack*.x86_64 libxslt.x86_64 libxslt-devel.x86_64 unixODBC-devel.x86_64

## Git
pm 'Installing GIT'
cd ~/src
wget https://git-core.googlecode.com/files/git-1.8.4.3.tar.gz
tar xzf git-1.8.4.3.tar.gz
cd git-1.8.4.3
make prefix=$HOME/local install

## Python 2.7
pm 'Installing Python'
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
pm 'Installing NumPy'
pip install numpy==1.6.2

## scipy
pm 'Installing SciPy'
pip install scipy==0.13.0

## pip various dep
pip install amqplib==1.0.2 python-geohash==0.8.4 mock==0.7.2 lxml==2.3.2 psutil==1.1.3 nose==1.3.0

## Celery
pip install Celery==2.5.5

## Django
pip install django==1.4.9

## erlang _(RabbitMQ dep.)_
pm 'Installing Erlang'
cd ~/src
wget http://www.erlang.org/download/otp_src_R14B04.tar.gz
tar xzf otp_src_R14B04.tar.gz
cd otp_src_R14B04
./configure
make
make RELEASE_ROOT=$HOME/local/erlang release
cd ~/local/erlang && ./Install -minimal ~/local/erlang
cd bin && for a in $(ls); do ln -s -t ~/local/bin ../erlang/bin/$a; done

## RabbitMQ
pm 'Installing RabbitMQ'
cd ~/src
wget http://www.rabbitmq.com/releases/rabbitmq-server/v2.8.7/rabbitmq-server-2.8.7.tar.gz
tar xzf rabbitmq-server-2.8.7.tar.gz
cd rabbitmq-server-2.8.7
export TARGET_DIR=~/local
export SBIN_DIR=~/local/sbin
export MAN_DIR=~/local/share/man/
export MNESIA_DIR=~/local/var/rabbitmq
make && make install

## Postgres (9.1)
pm 'Installing PostgreSQL'
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
pm 'Installing OpenQuake'
cd ~/src
git clone https://github.com/daniviga/openquake-centos.git
cp -v ~/src/openquake-centos/bin/* ~/bin/
chmod +x ~/bin/*


## Get OpenQuake
cd ~/openquake; git clone https://github.com/gem/oq-engine.git
cd ~/openquake/oq-engine; git reset --hard ffe5fbc0c5682653bcb9f2f88778ed0cf5f70c3e
cd ~/openquake; git clone https://github.com/gem/oq-hazardlib.git
cd ~/openquake/oq-hazardlib; git reset --hard 48c310974327a42fbd9c635ad08cfc797ba1ac9c
cd ~/openquake; git clone https://github.com/gem/oq-nrmllib.git
cd ~/openquake/oq-nrmllib; git reset --hard 2c08215ca4ec163923fd9549e35f01b0c08e0c46
cd ~/openquake; git clone https://github.com/gem/oq-risklib.git
cd ~/openquake/oq-risklib; git reset --hard 7c5af4a979cc234f406124dbebbcecea24d26452

## Setup OpenQuake
cd ~/openquake/oq-engine
echo "GEOS_LIBRARY_PATH = '$HOME/local/lib/libgeos_c.so'" >> openquake/engine/settings.py

## Build hazardlib speedups
cd ~/openquake/oq-hazardlib
python setup.py build_ext
cd openquake/hazardlib/geo
ln -s ../../../build/lib.*/openquake/hazardlib/geo/*.so .

### DB setup
~/local/bin/initdb
~/bin/start-postgresql
cd ~/openquake/oq-engine/bin
patch -p0 < ~/src/openquake-centos/oq-patches/create_oq_schema.patch
./create_oq_schema --db-user=openquaker --db-name=openquake --schema-path=$HOME/openquake/oq-engine/openquake/engine/db/schema --yes

### Start services
~/bin/stop-all
sleep 2
~/bin/start-all

pm 'DONE!'
pm 'Now, please run source ~/.bash_profile'

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

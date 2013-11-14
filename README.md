__work in progress__ tested with OpenQuake Engine (oq-engine) master commit __e62244f85173a69ba880fe94d0b53120231478ee__

## User environment

* Login as unprivileged user: i.e. "openquaker". __DO NOT USE "openquake"!__
* Move, or merge __bash\_profile__ from this GIT repo to __~/.bash\_profile__
* If you want to use _screen_ it's highly recommended to move (or merge) __screenrc__ from this GIT repo to __~/.screenrc__
* A text editor is obviously needed

### Create base folders
    cd ~
    mkdir bin local log openquake src


## Build System (CentOS 5, needs sudo or root)
    sudo yum install bzip2 wget gcc gcc-c++.x86_64 compat-gcc-34-c++.x86_64 openssl-devel.x86_64 zlib*.x86_64 make.x86_64 ncurses-devel.x86_64 bzip2-devel.x86_64 readline-devel.x86_64 zip.x86_64 unzip.x86_64 nc.x86_64 curl-devel.x86_64 expat-devel.x86_64 gettext.x86_64 gettext-devel.x86_64 xmlto.x86_64 patch.x86_64 gcc-gfortran.x86_64 compat-gcc-34-g77.x86_64 libgfortran.x86_64 blas*.x86_64 lapack*.x86_64 libxslt.x86_64 libxslt-devel.x86_64 unixODBC-devel.x86_64

## Build System (CentOS 6, needs sudo or root)
    sudo yum install bzip2 wget gcc gcc-c++.x86_64 compat-gcc-34-c++.x86_64 openssl-devel.x86_64 zlib*.x86_64 make.x86_64 ncurses-devel.x86_64 bzip2-devel.x86_64 readline-devel.x86_64 zip.x86_64 unzip.x86_64 nc.x86_64 libcurl-devel.x86_64 expat-devel.x86_64 gettext.x86_64 gettext-devel.x86_64 xmlto.x86_64 perl-ExtUtils-MakeMaker.x86_64 pcre.x86_64 pcre-devel.x86_64 patch.x86_64 gcc-gfortran.x86_64 compat-gcc-34-g77.x86_64 libgfortran.x86_64 blas*.x86_64 lapack*.x86_64 libxslt.x86_64 libxslt-devel.x86_64 unixODBC-devel.x86_64

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
    wget http://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg
    /bin/bash setuptools-0.6c11-py2.7.egg

## pip
    cd ~/src
    wget http://pypi.python.org/packages/source/p/pip/pip-1.4.1.tar.gz
    tar pip-1.4.1.tar.gz
    cd pip-1.4.1
    python2.7 setup.py install

## numpy & scipy deps.
The best way is to use, for libblas and liblapack, the .so provided by offical RPMs. Recompiling both requires too much effort.

    cp /usr/lib64/libblas.so /usr/lib64/liblapack.so ~/local/lib64

## numpy (1.6.2)
With versions > 1.6.0 lot of tasks (both on the engine and the hazardlib) fail.

    pip install numpy==1.6.2

## scipy
The latest version as writing is 0.13.0 and all tests are green.

    pip install scipy==0.13.0

## erlang _(RabbitMQ dep.)_
    cd ~/src
    wget http://www.erlang.org/download/otp_src_R16B02.tar.gz
    tar xzf otp_src_R16B02.tar.gz
    cd otp_src_R16B02
    ./configure
    make
    make RELEASE_ROOT=$HOME/local/erlang release
    cd ~/local/erlang && ./Install ~/local/erlang
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
mock needs to be version 0.7.2 and lxml needs 2.3.2

    pip install amqplib==1.0.2 python-geohash==0.8.4 mock==0.7.2 lxml==2.3.2 psutil==1.1.3

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

## Postgres (9.1) and psycopg2
__PostGIS 1.5 is required and is incompatible with PostgreSQL 9.2, so PostgreSQL 9.1 is used instead__
see http://trac.osgeo.org/postgis/wiki/UsersWikiPostgreSQLPostGIS

    cd ~/src
    wget http://ftp.postgresql.org/pub/source/v9.1.10/postgresql-9.1.10.tar.gz
    tar xzf postgresql-9.1.10.tar.gz
    cd postgresql-9.1.10
    ./configure --prefix=$HOME/local --with-python
    make
    make install

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
On CentOS 6 there's a compiler bug: http://trac.osgeo.org/geos/ticket/377

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
Shapely 1.2.17 does not work: wkt.ReadingError method no more available.
Is better to install Shapely after Geos so it can use Geos speedups

    pip install Shapely==1.2.14

## PostGIS (1.5.8)
PostGIS 2.0.2 does not work with current OpenQuake, because as mentioned in http://www.postgis.org/docs/ST\_GeomFromText.html:
> Changed: 2.0.0 In prior versions of PostGIS ST\_GeomFromText('GEOMETRYCOLLECTION(EMPTY)') was allowed.
> This is now illegal in PostGIS 2.0.0 to better conform with SQL/MM standards.
> This should now be written as ST\_GeomFromText('GEOMETRYCOLLECTION EMPTY')

    cd ~/src
    wget http://download.osgeo.org/postgis/source/postgis-1.5.8.tar.gz
    tar xzf postgis-1.5.8.tar.gz
    cd postgis-1.5.8
    ./configure --prefix=$HOME/local --with-projdir=$HOME/local
    make
    make install

    cp $HOME/src/postgis-1.5.8/doc/postgis_comments.sql $HOME/local/share/postgresql/contrib/postgis-1.5

## Get OpenQuake
    mkdir ~/openquake; cd ~/openquake
    git clone https://github.com/gem/oq-engine.git
    git clone https://github.com/gem/oq-risklib.git
    git clone https://github.com/gem/oq-nrmllib.git
    git clone httos://github.com/gem/oq-hazardlib.git

## Setup OpenQuake

    cd ~/openquake/oq-engine
    echo "GEOS_LIBRARY_PATH = '$HOME/local/lib/libgeos_c.so'" >> openquake/engine/settings.py

## Build hazardlib speedups

    cd ~/openquake/oq-hazardlib
    python setup.py build_ext

## Run OpenQuake

    cd ~/openquake/oq-engine
    ./bin/openquake

    usage: openquake [-h] [--version] [--log-file LOG_FILE]
                     [--log-level {debug,info,progress,warn,error,critical}]
                     [--no-distribute] [--list-inputs INPUT_TYPE] [--yes]
                     [--config-file CONFIG_FILE] [--run-hazard CONFIG_FILE]
                     [--list-hazard-calculations]
                     [--list-hazard-outputs HAZARD_CALCULATION_ID]
                     [--export-hazard OUTPUT_ID TARGET_DIR]
                     [--delete-hazard-calculation HAZARD_CALCULATION_ID]
                     [--run-risk CONFIG_FILE] [--hazard-output-id HAZARD_OUTPUT]
                     [--hazard-calculation-id HAZARD_CALCULATION_ID]
                     [--list-risk-calculations]
                     [--list-risk-outputs RISK_CALCULATION_ID]
                     [--export-risk OUTPUT_ID TARGET_DIR]
                     [--delete-risk-calculation RISK_CALCULATION_ID]
                     [--exports {xml}] [--export-type {xml,geojson}]
                     [--load-gmf GMF_FILE] [--load-curve CURVE_FILE]
                     [--list-imported-outputs]
                     [--optimize-source-model INPUT_FILE AREA_DISCRETIZATION OUTPUT_FILE]

## DB setup
    ~/local/bin/initdb
    ~/bin/start-postgresql

Apply 'create\_oq\_schema.patch' patch (supposing __/home/openquaker__ as homedir) then

    cd ~/openquake/oq-engine && ./bin/create_oq_schema --db-user=openquaker --db-name=openquake --schema-path=$HOME/openquake/oq-engine/openquake/engine/db/schema

## Start services

    killall postgres
    ~/bin/start-postgresql
    ~/bin/start-rabbitmq
    ~/bin/start-celery
    ~/bin/start-redis

## Run some tests

    pip install nose==1.3.0
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


## Run a real computation test
    cd ~/openquake/oq-engine
    bin/openquake --rh=demos/hazard/SimpleFaultSourceClassicalPSHA/job.ini

## Extra tools
### htop
    cd ~/src
    wget http://downloads.sourceforge.net/project/htop/htop/1.0.2/htop-1.0.2.tar.gz
    tar xzf htop-1.0.2.tar.gz
    cd htop-1.0.2
    ./configure --prefix=$HOME/local
    make
    make install
    htop

## TODO
*   Check system lib dependencies
*   Hardering PostgreSQL configuration

_how to ver. 4.0_

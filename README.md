__work in progress__ tested with OpenQuake Engine commits:

```
oq-engine:    e62244f85173a69ba880fe94d0b53120231478ee
oq-hazardlib: b8f82fe629d6cf4315a919ba8b76165f6a2517b3
oq-nrmllib:   ec9b0f8796a8e4a00f59a7d11c9b3889588058ea
oq-risklib:   1a429d09a163641655b8a83d250407c7033d3eaf
```

## Automatic deploy

### User environment

* Login as unprivileged user: i.e. "openquaker". __DO NOT USE "openquake"!__
* Requirements are: ```sudo``` and ```wget```

### Deploy script

As normal user (see above) run:

```bash
wget -O- https://raw.githubusercontent.com/daniviga/openquake-centos/master/bin/deploy-openquake-centos6.sh | bash | tee install.log
```


## Manual deploy

### User environment

* Login as unprivileged user: i.e. "openquaker". __DO NOT USE "openquake"!__
* Move, or merge __bash\_profile__ from this GIT repo to __~/.bash\_profile__
* If you want to use _screen_ it's highly recommended to move (or merge) __screenrc__ from this GIT repo to __~/.screenrc__
* A text editor is obviously needed

### Create base folders
```bash
cd ~
mkdir bin local log openquake src
```

## Build System (CentOS 5, needs sudo or root)
```bash
sudo yum install bzip2 wget gcc gcc-c++.x86_64 compat-gcc-34-c++.x86_64 openssl-devel.x86_64 zlib*.x86_64 make.x86_64 ncurses-devel.x86_64 bzip2-devel.x86_64 readline-devel.x86_64 zip.x86_64 unzip.x86_64 nc.x86_64 curl-devel.x86_64 expat-devel.x86_64 gettext.x86_64 gettext-devel.x86_64 xmlto.x86_64 patch.x86_64 gcc-gfortran.x86_64 compat-gcc-34-g77.x86_64 libgfortran.x86_64 blas*.x86_64 lapack*.x86_64 libxslt.x86_64 libxslt-devel.x86_64 unixODBC-devel.x86_64
```

## Build System (CentOS 6, needs sudo or root)
```bash
sudo yum install bzip2 wget gcc gcc-c++.x86_64 compat-gcc-34-c++.x86_64 openssl-devel.x86_64 zlib*.x86_64 make.x86_64 ncurses-devel.x86_64 bzip2-devel.x86_64 readline-devel.x86_64 zip.x86_64 unzip.x86_64 nc.x86_64 libcurl-devel.x86_64 expat-devel.x86_64 gettext.x86_64 gettext-devel.x86_64 xmlto.x86_64 perl-ExtUtils-MakeMaker.x86_64 pcre.x86_64 pcre-devel.x86_64 patch.x86_64 gcc-gfortran.x86_64 compat-gcc-34-g77.x86_64 libgfortran.x86_64 blas*.x86_64 lapack*.x86_64 libxslt.x86_64 libxslt-devel.x86_64 unixODBC-devel.x86_64
```

## Git
```bash
cd ~/src
wget https://git-core.googlecode.com/files/git-1.8.4.3.tar.gz
tar xzf git-1.8.4.3.tar.gz
cd git-1.8.4.3
make prefix=$HOME/local install
```

## Python 2.7
```bash
cd ~/src
wget http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tgz
tar xzf Python-2.7.6.tgz
cd Python-2.7.6
./configure --prefix=$HOME/local --enable-shared
make
make install
```

## setuptools
```bash
cd ~/src
wget --no-check-certificate http://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg
/bin/bash setuptools-0.6c11-py2.7.egg
```

## pip
```bash
cd ~/src
wget --no-check-certificate http://pypi.python.org/packages/source/p/pip/pip-1.4.1.tar.gz
tar xzf pip-1.4.1.tar.gz
cd pip-1.4.1
python2.7 setup.py install
```

## numpy & scipy deps.
The best way is to use, for libblas and liblapack, the .so provided by offical RPMs. Recompiling both requires too much effort.

```bash
cp /usr/lib64/libblas.so /usr/lib64/liblapack.so ~/local/lib64
```

## numpy (1.6.2)
With versions > 1.6.0 lot of tasks (both on the engine and the hazardlib) fail.

```bash
pip install numpy==1.6.2
```

## scipy
The latest version as writing is 0.13.0 and all tests are green.

```bash
pip install scipy==0.13.0
```

## erlang _(RabbitMQ dep.)_
```bash
cd ~/src
wget http://www.erlang.org/download/otp_src_R14B04.tar.gz
tar xzf otp_src_R14B04.tar.gz
cd otp_src_R14B04
./configure
make
make RELEASE_ROOT=$HOME/local/erlang release
cd ~/local/erlang && ./Install -minimal ~/local/erlang
cd bin && for a in $(ls); do ln -s -t ~/local/bin ../erlang/bin/$a; done
```

## RabbitMQ
```bash
cd ~/src
wget http://www.rabbitmq.com/releases/rabbitmq-server/v2.8.7/rabbitmq-server-2.8.7.tar.gz
tar xzf rabbitmq-server-2.8.7.tar.gz
cd rabbitmq-server-2.8.7
export TARGET_DIR=~/local
export SBIN_DIR=~/local/sbin
export MAN_DIR=~/local/share/man/
export MNESIA_DIR=~/local/var/rabbitmq
make && make install
```

## pip various dep
mock needs to be version 0.7.2 and lxml needs 2.3.2

```bash
pip install amqplib==1.0.2 python-geohash==0.8.4 mock==0.7.2 lxml==2.3.2 psutil==1.1.3
```

## Celery
```bash
pip install Celery==2.5.5
```

## Django
```bash
pip install django==1.4.9
```

## Postgres (9.1) and psycopg2
__PostGIS 1.5 is required and is incompatible with PostgreSQL 9.2, so PostgreSQL 9.1 is used instead__
see http://trac.osgeo.org/postgis/wiki/UsersWikiPostgreSQLPostGIS

```bash
cd ~/src
wget http://ftp.postgresql.org/pub/source/v9.1.10/postgresql-9.1.10.tar.gz
tar xzf postgresql-9.1.10.tar.gz
cd postgresql-9.1.10
./configure --prefix=$HOME/local --with-python
make
make install
```
```bash
pip install psycopg2==2.5.1
```

## Swig _(Geos dep.)_
```bash
cd ~/src
wget http://prdownloads.sourceforge.net/swig/swig-2.0.9.tar.gz
tar xzf swig-2.0.9.tar.gz
cd swig-2.0.9
./configure --prefix=$HOME/local --without-alllang --with-python
make
make install
```

## Geos _(PostGIS dep.)_
On CentOS 6 there's a compiler bug: http://trac.osgeo.org/geos/ticket/377

```bash
cd ~/src
wget http://download.osgeo.org/geos/geos-3.3.7.tar.bz2
tar xjf geos-3.3.7.tar.bz2
cd geos-3.3.7
CFLAGS="-m64" CPPFLAGS="-m64" CXXFLAGS="-m64" LDFLAGS="-m64" FFLAGS="-m64" LDFLAGS="-L/usr/lib64/" ./configure --prefix=$HOME/local --enable-python
make
make install
```

## proj.4 _(PostGIS dep.)_
```bash
cd ~/src
wget http://download.osgeo.org/proj/proj-4.8.0.tar.gz
tar xzf proj-4.8.0.tar.gz
cd proj-4.8.0
./configure --prefix=$HOME/local
make
make install
```

## GDAL _(PostGIS dep.)_
```bash
cd ~/src
wget http://download.osgeo.org/gdal/gdal-1.9.2.tar.gz
tar xzf gdal-1.9.2.tar.gz
cd gdal-1.9.2
./configure --prefix=$HOME/local --with-python --with-pg --with-geos --with-static-proj5
make
make install
```

## Shapely (1.2.14)
Shapely 1.2.17 does not work: wkt.ReadingError method no more available.
Is better to install Shapely after Geos so it can use Geos speedups

```bash
pip install Shapely==1.2.14
```

## PostGIS (1.5.8)
PostGIS 2.0.2 does not work with current OpenQuake, because as mentioned in http://www.postgis.org/docs/ST\_GeomFromText.html:
> Changed: 2.0.0 In prior versions of PostGIS ST\_GeomFromText('GEOMETRYCOLLECTION(EMPTY)') was allowed.
> This is now illegal in PostGIS 2.0.0 to better conform with SQL/MM standards.
> This should now be written as ST\_GeomFromText('GEOMETRYCOLLECTION EMPTY')

```bash
cd ~/src
wget http://download.osgeo.org/postgis/source/postgis-1.5.8.tar.gz
tar xzf postgis-1.5.8.tar.gz
cd postgis-1.5.8
./configure --prefix=$HOME/local --with-projdir=$HOME/local
make
make install
```
```bash
cp $HOME/src/postgis-1.5.8/doc/postgis_comments.sql $HOME/local/share/postgresql/contrib/postgis-1.5
```

## Get OpenQuake
```bash
mkdir ~/openquake
```
```bash
cd ~/openquake; git clone https://github.com/gem/oq-engine.git
cd ~/openquake/oq-engine; git reset --hard ffe5fbc0c5682653bcb9f2f88778ed0cf5f70c3e
```
```bash
cd ~/openquake; git clone https://github.com/gem/oq-hazardlib.git
cd ~/openquake/oq-hazardlib; git reset --hard 48c310974327a42fbd9c635ad08cfc797ba1ac9c
```
```bash
cd ~/openquake; git clone https://github.com/gem/oq-nrmllib.git
cd ~/openquake/oq-nrmllib; git reset --hard 2c08215ca4ec163923fd9549e35f01b0c08e0c46
```
```bash
cd ~/openquake; git clone https://github.com/gem/oq-risklib.git
cd ~/openquake/oq-risklib; git reset --hard 7c5af4a979cc234f406124dbebbcecea24d26452
```

## Setup OpenQuake

```bash
cd ~/openquake/oq-engine
echo "GEOS_LIBRARY_PATH = '$HOME/local/lib/libgeos_c.so'" >> openquake/engine/settings.py
```

## Build hazardlib speedups
```bash
cd ~/openquake/oq-hazardlib
python setup.py build_ext
cd openquake/hazardlib/geo
ln -s ../../../build/lib.*/openquake/hazardlib/geo/*.so .
```

## Run OpenQuake
```bash
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
```

## DB setup
```bash
~/local/bin/initdb
~/bin/start-postgresql
```

Apply 'create\_oq\_schema.patch' patch (supposing __/home/openquaker__ as homedir) then

```bash
cd ~/openquake/oq-engine && ./bin/create_oq_schema --db-user=openquaker --db-name=openquake --schema-path=$HOME/openquake/oq-engine/openquake/engine/db/schema
```

## Start services
```bash
killall postgres
~/bin/start-postgresql
~/bin/start-rabbitmq
~/bin/start-celery
~/bin/start-redis
```

## Run some tests
```bash
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
```


## Run a real computation test
```bash
cd ~/openquake/oq-engine
bin/openquake --rh=demos/hazard/SimpleFaultSourceClassicalPSHA/job.ini
```

## Extra tools
### htop
```bash
cd ~/src
wget http://downloads.sourceforge.net/project/htop/htop/1.0.2/htop-1.0.2.tar.gz
tar xzf htop-1.0.2.tar.gz
cd htop-1.0.2
./configure --prefix=$HOME/local
make
make install
htop
```

## TODO
*   Check system lib dependencies
*   Hardering PostgreSQL configuration

_how to ver. 4.1_

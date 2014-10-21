__work in progress__ tested on __CentOS 5.11 / 6.5 / 7__ with the OpenQuake Engine (https://github.com/gem/oq-engine).

## Automatic deploy

### User environment

* Requirements are: ```sudo```, ```wget``` and ```sed```
* SELinux must be disabled or in 'permissive' mode

### Deploy script (from sources)

As normal user or root run:

```bash
cd ~
wget https://raw.githubusercontent.com/daniviga/openquake-centos/master/bin/deploy-openquake-centos6.sh
sudo bash deploy-openquake-centos6.sh | tee install.log
```

To change the default installation path (```/opt/openquake```) dowload and edit the deployment script:
```bash
cd ~
wget https://raw.githubusercontent.com/daniviga/openquake-centos/master/bin/deploy-openquake-centos6.sh
vi deploy-openquake-centos6.sh ## Edit $OQPREFIX var ##
sudo bash deploy-openquake-centos6.sh | tee install.log
```

### Build dependencies

Build depnendencies are installed by the deployment script.

#### CentOS 6

```bash
yum install bzip2 wget gcc gcc-c++ compat-gcc-34-c++ openssl-devel zlib* make ncurses-devel bzip2-devel readline-devel zip unzip nc libcurl-devel expat-devel gettext gettext-devel xmlto perl-ExtUtils-MakeMaker pcre pcre-devel patch gcc-gfortran compat-gcc-34-g77 libgfortran blas* lapack* libxslt libxslt-devel unixODBC-devel
```
#### CentOS 5

```bash
sudo yum install bzip2.x86_64 wget.x86_64 gcc.x86_64 gcc-c++.x86_64 compat-gcc-34-c++.x86_64 openssl-devel.x86_64 zlib*.x86_64 make.x86_64 ncurses-devel.x86_64 bzip2-devel.x86_64 readline-devel.x86_64 zip.x86_64 unzip.x86_64 nc.x86_64 curl-devel.x86_64 expat-devel.x86_64 gettext.x86_64 gettext-devel.x86_64 xmlto.x86_64 patch.x86_64 gcc-gfortran.x86_64 compat-gcc-34-g77.x86_64 libgfortran.x86_64 blas*.x86_64 lapack*.x86_64 libxslt.x86_64 libxslt-devel.x86_64 unixODBC-devel.x86_64
```

### Run-time dependencies

#### CentOS 6

```bash
yum install bzip2 make pcre libgfortran blas lapack libxslt zlib
```
#### CentOS 5

```bash
yum install bzip2.x86_64 make.x86_64 pcre.x86_64 libgfortran.x86_64 blas.x86_64 lapack.x86_64 libxslt.x86_64 zlib.x86_64
```

## Run OpenQuake

To allow users run the OpenQuake Engine its environment must be loaded:
```bash
$ source /opt/openquake/env.sh
```
This can be done automatically at every login via user's .bash\_profile:

```bash
$ echo "source /opt/openquake/env.sh" >> ~/.bash_profile
```

or systemwide (not recommended):

```bash
$ sudo su -c "echo 'source /opt/openquake/env.sh' >> /etc/profile.d/oq-engine.sh"
```
Now you can run the OpenQuake Engine:

```bash
$ oq-engine

usage: oq-engine [-h] [--version] [--log-file LOG_FILE]
                 [--log-level {debug,info,progress,warn,error,critical}]
                 [--no-distribute] [--list-inputs INPUT_TYPE] [--yes]
                 [--config-file CONFIG_FILE] [--upgrade-db] [--version-db]
                 [--what-if-I-upgrade] [--run-hazard CONFIG_FILE]
                 [--list-hazard-calculations]
                 [--list-hazard-outputs HAZARD_CALCULATION_ID]
                 [--export-hazard OUTPUT_ID TARGET_DIR]
                 [--export-hazard-outputs HAZARD_CALCULATION_ID TARGET_DIR]
                 [--delete-hazard-calculation HAZARD_CALCULATION_ID]
                 [--delete-uncompleted-calculations] [--run-risk CONFIG_FILE]
                 [--hazard-output-id HAZARD_OUTPUT]
                 [--hazard-calculation-id HAZARD_CALCULATION_ID]
                 [--list-risk-calculations]
                 [--list-risk-outputs RISK_CALCULATION_ID]
                 [--export-risk OUTPUT_ID TARGET_DIR]
                 [--export-risk-outputs RISK_CALCULATION_ID TARGET_DIR]
                 [--delete-risk-calculation RISK_CALCULATION_ID]
                 [--exports {xml}] [--export-type {xml,geojson}]
                 [--save-hazard-calculation HAZARD_CALCULATION_ID DUMP_DIR]
                 [--load-hazard-calculation DUMP_DIR] [--load-gmf GMF_FILE]
                 [--load-curve CURVE_FILE] [--list-imported-outputs]

```

### Start and stop the OpenQuake Engine stack

An init.d script is provided to start and stop the OpenQuake Engine software stack (RabbitMQ, PostgreSQL, Celeryd)

```bash
# Stop
$ sudo service oq-engine stop
# Start
$ sudo service oq-engine start
# Restart
$ sudo service oq-engine restart
```

## Run some tests
```bash
cd /opt/openquake/openquake/oq-engine
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

## Extra tools
### htop
```bash
cd /tmp
wget http://downloads.sourceforge.net/project/htop/htop/1.0.2/htop-1.0.2.tar.gz
tar xzf htop-1.0.2.tar.gz
cd htop-1.0.2
./configure
make
make install
htop
```

More information and support: info@openquake.org

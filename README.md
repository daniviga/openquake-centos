__work in progress__ tested on __CentOS 6.5__ with the OpenQuake Engine (https://github.com/gem/oq-engine).

## Automatic deploy

### User environment

* Requirements are: ```sudo```, ```wget``` and ```sed```

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

### Run-time dependencies

#### CentOS 6

```bash
yum install bzip2 make pcre libgfortran blas lapack libxslt zlib
```

## Run OpenQuake
```bash

$ openquake

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

## Run some tests
```bash
sudo pip install nose==1.3.0
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


_how to ver. 5.0_

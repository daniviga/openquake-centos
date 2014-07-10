__work in progress__ tested on __CentOS 6.5__ with OpenQuake Engine commits:

```
oq-engine:    f1c0180ef3ee9ab502bd63e606583e413b23e247
oq-hazardlib: 3c9ba9eb978cc22f48942993307fc81e6e99c4a3
oq-nrmllib:   2d1a169f855f69312b4b47819283063ea15c1448
oq-risklib:   668d6b5c4e91c439231cc1795195598b68767d8e
oq-commonlib: cf0a503f8d625036dec3fc5dd49b68dbb9d19d57
```

## Automatic deploy

### User environment

* Requirements are: ```sudo```, ```wget``` and ```sed```

### Deploy script (from sources)

As normal user or root run:

```bash
wget -O- https://raw.githubusercontent.com/daniviga/openquake-centos/master/bin/deploy-openquake-centos6.sh | sudo bash | tee install.log
```

To change the default installation path (```/opt/openquake```) dowload and edit the deployment script:
```bash
cd ~
wget https://raw.githubusercontent.com/daniviga/openquake-centos/master/bin/deploy-openquake-centos6.sh
vi deploy-openquake-centos6.sh ## Edit $OQPREFIX var ##
sudo bash deploy-openquake-centos6.sh
```

### Deploy script (binary)

_Coming soon_


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
cd ~/src
wget http://downloads.sourceforge.net/project/htop/htop/1.0.2/htop-1.0.2.tar.gz
tar xzf htop-1.0.2.tar.gz
cd htop-1.0.2
./configure --prefix=$HOME/local
make
make install
htop
```


_how to ver. 5.0_

# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=~/python/bin:~/erlang/bin:~/git/bin:~/hdf5/bin:~/postgresql/bin:~/rabbitmq/sbin:~/redis/bin:$PATH:$HOME/bin
PYTHONPATH=.:~/python:~/openquake/nrml:~/openquake/nhlib:~/openquake/oq-risklib:~/openquake/oq-engine
PGDATA=~/postgresql/var
LD_LIBRARY_PATH=~/python/lib:~/postgresql/lib

export PATH
export PYTHONPATH
export PGDATA
export LD_LIBRARY_PATH

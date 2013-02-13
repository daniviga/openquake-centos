# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$HOME/local/bin:$HOME/local/sbin:$PATH:$HOME/bin
LD_LIBRARY_PATH=$HOME/local/lib:$HOME/local/lib64
CPATH=$HOME/local/include

PYTHONPATH=.:$HOME/openquake/openquake:$HOME/openquake/oq-engine:$HOME/openquake/oq-hazardlib:$HOME/openquake/oq-nrmllib:$HOME/openquake/oq-risklib
PGDATA=$HOME/local/var/postgresql

export PATH
export PYTHONPATH
export PGDATA
export LD_LIBRARY_PATH

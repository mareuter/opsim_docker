#!/bin/bash

export PATH=$HOME/miniconda/bin:$PATH

### Setting up some env vars
source eups-setups.sh
setup sims_operations


### I'm mounting my scratch dir as /home/opsim/scratch/ which overwrites the existing dir.
### So I need to copy the contents back over. 
cp -r /home/opsim/scratchtemp/* /home/opsim/scratch/

### Change the permissions (the image was mounted as read-only)
### This is a bit brute-force
find /home/opsim/scratch/ -type d -exec chmod 777 {} \;
find /home/opsim/scratch/ -type f -exec chmod 644 {} \;
chmod 777 /home/opsim/scratch/opsim-config/etc/init.d/mysqld

/home/opsim/scratch/opsim-config/etc/init.d/mysqld start


## I'm going to checkout the config files here to avouid confusion. 
cd $HOME/scratch/

# Download a specific OpSim configuration and update to this run config.
export CONFIG_SHA1=3e93a50
git clone https://github.com/lsst-sims/opsim3_config.git conf
cd conf
git checkout $CONFIG_SHA1
STARTUP_COMMENT=$(git log -n 1 --pretty=format:%s)


# Since container is fresh, sessionID will always be 1000
oldfiletag="${HOSTNAME}_1000"
newfiletag="${oldfiletag}_${CONFIG_SHA1}"

opsim.py --track=no --config=$HOME/scratch/conf/survey/LSST.conf --startup_comment="$STARTUP_COMMENT" >& $HOME/scratch/runs/log/opsim_${newfiletag}.log

#mv $HOME/scratch/runs/log/lsst.log_1000 $HOME/scratch/runs/log/lsst.log_${newfiletag}

$SIMS_OPERATIONS_DIR/tools/modifySchema.sh 1000 >& log/ms_${newfiletag}.log
#mv $HOME/scratch/runs/output/${oldfiletag}_datexport.tar.gz $HOME/scratch/runs/output/${newfiletag}_datexport.tar.gz
#mv $HOME/scratch/runs/output/${oldfiletag}_export.sql.gz $HOME/scratch/runs/output/${newfiletag}_export.sql.gz
#mv $HOME/scratch/runs/output/${oldfiletag}_sqlite.db $HOME/scratch/runs/output/${newfiletag}_sqlite.db

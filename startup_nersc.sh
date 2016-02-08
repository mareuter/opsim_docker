#!/bin/bash

export PATH=$HOME/miniconda/bin:$PATH

### Setting up some env vars
source eups-setups.sh
setup sims_operations

### I'm mounting my scratc dir as /home/opsim/scratch/ which overwrites the existing dir.
### So I need to copy the contents back over. 
cp -r /home/opsim/scratchtemp/ /home/opsim/scratch/

### Change the permissions (the image was mounted as read-only)
### This is a bit brute-force
find /home/opsim/scratch/ -type d -exec chmod 777 {} \;
find /home/opsim/scratch/ -type f -exec chmod 644 {} \;
chmod 777 /home/opsim/scratch/opsim-config/etc/init.d/mysqld

/home/opsim/scratch/opsim-config/etc/init.d/mysqld start

## skip this step for now - will potentially want to move $HOME/conf to $HOME/scratch to allow write access
##cd $HOME/conf
##git checkout $CONFIG_SHA1
##STARTUP_COMMENT=$(git log -n 1 --pretty=format:%s)


## change the run time in a hacky way to something that will run quickly
sed -i '/nRun = 10.0/c\nRun=0.005'  conf/survey/LSST.conf

cd /home/opsim/scratch/runs
mkdir log
mkdir output

# Since container is fresh, sessionID will always be 1000
oldfiletag="${HOSTNAME}_1000"
newfiletag="${oldfiletag}_${CONFIG_SHA1}"

opsim.py --track=no --config=$HOME/conf/survey/LSST.conf --startup_comment="$STARTUP_COMMENT" >& log/opsim_${newfiletag}.log
mv log/lsst.log_1000 log/lsst.log_${newfiletag}

$SIMS_OPERATIONS_DIR/tools/modifySchema.sh 1000 >& log/ms_${newfiletag}.log
mv output/${oldfiletag}_datexport.tar.gz output/${newfiletag}_datexport.tar.gz
mv output/${oldfiletag}_export.sql.gz output/${newfiletag}_export.sql.gz
mv output/${oldfiletag}_sqlite.db output/${newfiletag}_sqlite.db

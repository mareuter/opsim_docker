#!/bin/bash

export PATH=$HOME/miniconda/bin:$PATH

$HOME/opsim-config/etc/init.d/mysqld start

cd $HOME/conf
git checkout $CONFIG_SHA1
STARTUP_COMMENT=$(git log -n 1 --pretty=format:%s)

cd $HOME/runs

# Since container is fresh, sessionID will always be 1000
oldfiletag="${HOSTNAME}_1000"
newfiletag="${oldfiletag}_${CONFIG_SHA1}"

source eups-setups.sh
setup sims_operations
opsim.py --track=no --config=$HOME/conf/survey/LSST.conf --startup_comment="$STARTUP_COMMENT" >& log/opsim_${newfiletag}.log
mv log/lsst.log_1000 log/lsst.log_${newfiletag}

$SIMS_OPERATIONS_DIR/tools/modifySchema.sh 1000 >& log/ms_${newfiletag}.log
mv output/${oldfiletag}_datexport.tar.gz output/${newfiletag}_datexport.tar.gz
mv output/${oldfiletag}_export.sql.gz output/${newfiletag}_export.sql.gz
mv output/${oldfiletag}_sqlite.db output/${newfiletag}_sqlite.db

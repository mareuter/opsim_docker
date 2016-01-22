#!/bin/bash

export PATH=$HOME/miniconda/bin:$PATH

$HOME/opsim-config/etc/init.d/mysqld start

cd $HOME/conf
git checkout $CONFIG_SHA1

cd $HOME/runs

source eups-setups.sh
setup sims_operations
opsim.py --track=no --config=$HOME/conf/survey/LSST.conf --startup_comment=$STARTUP_COMMENT >& log/opsim.log

#!/bin/bash

export HOME=/home/opsim/
export PATH=$HOME/miniconda/bin:$PATH

$HOME/opsim-config/etc/init.d/mysqld start

cd $HOME/runs

source eups-setups.sh
setup sims_operations


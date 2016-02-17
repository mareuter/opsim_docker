#!/bin/bash
#SBATCH --image=docker:djbard/opsim:nersc_batch
#SBATCH --nodes=1
#SBATCH --partition=regular
#SBATCH --time=00:20:00
#SBATCH --qos="premium"

## which opsim cofig are we using?
export CONFIG_SHA1=e15350e

## make this the run directory name
mkdir $SCRATCH/opsim/${CONFIG_SHA1}


srun  shifter --volume=/global/cscratch1/sd/djbard/opsim/${CONFIG_SHA1}:/home/opsim/scratch /bin/bash /home/opsim/startup.sh
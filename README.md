# Docker for OpSim
This is my version of a Docker image of the LSST Operations Simulator, edited from the original to allow it to run at NERSC. NERSC uses Shifter to run User-Defnined Images (http://www.nersc.gov/research-and-development/user-defined-images/), and Shifter runs the image in a read-only FS. I made a number of changes to the Dockerfile and startup script in order to get around this. I mount a scratch directory to use as a writable directory to hold the configuration info, and the output files. 
There may be other issues I have not yet seen with the read-only FS...

To run at NERSC: 

1. Load the shifter module: module load shifter
2. Pull down the docker image: shifterimg -v pull docker:djbard/opsim:nersc
3. Request an interactive session on a compute node: salloc -N 1 -p debug --image=docker:djbard/opsim:nersc -t 00:10:00
4. Once the nodes become available, load the shifter module again: module load shifter
5. Fire up the image, mounting your scratch directory: shifter  --volume=/global/cscratch1/sd/username/path/to/opsim/scratch:/home/opsim/scratch /bin/bash -i
6. Go to the run directory: cd /home/opsim
7. Run the startup script: bash startup.sh 
8. Admire your output: ls -lrta home/opsim/scratch/runs/output

Note that at present it does not accept any run information - it just runs what is in LSST.conf (although with a much shorter run time specified)

#!/bin/bash -l
#SBATCH -A 2017-11-55
#SBATCH -N 4
#SBATCH -t 00:40:00
#SBATCH -J LDA+U

#aprun -n 96 ./rspt
./runs "aprun -n 128 ./rspt" 1e-12 500





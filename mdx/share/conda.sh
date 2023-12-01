#!/bin/bash 

# activate conda
# `source /large/share/app/conda/miniconda3/etc/profile.d/conda.sh`

# notes:
# activating by lmod is fine but unable to deactivating
# adding path (.../bin/) is bad since a lot of binaries are in the dir


set -eux



APP="conda"
APPDIR="/large/share/app/${APP}/"


mkdir -p $APPDIR && cd $APPDIR
# path will be asked:  /large/share/app/conda/miniconda3
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ./miniconda.sh

bash ./miniconda.sh

rm -rf ./miniconda.sh


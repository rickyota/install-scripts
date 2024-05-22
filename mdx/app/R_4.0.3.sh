#!/bin/bash

# openssl version conflict error, use R v4.3.1
exit 1

#source /large/share/app/lmod/bash

module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
#MODROOT=/nfs/data06/ricky/app/
MODROOT=/large/ricky/app/
APP=R
VER=4.0.3
#VER=4.3.1

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

#wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p $APPDIR/$VER
cd $VER
./bin/mamba install -c conda-forge -c defaults -y r-base=$VER
rm -rf pkgs

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", pathJoin(apphome, "bin"))
__END__

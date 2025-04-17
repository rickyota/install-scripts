#!/bin/bash

# use conda installed locally in ./app/csvkit

source /bio/lmod/lmod/init/bash

module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/large/ricky/app/
APP=miniwdl
VER=1.12.1

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

CONDA_SH=Miniconda3-py310_23.3.1-0-Linux-x86_64.sh
curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
sh ${CONDA_SH} -b -p $APPDIR/$VER

rm ${CONDA_SH}
cd $VER
./bin/pip install $APP==$VER
rm -rf pkgs

# when append whole ./bin/ , other program including conda, python etc is also in PATH
# ml unload as soon as possible
# ** DO NOT load in ~/.zshrc **

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", pathJoin(apphome,"bin"))
__END__

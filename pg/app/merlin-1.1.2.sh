#!/bin/bash

# pre-compiled run (only on z01?)
# https://csg.sph.umich.edu/abecasis/Merlin/download/Linux-merlin.tar.gz

source /bio/lmod/lmod/init/bash

module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data06/ricky/app/
APP=merlin
VER=1.1.2


# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP #/$VER
mkdir -p $APPDIR && cd $APPDIR

#wget https://csg.sph.umich.edu/abecasis/Merlin/download/Linux-merlin.tar.gz
#tar -zxvf ./Linux-merlin.tar.gz
#mv ./${APP}-${VER} ${VER}


# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())
-- Package settings
prepend_path("PATH", apphome)
__END__







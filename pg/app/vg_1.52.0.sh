#!/bin/bash

source /bio/lmod/lmod/init/bash

module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data06/ricky/app
APP=vg
VER=1.52.0
# VER=1.62.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mkdir $VER
cd $VER
wget https://github.com/vgteam/vg/releases/download/v${VER}/vg
chmod +x vg

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

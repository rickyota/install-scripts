#!/bin/bash

module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/large/ricky/app/
APP=dockstore
VER=1.18.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

mkdir -p $VER && cd $VER

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
curl -L -o ./dockstore https://github.com/dockstore/dockstore-cli/releases/download/1.18.0/dockstore
chmod +x dockstore

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

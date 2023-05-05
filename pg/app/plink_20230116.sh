#!/bin/bash

module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data06/ricky/app
APP=plink
VER=20230116


# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

mkdir -p $VER && cd $VER

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget https://s3.amazonaws.com/plink1-assets/${APP}_linux_x86_64_${VER}.zip
unzip ${APP}_linux_x86_64_${VER}.zip
rm ${APP}_linux_x86_64_${VER}.zip


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







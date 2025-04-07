#!/bin/bash

source /bio/lmod/lmod/init/bash

module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data06/ricky/app/
# MODROOT=/large/ricky/app/
APP=ldak
VER=6.1
# = Alpha6.8

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

mkdir -p $VER && cd $VER

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
wget https://github.com/dougspeed/LDAK/blob/main/${APP}${VER}.linux
# wget https://github.com/dougspeed/LDAK/blob/main/ldak6.1.linux
#wget https://s3.amazonaws.com/plink2-assets/${APP}_linux_avx2_${VER}.zip
# wget https://s3.amazonaws.com/plink2-assets/alpha6/plink2_linux_avx2_${VER}.zip
# unzip ${APP}_linux_avx2_${VER}.zip
# rm ${APP}_linux_avx2_${VER}.zip

mv ${APP}${VER}.linux $APP

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

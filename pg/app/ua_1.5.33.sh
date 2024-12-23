#!/bin/bash

# "upload agent" program for ukb rap (uk biobank research analysis platform)
# https://documentation.dnanexus.com/downloads#Upload-Agent

# The latest is v1.5.33 [ref](https://github.com/dnanexus/dx-toolkit/blob/master/src/ua/CHANGELOG)

source /bio/lmod/lmod/init/bash

module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data06/ricky/app/
APP=ua
VER=1.5.33

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

mkdir -p $VER && cd $VER

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
#wget \
#  https://dnanexus-sdk.s3.amazonaws.com/dnanexus-upload-agent-${VER}-linux.tar.gz -O - |\
#  tar -xzf -

#mv ./dnanexus-upload-agent-1.5.33-linux/ua .
#rm -r ./dnanexus-upload-agent-1.5.33-linux/

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

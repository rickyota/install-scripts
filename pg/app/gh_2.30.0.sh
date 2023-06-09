#!/bin/bash

OS_VER=$(lsb_release -r | cut -f2,2 | cut -d'.' -f1,1)
if [[ ${OS_VER} == "8" ]]; then
    source /bio/lmod-rl8/lmod/lmod/init/bash
else
    source /bio/lmod/lmod/init/bash
fi

module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data06/ricky/app
APP=gh
VER=2.30.0


# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

#wget https://github.com/cli/cli/releases/download/v${VER}/gh_${VER}_linux_amd64.tar.gz
#tar -zxf gh_${VER}_linux_amd64.tar.gz
#rm gh_${VER}_linux_amd64.tar.gz
#mv gh_${VER}_linux_amd64 ${VER}


# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())
-- Package settings
prepend_path("PATH", pathJoin(apphome, "bin/"))
__END__



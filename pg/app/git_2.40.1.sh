#!/bin/bash

# how to avoid source here?
OS_VER=$(lsb_release -a | grep "^Release" | cut -f2,2 | cut -d'.' -f1,1)
if [[ ${OS_VER} == "8" ]]; then
    source /bio/lmod-rl8/lmod/lmod/init/bash
else
    source /bio/lmod/lmod/init/bash
fi

module purge
set -eux

MODROOT=/nfs/data06/ricky/app
APP=git
VER=2.40.1

APPDIR=$MODROOT/$APP #/$OSVER
mkdir -p $APPDIR && cd $APPDIR

module load gcc/9.2.0
# this raise git error
#module load glibc/2.17

wget https://github.com/git/git/archive/refs/tags/v${VER}.tar.gz
tar -zxf v${VER}.tar.gz
rm v${VER}.tar.gz

cd ${APP}-${VER}
make configure
./configure --prefix $APPDIR/$VER
make all
make install

# error: need requirements
#make all doc info
#make install install-doc install-html install-info



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



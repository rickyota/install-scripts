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
APP=tmux
VER=3.2a

APPDIR=$MODROOT/$APP #/$OSVER
mkdir -p $APPDIR && cd $APPDIR

module load gcc/9.2.0

wget https://github.com/tmux/tmux/releases/download/${VER}/${APP}-${VER}.tar.gz
tar -zxf ${APP}-${VER}.tar.gz
rm ${APP}-${VER}.tar.gz

cd ${APP}-${VER}
./configure --prefix $APPDIR/$VER
make && make install


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

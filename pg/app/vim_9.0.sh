#!/bin/bash

#  reinstalled to a01 on 23/04/11 for Rocky Linux 8.9

source /bio/lmod/lmod/init/bash

module purge
set -eux

MODROOT=/nfs/data06/ricky/app
APP=vim
VER=9.0

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

#module load gcc/9.2.0

git clone --depth=1 https://github.com/vim/vim.git
mv ${APP} ${APP}-${VER}
cd ${APP}-${VER}
./configure --prefix $APPDIR/$VER
cd src
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

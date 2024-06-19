#!/bin/bash

##  Cannot leinstall on 23/03/25 for Rocky Linux 8.9

source /bio/lmod/lmod/init/bash

module purge
set -eux

MODROOT=/nfs/data06/ricky/app
APP=tmux
VER=3.3a

APPDIR=$MODROOT/$APP #/$OSVER
mkdir -p $APPDIR && cd $APPDIR

#module load gcc/9.2.0

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

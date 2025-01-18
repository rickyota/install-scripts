#!/bin/bash

source /bio/lmod/lmod/init/bash

module purge
set -eux

MODROOT=/large/ricky/app/
APP=muslcc-cross
VER=11.2.1

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# https://kateinoigakukun.hatenablog.com/entry/2022/02/18/232723
curl -LO https://musl.cc/x86_64-linux-musl-cross.tgz

tar xfz x86_64-linux-musl-cross.tgz
rm -f x86_64-linux-musl-cross.tgz
mv x86_64-linux-musl-cross ${VER}

cd ${VER}/bin
ln -sf x86_64-linux-musl-cc musl-cc
ln -sf x86_64-linux-musl-gcc musl-gcc
ln -sf x86_64-linux-musl-g++ musl-g++
ln -sf x86_64-linux-musl-gcc x86_64-unknown-linux-musl-gcc
cd -

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

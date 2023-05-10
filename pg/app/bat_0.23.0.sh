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
APP=bat
VER=0.23.0

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

module load gcc/9.2.0

git clone --depth=1 https://github.com/sharkdp/bat
mv bat ${VER}
cd ${VER}
cargo install --locked bat

# bin is in ~/.cargo/bin/ and in PATH from the beginning

exit 0

#cd $MODROOT/.modulefiles && mkdir -p $APP
#cat <<__END__ >$APP/$VER.lua
#-- Default settings
#local modroot    = "$MODROOT"
#local appname    = myModuleName()
#local appversion = myModuleVersion()
#local apphome    = pathJoin(modroot, myModuleFullName())
#-- Package settings
#prepend_path("PATH", pathJoin(apphome, "target/release/"))
#__END__
#


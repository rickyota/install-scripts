#!/bin/bash


echo "ny"
exit 1



OS_VER=$(lsb_release -r | cut -f2,2 | cut -d'.' -f1,1)
#OS_VER=$(lsb_release -a | grep "^Release" | cut -f2,2 | cut -d'.' -f1,1)
if [[ ${OS_VER} == "8" ]]; then
    source /bio/lmod-rl8/lmod/lmod/init/bash
else
    source /bio/lmod/lmod/init/bash
fi

module purge
set -eux

MODROOT=/nfs/data06/ricky/app
APP=xsel
VER=1.2.1

APPDIR=$MODROOT/$APP #/$OSVER
mkdir -p $APPDIR && cd $APPDIR

#module load gcc/9.2.0


#wget https://github.com/kfish/xsel/archive/refs/tags/${VER}.tar.gz
#tar -zxf ${VER}.tar.gz
#rm ${VER}.tar.gz

cd ${APP}-${VER}
# raised error
make configure
./configure --prefix $APPDIR/$VER
make all
make install


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



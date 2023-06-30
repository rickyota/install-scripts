#!/bin/bash

# when installing snpnet, this R does not work well...
# use source /bio/package/R/setup-4.0.3.sh

OS_VER=$(lsb_release -r | cut -f2,2 | cut -d'.' -f1,1)
if [[ ${OS_VER} == "8" ]]; then
    source /bio/lmod-rl8/lmod/lmod/init/bash
else
    source /bio/lmod/lmod/init/bash
fi

module purge
set -eux

MODROOT=/nfs/data06/ricky/app
APP=R
VER=4.0.3

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

CONDA_SH=Miniconda3-py37_4.9.2-Linux-x86_64.sh
curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
sh ${CONDA_SH} -b -p $APPDIR/$VER
rm ${CONDA_SH}
cd $VER
./bin/conda install -c conda-forge -c defaults -y r-base=$VER
rm -rf pkgs

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

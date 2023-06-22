#!/bin/bash

# use conda installed locally in ./app/csvkit


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
APP=csvkit
VER=1.1.1


# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

CONDA_SH=Miniconda3-py310_23.3.1-0-Linux-x86_64.sh
curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
sh ${CONDA_SH} -b -p $APPDIR/$VER

rm ${CONDA_SH}
cd $VER
./bin/pip install $APP==$VER
rm -rf pkgs

# when append whole ./bin/ , other program including conda, python etc is also in PATH
# ml unload as soon as possible
# ** DO NOT load in ~/.zshrc **


## make conda common and install to ./bin_app
## requires ml conda and ./bin_app

# bad
# tried to split bin directory to avoid including python, conda etc. in the path
## cannot excute program since python is not in the path
#CONDA_SH=Miniconda3-py310_23.3.1-0-Linux-x86_64.sh
#curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
#sh ${CONDA_SH} -b -p $APPDIR/$VER
#rm ${CONDA_SH}
#
#cd $VER
#./bin/pip install $APP==$VER -t ./bin_app
#rm -rf pkgs




# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", pathJoin(apphome,"bin"))
__END__







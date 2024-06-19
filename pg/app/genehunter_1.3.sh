#!/bin/bash

# STOP: too old use genehunter-mod

source /bio/lmod/lmod/init/bash

module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data06/ricky/app/
APP=genehunter
VER=1.3


# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

mkdir -p $VER && cd $VER

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
# download dir in https://www.broadinstitute.org/scientific-community/software/genehunter 
# and move to cluster computer
# mv gh-1.3.tar.gz into ./1.3

#mv ./GeneHunter/gh-1.3.tar.gz ./1.3 
#gunzip gh-1.3.tar.gz
#tar xvpf gh-1.3.tar

# follow INSTALL

#wget https://s3.amazonaws.com/plink2-assets/${APP}_linux_avx2_${VER}.zip 
#unzip ${APP}_linux_avx2_${VER}.zip 
#rm ${APP}_linux_avx2_${VER}.zip


# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())
-- Package settings
prepend_path("PATH", apphome)
__END__







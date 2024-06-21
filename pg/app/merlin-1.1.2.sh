#!/bin/bash

# https://csg.sph.umich.edu/abecasis/merlin/download/

# pre-compiled cannot run
# https://csg.sph.umich.edu/abecasis/Merlin/download/Linux-merlin.tar.gz


# cannot compile on pg
exit 1

source /bio/lmod/lmod/init/bash

module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data06/ricky/app/
APP=merlin
VER=1.1.2


# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP #/$VER
mkdir -p $APPDIR && cd $APPDIR

#wget https://csg.sph.umich.edu/abecasis/merlin/download/merlin-1.1.2.tar.gz

cd ${APP}-${VER}
make install INSTALLDIR=${APPDIR}/$VER

#singularity pull ${APP}.sif docker://rickyota/${APP}:${VER}
#cat <<__END__ >$APP
##!/bin/bash
#singularity exec $APPDIR/${APP}.sif /app/ghm \$*
#__END__
#chmod +x $APP


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







#!/bin/bash

# first in local, run .nstall-scripts/local/docker/genehunter-modscore/4.0

# https://www.unimedizin-mainz.de/imbei/biometriegenomische-statistik-und-bioinformatik/software/genehunter-modscore-40.html
#

source /bio/lmod/lmod/init/bash

module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data06/ricky/app/
APP=genehunter-modscore
VER=4.0


# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR && cd $APPDIR


singularity pull ${APP}.sif docker://rickyota/${APP}:${VER}
cat <<__END__ >$APP
#!/bin/bash
singularity exec $APPDIR/${APP}.sif /app/ghm \$*
__END__
chmod +x $APP


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
setenv("SINGULARITY_BIND", "/data,/glusterfs,/glusterfs2,/glusterfs3,/grid2,/hpgdata,/hpgwork,/hpgwork2,/nfs/data05,/nfs/data06,/nfs/data07,/nfs/data08")
__END__







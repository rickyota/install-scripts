#!/bin/bash

source /bio/lmod/lmod/init/bash
module purge
set -eux

MODROOT=/nfs/data06/ricky/app
APP=happy
VER=0.3.12

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

singularity pull ${APP}.sif docker://jmcdani20/hap.py:v${VER}
cat <<__END__ >$APP
#!/bin/bash
singularity exec $APPDIR/${APP}.sif /opt/hap.py/bin/hap.py \$*
__END__
chmod +x $APP

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", apphome)
unsetenv("PERL5LIB")
setenv("PERL_BADLANG", "0")
setenv("SINGULARITY_BIND", "/data,/grid2,/nfs/data05,/nfs/data06,/nfs/data07,/nfs/data08,/nfs/data09")
__END__

# setenv("SINGULARITY_BIND", "/data,/glusterfs,/glusterfs2,/glusterfs3,/grid2,/hpgdata,/hpgwork,/hpgwork2,/nfs/data05,/nfs/data06,/nfs/data07,/nfs/data08")

#!/bin/bash

source /bio/lmod/lmod/init/bash
module purge
set -eux

MODROOT=/nfs/data06/ricky/app
APP=pangenome_aware_deepvariant-gpu
VER=1.8.0

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

#singularity pull $APP.sif docker://google/deepvariant:pangenome_aware_deepvariant-${VER}-gpu
for CMD in run_pangenome_aware_deepvariant; do
    echo '#!/bin/sh' >$CMD
    echo "singularity exec --nv $APPDIR/$APP.sif $CMD \$*" >>$CMD
    chmod +x $CMD
done
# TODO: pip install altair?

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
setenv("SINGULARITY_BIND", "/data,/glusterfs,/glusterfs2,/glusterfs3,/grid2,/hpgdata,/hpgwork,/hpgwork2,/nfs/data05,/nfs/data06,/nfs/data07,/nfs/data08")
__END__

#!/bin/bash

# for vg wdl
# https://github.com/vgteam/vg_wdl/blob/master/tasks/bioinfo_utils.wdl

source /bio/lmod/lmod/init/bash
module purge
set -eux

MODROOT=/nfs/data06/ricky/app
APP=samtools-picard
VER=1

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

singularity pull $APP.sif docker://quay.io/cmarkello/samtools_picard@sha256:e484603c61e1753c349410f0901a7ba43a2e5eb1c6ce9a240b7f737bba661eb4
for CMD in CreateSequenceDictionary; do
	echo '#!/bin/sh' >$CMD
	echo "singularity exec $APPDIR/$APP.sif java -jar /usr/picard/picard.jar CreateSequenceDictionary \$*" >>$CMD
	# echo "singularity exec $APPDIR/$APP.sif $CMD \$*" >>$CMD
	chmod +x $CMD
done

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

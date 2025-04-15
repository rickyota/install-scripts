#!/bin/bash

# for vg wdl
# https://github.com/vgteam/vg_wdl/blob/master/tasks/bioinfo_utils.wdl

source /bio/lmod/lmod/init/bash
module purge
set -eux

MODROOT=/nfs/data06/ricky/app
APP=gatk-bedtools
VER=3.8.1_2.21.0

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

# singularity pull $APP.sif docker://quay.io/jmonlong/${APP}:${VER}
for CMD in realigner; do
	echo '#!/bin/sh' >$CMD
	echo "singularity exec $APPDIR/$APP.sif java -jar /usr/GenomeAnalysisTK.jar -T RealignerTargetCreator \$*" >>$CMD
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

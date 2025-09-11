#!/bin/bash

# https://asia.ensembl.org/info/docs/tools/vep/script/index.html?utm_source=chatgpt.com

source /large/share/app/lmod/bash

module purge
set -eux

MODROOT=/large/ricky/app/
APP=ensembl-vep
VER=115.1

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR && cd $APPDIR

singularity pull $APP.sif docker://ensemblorg/ensembl-vep:release_${VER}

# download cache to /home/$USER/cache/vep
singularity exec \
	-B /home/$USER/cache/vep:/opt/vep/.vep \
	$APPDIR/$APP.sif \
	INSTALL.pl \
	--AUTO c \
	--SPECIES homo_sapiens \
	--ASSEMBLY GRCh38 \
	--CACHEDIR /opt/vep/.vep

singularity exec \
	-B /home/$USER/cache/vep:/opt/vep/.vep \
	$APPDIR/$APP.sif \
	INSTALL.pl \
	--AUTO c \
	--SPECIES homo_sapiens \
	--ASSEMBLY GRCh37 \
	--CACHEDIR /opt/vep/.vep

for CMD in vep; do
	echo '#!/bin/sh' >$CMD
	echo "singularity exec -B /home/$USER/cache/vep:/opt/vep/.vep $APPDIR/$APP.sif $CMD \$*" >>$CMD
	chmod +x $CMD
done

# ng
# git clone https://github.com/Ensembl/ensembl-vep.git
# cd ensembl-vep
# git checkout release/${VER}
# perl INSTALL.pl

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
setenv("SINGULARITY_BIND", "/large,/fast")
__END__

#!/bin/bash

# Another option is to use conda

source /large/share/app/lmod/bash

module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/large/ricky/app/
APP=cromwell
VER=92

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR && cd $APPDIR

wget https://github.com/broadinstitute/cromwell/releases/download/${VER}/cromwell-${VER}.jar
mv cromwell-${VER}.jar cromwell.jar

for CMD in cromwell; do
	echo '#!/bin/sh' >$CMD
	echo "java -jar $APPDIR/cromwell.jar \$*" >>$CMD
	chmod +x $CMD
done

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

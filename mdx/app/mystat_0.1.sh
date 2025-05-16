#!/bin/bash

# my script file

# myhist
# ex. cut -f1 input | myhist 0.1

module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/large/ricky/app/
APP=mystat
VER=0.1

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

# histogram
cat <<"__END__" >myhist
#!/bin/bash

# Default bin size=1
bin_size=${1:-1}

awk -v bin_size="$bin_size" '{
    bin = int($1 / bin_size) * bin_size;
    count[bin]++;
}
END {
    for (b in count) {
        printf "%.4f\t%d\n", b, count[b];
    }
}' | sort -n
__END__
chmod +x myhist

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

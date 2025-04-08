#!/bin/bash

source /bio/lmod/lmod/init/bash

module purge
set -eux

MODROOT=/large/ricky/app/
APP=musl
VER=1.2.4

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# https://qiita.com/6in/items/3544cec69dd53960c2df
# https://qiita.com/sile/items/e9d331b3b06565728d1d
wget http://www.musl-libc.org/releases/musl-${VER}.tar.gz

tar xzvf musl-${VER}.tar.gz
rm -f musl-${VER}.tar.gz
cd musl-${VER}

./configure --disable-shared --prefix=$APPDIR/$VER
make install

cd ..
rm -rf musl-${VER}

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())
-- Package settings
prepend_path("PATH", pathJoin(apphome, "bin"))
__END__

# occasionally raise error due to wrong HPC_OS_VER_MAJOR == 8
#cat <<__END__ >$APP/$VER.lua
#-- Default settings
#local modroot    = "$MODROOT"
#local appname    = myModuleName()
#local appversion = myModuleVersion()
#local apphome    = pathJoin(modroot, myModuleFullName())
#-- Package settings
#if mode() == "load" then
#    depends_on('hpcenv')
#end
#
#if (os.getenv("HPC_OS_VER_MAJOR") == "8") then
#    prepend_path("PATH", pathJoin(apphome, "bin"))
#else
#	LmodError("NotImplementedError: use CentOS8.")
#end
#
#if mode() == "unload" then
#    depends_on('hpcenv')
#end
#__END__

# occasionally raise error due to wrong os_ver==8
#cd $MODROOT/.modulefiles && mkdir -p $APP
#cat <<__END__ >$APP/$VER.lua
#-- Default settings
#local modroot    = "$MODROOT"
#local appname    = myModuleName()
#local appversion = myModuleVersion()
#local apphome    = pathJoin(modroot, myModuleFullName())
#execute {
#	cmd="export OS_VER=\$(lsb_release -a | grep \"^Release\" | cut -f2,2 | cut -d'.' -f1,1)",
#	modeA={"load"}
#}
#local os_ver    = os.getenv("OS_VER") or ""
#-- Package settings
#if (os_ver == 8) then
#	prepend_path("PATH", pathJoin(apphome, "build/bin"))
#else
#	error("NotImplementedError: use CentOS8.")
#end
#__END__
#

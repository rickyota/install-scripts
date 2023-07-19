#!/bin/bash

#TODO:  check if centos 8
# chekc if work with centos7 or not


OS_VER=$(lsb_release -r | cut -f2,2 | cut -d'.' -f1,1)
if [[ ${OS_VER} != "8" ]]; then
    echo "use centos8"
    exit 1
fi

# how to avoid source here?
#source /bio/lmod-rl8/lmod/lmod/init/bash
#OS_VER=$(lsb_release -a | grep "^Release" | cut -f2,2 | cut -d'.' -f1,1)
OS_VER=$(lsb_release -r | cut -f2,2 | cut -d'.' -f1,1)
if [[ ${OS_VER} == "8" ]]; then
    source /bio/lmod-rl8/lmod/lmod/init/bash
else
    source /bio/lmod/lmod/init/bash
fi

#module avail

module purge
set -eux

MODROOT=/nfs/data06/ricky/app
APP=musl
# should split MODROOT?
#OSVER=centos8
VER=1.2.4

APPDIR=$MODROOT/$APP #/$OSVER
mkdir -p $APPDIR && cd $APPDIR


# not sure need this?
module load clang/16.0.2

# not necessary?
##module load gcc/9.2.0
##module load glibc/2.17

# TODO: add centosver to path
OS_VER=$(lsb_release -a | grep "^Release" | cut -f2,2 | cut -d'.' -f1,1)
#CENTOSVER=centos${OS_VER}


# https://qiita.com/6in/items/3544cec69dd53960c2df
# https://qiita.com/sile/items/e9d331b3b06565728d1d
#wget http://www.musl-libc.org/releases/musl-${VER}.tar.gz

#tar xzvf musl-${VER}.tar.gz
#rm -f  musl-${VER}.tar.gz
#cd musl-${VER}
#
#./configure --disable-shared  --prefix=$APPDIR/$VER
#make install
#
#cd ..
#rm -rf musl-${VER}




# TODO: platform detection in lmod
# https://blog.entek.org.uk/notes/2021/07/27/platform-detection-with-lmod.html


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
#!/bin/bash

# raise error even in centos 8
exit 1

#TODO:  check if centos 8
# chekc if work with centos7 or not

# might not necessary
OS_VER=$(lsb_release -r | cut -f2,2 | cut -d'.' -f1,1)
if [[ ${OS_VER} != "8" ]]; then
    echo "use centos8"
    exit 1
fi

# how to avoid source here?
#source /bio/lmod-rl8/lmod/lmod/init/bash
#OS_VER=$(lsb_release -a | grep "^Release" | cut -f2,2 | cut -d'.' -f1,1)
source /bio/lmod/lmod/init/bash

#module avail

module purge
set -eux

MODROOT=/nfs/data06/ricky/app
APP=muslcc
# should split MODROOT?
#OSVER=centos8
VER=11.2.1

APPDIR=$MODROOT/$APP #/$OSVER
mkdir -p $APPDIR && cd $APPDIR

# not sure need this?
#module load clang/16.0.2

# SHOULD run before ml load gcc or glibc
# TODO: add centosver to path
OS_VER=$(lsb_release -r | cut -f2,2 | cut -d'.' -f1,1)
#CENTOSVER=centos${OS_VER}

#set +ux
#module load gcc/9.2.0
#module load glibc/2.17
#set -ux

# https://kateinoigakukun.hatenablog.com/entry/2022/02/18/232723
#curl -LO https://musl.cc/x86_64-linux-musl-native.tgz

#tar xfz x86_64-linux-musl-native.tgz
#rm -f x86_64-linux-musl-native.tgz
#mv x86_64-linux-musl-native ${VER}

cd ${VER}/bin
ln -sf x86_64-linux-musl-cc musl-cc
ln -sf x86_64-linux-musl-gcc musl-gcc
ln -sf x86_64-linux-musl-g++ musl-g++
ln -sf x86_64-linux-musl-gcc x86_64-unknown-linux-musl-gcc
cd -

# still error for rust bindgen
#cd ${VER}
#mkdir -p bin_pkg
#cd bin_pkg
#ln -sf ../bin/x86_64-linux-musl-cc musl-cc
#ln -sf ../bin/x86_64-linux-musl-gcc musl-gcc
#ln -sf ../bin/x86_64-linux-musl-g++ musl-g++
#ln -sf ../bin/x86_64-linux-musl-gcc x86_64-unknown-linux-musl-gcc
#cd -

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
if mode() == "load" then
    depends_on('hpcenv')
end

if (os.getenv("HPC_OS_VER_MAJOR") == "8") then
    prepend_path("PATH", pathJoin(apphome, "bin"))
else
	LmodError("NotImplementedError: use CentOS8.")
end

if mode() == "unload" then
    depends_on('hpcenv')
end
__END__

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

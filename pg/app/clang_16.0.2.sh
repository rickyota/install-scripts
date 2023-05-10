#!/bin/bash

#TODO:  check if centos 8
# chekc if work with centos7 or not



# how to avoid source here?
#source /bio/lmod-rl8/lmod/lmod/init/bash
OS_VER=$(lsb_release -a | grep "^Release" | cut -f2,2 | cut -d'.' -f1,1)
if [[ ${OS_VER} == "8" ]]; then
    source /bio/lmod-rl8/lmod/lmod/init/bash
else
    source /bio/lmod/lmod/init/bash
fi

#module avail

module purge
set -eux

MODROOT=/nfs/data06/ricky/app
APP=clang
# should split MODROOT?
#OSVER=centos8
VER=16.0.2

APPDIR=$MODROOT/$APP #/$OSVER
mkdir -p $APPDIR && cd $APPDIR

#module load gcc/9.2.0
#module load glibc/2.17

# TODO: add centosver to path
OS_VER=$(lsb_release -a | grep "^Release" | cut -f2,2 | cut -d'.' -f1,1)
#CENTOSVER=centos${OS_VER}

## download v16.0.2
## https://clang.llvm.org/get_started.html
#wget https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-${VER}.zip
#unzip llvmorg-${VER}.zip
#mv llvm-project-llvmorg-${VER} ${VER}
#cd ${VER}
#mkdir build
#cd build
#cmake -DLLVM_ENABLE_PROJECTS=clang -DCMAKE_BUILD_TYPE=Release -D CMAKE_C_COMPILER=gcc -D CMAKE_CXX_COMPILER=g++ -G "Unix Makefiles" ../llvm
#make



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
prepend_path("PATH", pathJoin(apphome, "build/bin"))
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
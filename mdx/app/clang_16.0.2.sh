#!/bin/bash


# ~12h


source /large/share/app/lmod/bash

module purge
set -eux

MODROOT=/large/ricky/app/
APP=clang
VER=16.0.2

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

#module load gcc/9.2.0


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


# need gcc/9 ?
# -> but only in z*

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


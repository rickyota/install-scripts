#!/bin/bash


#OS_VER=$(lsb_release -r | cut -f2,2 | cut -d'.' -f1,1)
#if [[ ${OS_VER} != "7" ]]; then
#    echo "build in centos7, and you can use in centos8."
#    exit 1
#fi


#if [[ ${OS_VER} == "8" ]]; then
#    source /bio/lmod-rl8/lmod/lmod/init/bash
#else
#    source /bio/lmod/lmod/init/bash
#fi

#module avail

module purge
set -eux

MODROOT=/work/gg57/j29002/app/
APP=clang
VER=16.0.2

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

module load gcc/7.5.0


## download v16.0.2
## https://clang.llvm.org/get_started.html
wget https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-${VER}.zip
unzip llvmorg-${VER}.zip
mv llvm-project-llvmorg-${VER} ${VER}
cd ${VER}
mkdir build
cd build
cmake -DLLVM_ENABLE_PROJECTS=clang -DCMAKE_BUILD_TYPE=Release -D CMAKE_C_COMPILER=gcc -D CMAKE_CXX_COMPILER=g++ -G "Unix Makefiles" ../llvm
make



cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("gcc/7.5.0")
prepend_path("PATH", pathJoin(apphome, "build/bin"))
__END__


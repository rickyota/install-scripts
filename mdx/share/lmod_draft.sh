#!/bin/bash

set -eux

TMPDIR="./tmp"

cd $TMPDIR

wget https://sourceforge.net/projects/lmod/files/lua-5.1.4.9.tar.bz2
wget https://sourceforge.net/projects/lmod/files/Lmod-8.7.tar.bz2

tar xf lua-5.1.4.9.tar.bz2
tar xf Lmod-8.7.tar.bz2

# lua
cd lua-5.1.4.9

mkdir ./install
./configure --prefix=$(readlink -f ./install) --with-static=YES
make
make install

cd -

# lmod
tar xf ./Lmod-8.7.tar.bz2
cd ./Lmod-8.7

LUA_DIR="/large/ricky/env/install-scripts/mdx/share/tmp/lua-5.1.4.9/install"

export LUA_CPATH="/large/ricky/env/install-scripts/mdx/share/tmp/lua-5.1.4.9/luaposix/posix.so;;"

./configure --prefix=/large/share/app/lmod --with-lua_include=${LUA_DIR}/include/ --with-lua=${LUA_DIR}/bin/lua --with-luac=${LUA_DIR}/bin/luac --with-tcl=no

make install

# in share/

ln -s ./lmod/8.7/init/bash .


# call `source /large/share/app/lmod/bash`
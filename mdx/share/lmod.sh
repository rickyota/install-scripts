#!/bin/bash 

# activate by 
# $ source /large/share/app/lmod/bash


set -eux


# old
#TMP="/large/ricky/env/install-scripts/mdx/share/tmp/"

APPDIR="/large/share/app/lmod/"

LUADIR="${APPDIR}/lua-5.1.4.9/"

mkdir -p $APPDIR && cd $APPDIR

# install lua
wget https://sourceforge.net/projects/lmod/files/lua-5.1.4.9.tar.bz2
tar jxvf lua-5.1.4.9.tar.bz2
cd lua-5.1.4.9
mkdir -p install
./configure --prefix=$(readlink -f ./install) --with-static=YES
make
make install
cd ..



# install lmod
wget https://sourceforge.net/projects/lmod/files/Lmod-8.7.tar.bz2
tar jxvf Lmod-8.7.tar.bz2
cd Lmod-8.7
./configure --prefix="$APPDIR" \
	--with-lua_include=${LUADIR}/install/include/ \
	--with-lua=${LUADIR}/install/bin/lua \
	--with-luac=${LUADIR}/install/bin/luac \
	--with-tcl=no

# I remember the above failed..., some option should be added
#    -> 231201, when install again, no problem without lua-posix
# add --lua-posix (?)
# --lua-posix=${TMP}/lua-5.1.4.9/luaposix/posix.so
# or
# --lua-posix=${TMP}/lua-5.1.4.9/install/lib/lua/5.1/posix.so

make install


cd $APPDIR
ln -s ./lmod/lmod/init/bash ./bash


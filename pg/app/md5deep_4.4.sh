#!/bin/bash


# https://github.com/jessek/hashdeep
# https://md5deep.sourceforge.net/start-md5deep.html

source /bio/lmod/lmod/init/bash

module purge
set -eux

# could not install 240809
# due to unknown error
exit 1

MODROOT=/nfs/data06/ricky/app
APP=md5deep
VER=4.4

APPDIR=$MODROOT/$APP #/$OSVER
mkdir -p $APPDIR && cd $APPDIR


module load perl/5.34.1

echo $PERL5LIB
export PERL5LIB="/nfs/data05/yoshihiko_s/app/perl/5.34.1/lib/5.34.1:/nfs/data05/yoshihiko_s/app/perl/5.34.1/lib/site_perl/5.34.1:/nfs/data05/yoshihiko_s/app/perl/5.34.1/bin"

#export PERL5LIB="/nfs/data05/yoshihiko_s/app/perl/5.34.1/lib/5.34.1/:/nfs/data05/yoshihiko_s/app/perl/5.34.1/lib/site_perl/5.34.1/:$PERL5LIB"
#export PERL5LIB="/nfs/data05/yoshihiko_s/app/perl/5.34.1/lib/5.34.1/:/nfs/data05/yoshihiko_s/app/perl/5.34.1/lib/site_perl/5.34.1/:$PERL5LIB"


wget -O - https://github.com/jessek/hashdeep/archive/refs/tags/v${VER}.tar.gz | tar zxvf -
mv hashdeep-${VER} ${APP}-${VER}
mkdir $VER
cd $APP-$VER
sh bootstrap.sh
./configure --prefix=$APPDIR/$VER
make && make install

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

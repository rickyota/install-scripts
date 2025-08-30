#!/bin/bash

# for VScode shell-format extension

source /bio/lmod/lmod/init/bash

module purge
set -eux

MODROOT=/nfs/data06/ricky/app
APP=shfmt
VER=3.12.0

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

curl -s https://api.github.com/repos/mvdan/sh/releases/latest |
	grep "browser_download_url.*linux_amd64" |
	cut -d '"' -f 4 |
	wget -qi -

mkdir -p $VER
chmod +x shfmt_*_linux_amd64
mv shfmt_*_linux_amd64 ${VER}/shfmt

#!/bin/bash

# Before this, I used conda provided in pg and when I install package via conda (e.g. csvkit), I newly downloaded conda in ./app and used it.
# This method can gurantee the independency between pakcages,
# but python path is also changed to use python in local ./app and cannot use conda env I used in default conda. 
# The worst part is you cannot pipe from csvkit to python
# So, I decided try to download conda in lmod and let csvkit use the conda when installing and using it.
# This might disrupt the independency but worth trying it.
# 
# -> You cannot do this...
# since when running csvkit, python provided in default conda/bin is used, but when you want to run python script, you want to use python in conda env
# 
# [ref](http://gregoryzynda.com/python/lmod/module/conda/tensorflow/2020/04/30/conda-modules.html)


source /bio/lmod/lmod/init/bash


module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data06/ricky/app
APP=conda
VER=23.3.1

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

#CONDA_SH=Miniconda3-py310_23.3.1-0-Linux-x86_64.sh
#curl -O https://repo.anaconda.com/miniconda/${CONDA_SH}
#sh ${CONDA_SH} -b -p $APPDIR/$VER
#
#rm ${CONDA_SH}

# error: invalid option
echo "ny: error when ml conda"
exit 1


set +u

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())


-- local conda_dir = "${CONDA_DIR}"
local conda_dir = apphome
local funcs = "conda __conda_activate __conda_hashr __conda_reactivate __add_sys_prefix_to_path"

-- Specify where system and user environments should be created
-- setenv("CONDA_ENVS_PATH", os.getenv("SCRATCH") .. "/conda_local/envs:" .. conda_dir .. "/envs")
-- Directories are separated with a comma
-- setenv("CONDA_PKGS_DIRS", os.getenv("SCRATCH") .. "/conda_local/pkgs," .. conda_dir .. "/pkgs")

-- Initialize conda
execute{cmd="source " .. conda_dir .. "/etc/profile.d/conda.sh; export -f " .. funcs, modeA={"load"}}
-- Unload environments and clear conda from environment
execute{cmd="for i in $(seq ${CONDA_SHLVL:=0}); do conda deactivate; done; pre=" .. conda_dir .. "; \
	export LD_LIBRARY_PATH=$(echo ${LD_LIBRARY_PATH} | tr ':' '\\n' | grep . | grep -v $pre | tr '\\n' ':' | sed 's/:$//'); \
	export PATH=$(echo ${PATH} | tr ':' '\\n' | grep . | grep -v $pre | tr '\\n' ':' | sed 's/:$//'); \
	unset -f " .. funcs .. "; \
	unset $(env | grep -o \"[^=]*CONDA[^=]*\");", modeA={"unload"}}

-- Prevent from being loaded with another system python or conda environment
family("python")




__END__







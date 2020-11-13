#!/bin/bash

# Uncomment to enable "debugging" of the script
# set -x

# FlightGearBuilder.sh
builderversion="v0.3"

# CHANGELOG
# v0.3
# No longer creates launcher at .local/bin and no longer changes PATH.
# Moved some OSD git URL to variable.
# Moved nproc to variable.

### AUTHOR
# This software was created by Megaf - https://github.com/Megaf
# On the 20/10/2020

### LICENSE
########################################################################
#                                                                      #
#                       FREE AS IN FREEDOM LICENSE                     #
#                           FAIFL Version 0.2                          #
#                             October 2020                             #
#                                                                      #
#           Copyright (C) 2020 Megaf (https://github.com/Megaf/)       #
#                     <mmegaf [at] gmail [dot] com>                    #
#                                                                      #
# Everyone, anyone, anything or any company or organization, human,    #
# plant, apache helicopter, alive or not, form of life or not, is/are  #
# allowed to copy, modify, distribute, change, charge or do anything   #
# they/ones want with anything or whatever this license is, attached   #
# to or licensing.                                                     #
#                                                                      #
# This thing, software, hardware, piece, object, art, or whatever that #
# is been licensed under FAIFL (Free As In Freedom License) can be     #
# used, shared, copied, sold, modified, changed, adapted, or whatever  #
# you want to do as long as the following terms are understood and met.#
#                                                                      #
# (1) This that is licensed under FAIFL comes as it is.                #
# (2) This that is licensed under FAIFL it is not covered under any    #
# warranty.                                                            #
# (3) There is no warranty or guarantee that this that is licensed     #
# under FAIFL works at all.                                            #
# (4) This that is licensed under FAIFL may be dangerous and cause     #
# harm and loss of property.                                           #
# (5) Changing this license is not allowed.                            #
# (6) The creator, owner, author of this that is licensed under FAIFL  #
# shall not be liable,responsible or accused in any way for anything   #
# at all.                                                              #
#                                                                      #
########################################################################

### ABOUT THIS SOFTWARE
# This script will download, from Git repositories, the source code for
# the OpenSceneGraph, PLIB, SimGear libraries and
# FlightGear Flight Simulator.
#
# After that, everything will be compiled from scratch according to
# the flags and variables set bellow.


# Uses ccache (https://ccache.dev/) if it's available, to speed rebuilds
export PATH="/usr/lib/ccache:${PATH}"

# Directory where everything will be installed at.
installdir="$HOME/FlightGear"
# Directory where the source codes will be downloaded to.
tempdir="/tmp/FlightGear_Sources"
# Temporary directory where cmake will run from.
buildir="/dev/shm/FlightGear_Compiler_Output"

# Compiler flags
cflags="-m64 -march=native -mavx -mtune=core2 -O2 -pipe -mfpmath=both -flto -fomit-frame-pointer"
buildtype="Release"

# Creating directories where cmake will run from.
mkdir -p $buildir/OSG $buildir/PLIB $buildir/SimGear $buildir/FlightGear

# Variables defining which branches will be used for each repository.
fgbranch="next" # Branches for FlightHear and SimGear
osgbranch="fgfs-342-1" # Branch for OpenSceneGraph
osgurl="https://github.com/zakalawe/osg/" # OSG Git repo to use
ncores="$(nproc)" # Sets the number of compiler tasks according to numer of logical cpus


### INTRODUCTION PART
clear
echo "#====== Welcome to FlightGearBuilder $builderversion !"
echo "#====== This script will download OpenSceneGraph, PLIB, SimGear and FLightGear."
echo ""
echo "#====== If you want to download fgdata too press ctrl + c and rerun this script"
echo "#====== with the flag --get-fgdata. You can run the script DownloadFGdata.sh at any time to download fgdata on its own."
echo ""
# Waits for the user to press a key to continue.
echo "#====== Press any key to continue."
read -rsn1
clear

### CHECKS AND GIT CLONE
# We will perform a series of checks to see if the repos were cloned
# already or not, if they were not cloned yet, then git clone will run,
# Otherwise, the script will try to update, git pull, the repos.

echo ""
echo "#====== Downloading Source Codes and Building Started."

# Checking OpenSceneGraph
echo ""
echo "#====== Checking if OpenSceneGraph was already downloaded."
if [ -d "$tempdir/OSG" ]; then
echo "#======  OpenSceneGraph found, updating the repo if neded."
cd $tempdir/OSG && git pull
else
echo "#====== OpenSceneGraph not found, downloading now."
#git clone --depth=1 -b $osgbranch https://github.com/openscenegraph/OpenSceneGraph/ $tempdir/OSG
git clone --depth=1 -b $osgbranch $osgurl $tempdir/OSG
fi

# Checking PLIB
echo ""
echo "#====== Checking if PLIB was already downloaded."
if [ -d "$tempdir/PLIB" ]; then
echo "#======  PLIB found, updating the repo if neded."
cd $tempdir/PLIB && git pull
else
echo "#====== PLIB not found, downloading now."
git clone --depth=1 https://git.code.sf.net/p/libplib/code $tempdir/PLIB
fi

# Checking SimGear
echo ""
echo "#====== Checking if SimGear was already downloaded."
if [ -d "$tempdir/SimGear" ]; then
echo "#======  SimGear found, updating the repo if neded."
cd $tempdir/SimGear && git pull
else
echo "#====== SimGear not found, downloading now."
git clone --depth=1 -b $fgbranch git://git.code.sf.net/p/flightgear/simgear $tempdir/SimGear
fi

# Checking FlightGear
echo ""
echo "#====== Checking if FlightGear was already downloaded."
if [ -d "$tempdir/FlightGear" ]; then
echo "#======  FlightGear found, updating the repo if neded."
cd $tempdir/FlightGear && git pull
else
echo "#====== FlightGear not found, downloading now."
git clone --depth=1 -b $fgbranch git://git.code.sf.net/p/flightgear/flightgear $tempdir/FlightGear
fi

# Checking FlightGear Data.
echo ""
echo "#====== Checking if FlightGear data was already downloaded."
if [ -d "$installdir/data" ]; then
echo "#======  FlightGear Data found, updating the repo if neded."
cd $installdir/data && git pull
fi

# If the user uses the flag --get-fgdata then the script will download fgdata.
# FlightGear Data clone will be running in background while the script
# is doing everything else.
if [ $*="--get-fgdata" ]; then
echo "#====== Downloading FGFATA."
echo "#====== FlightGear Data will be downloaded in background while FlightGear Builder"
echo "#====== compiles the other components."
git clone --depth=1 -b $fgbranch git://git.code.sf.net/p/flightgear/fgdata $installdir/data &
fi

# Now the script will run cmake and make and make install
# for each component.
echo ""
echo "#====== Compiling OpenSceneGraph."
cd $buildir/OSG && cmake $tempdir/OSG -DCMAKE_BUILD_TYPE="$buildtype" -DOpenGL_GL_PREFERENCE=LEGACY -DCMAKE_CXX_FLAGS_RELEASE="$cflags" -DCMAKE_C_FLAGS_RELEASE="$cflags" -DCMAKE_INSTALL_PREFIX=$installdir
make -j $ncores && echo "#====== Installing OpenSceneGraph." && make install && rm -rf $buildir/OSG
echo "#====== If something went wrong when compiling OpenSceneGraph then make sure"
echo "#====== you have all dependencies required."

echo ""
echo "#====== Compiling PLIB."
cd $buildir/PLIB && cmake $tempdir/PLIB -DCMAKE_BUILD_TYPE="$buildtype" -DOpenGL_GL_PREFERENCE=LEGACY -DCMAKE_CXX_FLAGS_RELEASE="$cflags" -DCMAKE_C_FLAGS_RELEASE="$cflags" -DCMAKE_INSTALL_PREFIX=$installdir
make -j $ncores && echo "#====== Installing PLIB." && make install&& rm -rf $buildir/PLIB
echo "#====== If something went wrong when compiling PLIB then make sure"
echo "#====== you have all dependencies required."

echo ""
echo "#====== Compiling SimGear."
cd $buildir/SimGear && cmake $tempdir/SimGear -DCMAKE_BUILD_TYPE="$buildtype" -DENABLE_SIMD=ON -DCMAKE_CXX_FLAGS_RELEASE="$cflags" -DCMAKE_C_FLAGS_RELEASE="$cflags" -DCMAKE_INSTALL_PREFIX=$installdir
make -j $ncores && echo "#====== Installing SimGear." && make install&& rm -rf $buildir/SimGear
echo "#====== If something went wrong when compiling SimGear then make sure"
echo "#====== you have all dependencies required."

echo ""
echo "#====== Compiling FlightGear."
cd $buildir/FlightGear && cmake $tempdir/FlightGear -DCMAKE_BUILD_TYPE="$buildtype" -DENABLE_SIMD=ON -DCMAKE_CXX_FLAGS_RELEASE="$cflags" -DCMAKE_C_FLAGS_RELEASE="$cflags" -DCMAKE_INSTALL_PREFIX=$installdir
make -j $ncores && echo "#====== Installing FlightGear." && make install && rm -rf $buildir/FlightGear
echo "#====== If something went wrong when compiling FlightGear then make sure"
echo "#====== you have all dependencies required."

# This portion of the script will generate a script to launch flightgear
# by using the standard fgfs command and it's sintaxe.
#
# The directory ~/.local.bin will be created and added to your PATH.

# Creating directory
echo ""
echo "#====== Creating directory $HOME/.local/bin."
mkdir -p $HOME/.local/bin

echo ""
echo "#====== Creating fgfs runner script."
# Creates $installdir/flightgear
cat << EOF > $installdir/flightgear
#!/bin/bash
export LD_LIBRARY_PATH=$installdir/lib:$installdir/lib64:$PATH
export FG HOME=$installdir/FG_HOME
export FG ROOT=$installdir/data
cd $installdir/bin
EOF

# Adds the launcher line to that script.
echo './fgfs $*' >> $installdir/flightgear
# Sets it as executable.
chmod +x $installdir/flightgear

# Checking if the file was created.
if [ -e $installdir/flightgear ]; then
echo ""
echo "#====== fgfs runner created."
else
echo ""
echo "#====== Something went wrong when creating fgfs runner."
fi

echo ""
echo "#====== Done. Enter $installdir and run $installdir/flightgear to estar the sim. The command flightgear will take the same arguments as fgfs, such as flightgear --launcher"
echo ""
echo "#====== If everything went well then you can run FlightGear"
echo "#====== by running the command fgfs or fgfs --launcher."
echo ""
echo "#====== Feel free to ask for help and contribute to this script at"
echo "#====== https://github.com/Megaf/FlightGearBuilder "
echo ""

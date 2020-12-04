#!/bin/bash

# FlightGearBuilder.sh

# CHANGELOG
# v0.8.20201204
# Added more code comments.
# Changed EOF section to add fgfs runner in one step.
# v0.7.20201202
# OSG broken with GLNV, reverting back to LEGACY.
# Fix some typos.
# Removing script to download FGData. Alternative will be given in the text interface.
# Including release date with release version.
# Now some clean up is done prior running the script, for cleaner builds.
# v0.6
# Fix bad bad bad typos and variables declarations to flightgear runner.
# Added Spaces and empty lines to CLI.
# Defaulting back to release/2020.3.
# GLVND driver is default now, before it was LEGACY.
# v0.5
# Switched OSG to OSGs official GIT repo and to branch 3.6.
# Compiling flags are now more conservative.
# Minor text tweaks and code changes.
# v0.4
# No longer downloads FlightGear data. DownloadFGdata.sh should be used for that instead.
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
cflags="-march=x86-64 -mtune=generic -O2 -pipe -mfpmath=both" # Replace x86064 and generic with native for more optimization. Leave it as it is to run in other CPUs.
buildtype="Release" # Build type, Release for better performance. All flags in this script are for Release type.

rm -rf $buildir # Deleting old build files, for a clean build.
rm -rf $installdir/bin $installdir/lib $installdir/include # Delete old installed binaries and libs.
# Creating directories where cmake will run from.
mkdir -p $buildir/OSG $buildir/PLIB $buildir/SimGear $buildir/FlightGear

# Variables defining which branches will be used for each repository.
builderversion="v0.7.20201204" # Declaring build version
fgbranch="release/2020.3" # Branch for FlightHear
sgbranch="release/2020.3" # Branch for SimGear
osgbranch="OpenSceneGraph-3.6" # Branch for OpenSceneGraph
osgurl="https://github.com/openscenegraph/OpenSceneGraph" # OSG Repository
ncores="$(nproc)" # Sets the number of compiler tasks according to number of logical cpus in your system

### INTRODUCTION PART
clear
echo ""
echo "#====== Welcome to FlightGearBuilder $builderversion !"
echo "#====== This script will download OpenSceneGraph, PLIB, SimGear and FlightGear."
echo ""
echo "#====== This script will not donwload nor update FlightGear Data. To do that,"
echo "#====== you can either download the correct version from http://download.flightgear.org/builds/ "
echo "#====== For example, the file FlightGear-2020.3.4-data.tar.bz2"
echo ""
echo "#====== Or you can use git clone -b version (next for testing or correct version, like release/2020.3) git://git.code.sf.net/p/flightgear/fgdata "
# Waits for the user to press a key to continue.
echo ""
echo ""
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
cd $tempdir/OSG && git pull # Try to update existing previously cloned repo.
else
echo "#====== OpenSceneGraph not found, downloading now."
git clone --depth=1 -b $osgbranch $osgurl $tempdir/OSG # Clone repo from Git
fi

# Checking PLIB
echo ""
echo "#====== Checking if PLIB was already downloaded."
if [ -d "$tempdir/PLIB" ]; then
echo "#======  PLIB found, updating the repo if neded."
cd $tempdir/PLIB && git pull # Try to update existing previously cloned repo.
else
echo "#====== PLIB not found, downloading now."
git clone --depth=1 https://git.code.sf.net/p/libplib/code $tempdir/PLIB # Clone repo from Git
fi

# Checking SimGear
echo ""
echo "#====== Checking if SimGear was already downloaded."
if [ -d "$tempdir/SimGear" ]; then
echo "#======  SimGear found, updating the repo if neded."
cd $tempdir/SimGear && git pull # Try to update existing previously cloned repo.
else
echo "#====== SimGear not found, downloading now."
git clone --depth=1 -b $fgbranch git://git.code.sf.net/p/flightgear/simgear $tempdir/SimGear # Clone repo from Git
fi

# Checking FlightGear
echo ""
echo "#====== Checking if FlightGear was already downloaded."
if [ -d "$tempdir/FlightGear" ]; then
echo "#======  FlightGear found, updating the repo if neded."
cd $tempdir/FlightGear && git pull # Try to update existing previously cloned repo.
else
echo "#====== FlightGear not found, downloading now."
git clone --depth=1 -b $fgbranch git://git.code.sf.net/p/flightgear/flightgear $tempdir/FlightGear # Clone repo from Git
fi

# Now the script will run cmake and make and make install for each component.
echo ""
echo "#====== Compiling OpenSceneGraph."
cd $buildir/OSG && cmake $tempdir/OSG -DCMAKE_BUILD_TYPE="$buildtype" -DOpenGL_GL_PREFERENCE=LEGACY -DCMAKE_CXX_FLAGS_RELEASE="$cflags" -DCMAKE_C_FLAGS_RELEASE="$cflags" -DCMAKE_INSTALL_PREFIX=$installdir
make -j $ncores && echo "#====== Installing OpenSceneGraph." && make install && rm -rf $buildir/OSG

echo ""
echo "#====== If something went wrong when compiling OpenSceneGraph then make sure"
echo "#====== you have all dependencies required."

echo ""
echo "#====== Compiling PLIB."
cd $buildir/PLIB && cmake $tempdir/PLIB -DCMAKE_BUILD_TYPE="$buildtype" -DOpenGL_GL_PREFERENCE=LEGACY -DCMAKE_CXX_FLAGS_RELEASE="$cflags" -DCMAKE_C_FLAGS_RELEASE="$cflags" -DCMAKE_INSTALL_PREFIX=$installdir
make -j $ncores && echo "#====== Installing PLIB." && make install&& rm -rf $buildir/PLIB

echo ""
echo "#====== If something went wrong when compiling PLIB then make sure"
echo "#====== you have all dependencies required."

echo ""
echo "#====== Compiling SimGear."
cd $buildir/SimGear && cmake $tempdir/SimGear -DCMAKE_BUILD_TYPE="$buildtype"  -DBUILD_TESTING=OFF -DENABLE_TESTS=OFF -DENABLE_SIMD_CODE=ON -DENABLE_SIMD=ON -DCMAKE_CXX_FLAGS_RELEASE="$cflags" -DCMAKE_C_FLAGS_RELEASE="$cflags" -DCMAKE_INSTALL_PREFIX=$installdir
make -j $ncores && echo "#====== Installing SimGear." && make install&& rm -rf $buildir/SimGear
echo "#====== If something went wrong when compiling SimGear then make sure"
echo "#====== you have all dependencies required."

echo ""
echo "#====== Compiling FlightGear."
cd $buildir/FlightGear && cmake $tempdir/FlightGear -DCMAKE_BUILD_TYPE="$buildtype" -DSYSTEM_FLITE=OFF -DENABLE_AUTOTESTING=OFF -DENABLE_SIMD=ON -DCMAKE_CXX_FLAGS_RELEASE="$cflags" -DCMAKE_C_FLAGS_RELEASE="$cflags" -DCMAKE_INSTALL_PREFIX=$installdir
make -j $ncores && echo "#====== Installing FlightGear." && make install && rm -rf $buildir/FlightGear

echo ""
echo "#====== If something went wrong when compiling FlightGear then make sure"
echo "#====== you have all dependencies required."

echo ""
echo "#====== Creating fgfs runner script."

# Creates $installdir/flightgear
# To learn more about fg home and root read http://wiki.flightgear.org/$FG_HOME and http://wiki.flightgear.org/$FG_ROOT
 
# Creates $installdir/flightgear
cat << EOF > $installdir/flightgear
#!/bin/bash
export LD_LIBRARY_PATH=$installdir/lib
export FG_HOME=$installdir/FG_HOME
export FG_ROOT=$installdir/data
$installdir/bin/fgfs \$*
EOF

chmod +x $installdir/flightgear # Sets it as executable

# Checking if the file was created.
if [ -e $installdir/flightgear ]; then

echo ""
echo "#====== fgfs runner created."
else
echo ""
echo "#====== Something went wrong when creating fgfs runner."
fi

echo ""
echo "#====== Done. Enter $installdir and run $installdir/flightgear to start the sim."
echo "#====== The command flightgear will take the same arguments as fgfs, such as flightgear --launcher" 
echo ""
echo "#====== If everything went well then you can run FlightGear"
echo "#====== by running the command flightgear or flightgear --launcher."
echo ""
echo "#====== Feel free to ask for help and contribute to this script at"
echo "#====== https://github.com/Megaf/FlightGearBuilder "
echo ""

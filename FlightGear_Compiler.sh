#!/bin/bash

### ABOUT
# FlightGear_Compiler.sh
# This script will compile from the source code OpenSceneGraph,
# PLIB, SimGear and FlightGear.

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

# Using read command to get version information from the file VERSION
read -r version < VERSION

# Direcotry where the source files will be downloaded to.
download_directory="$HOME"/FlightGear-Stable_Source_Files
install_directory="$HOME"/FlightGear-Stable
compiler_out_directory="/dev/shm/FlightGear-Stable"
release="Stable"

# By default, without command line arguments the script will download the stable
# version of FlightGear, the following "if" statement downloads the "next"
# development version of FlightGear.
#
# It will also install FlightGear to folder name FlightGear-Next instead of 
# FlightGear-Stable
if [ "$*" = "--next" ]; then
    download_directory="$HOME"/FlightGear-Next_Source_Files
    install_directory="$HOME"/FlightGear-Next
    compiler_out_directory="/dev/shm/FlightGear-Next"
    release="Next"
fi

# Uses ccache (https://ccache.dev/) if it's available, to speed rebuilds
export PATH="/usr/lib/ccache:${PATH}"

# Compiler flags
cflags="-Wno-implicit-fallthrough -Wno-deprecated-copy -Wno-dev -march=native -mtune=native -O2 -pipe"
#cflags="-march=x86-64 -mtune=generic -Os -pipe -mfpmath=both"

buildtype="Release" # Build type, Release for better performance. All flags in this script are for Release type.

# Variables defining which branches will be used for each repository.
ncores="$(nproc)" # Sets the number of compiler tasks according to number of logical cpus in your system

# Creating directories where cmake will run from.
mkdir -p "$compiler_out_directory"/OSG "$compiler_out_directory"/PLIB "$compiler_out_directory"/SimGear "$compiler_out_directory"/FlightGear

### INTRODUCTION PART
clear
echo ""
echo "#====== Welcome to FlightGearBuilder $version !"
echo "#====== This script will compile OpenSceneGraph, PLIB, SimGear and FlightGear."

# Waits for the user to press a key to continue.
echo ""
echo "#====== Press any key to continue or Ctrl + C to cancel."
read -rsn1
clear

# Checking deps with cmake and compiling each component with make.
# Compiling OSG
echo ""
echo "#====== Compiling OpenSceneGraph."
cd "$compiler_out_directory"/OSG && cmake "$download_directory"/OSG -DCMAKE_BUILD_TYPE="$buildtype" -DOpenGL_GL_PREFERENCE=LEGACY -DCMAKE_CXX_FLAGS_RELEASE="$cflags" -DCMAKE_C_FLAGS_RELEASE="$cflags" -DCMAKE_INSTALL_PREFIX="$install_directory"
make -j "$ncores" && make -j "$ncores" install

# Compiling PLIB
echo ""
echo "#====== Compiling PLIB."
cd "$compiler_out_directory"/PLIB && cmake "$download_directory"/PLIB -DCMAKE_BUILD_TYPE="$buildtype" -DOpenGL_GL_PREFERENCE=LEGACY -DCMAKE_CXX_FLAGS_RELEASE="$cflags" -DCMAKE_C_FLAGS_RELEASE="$cflags" -DCMAKE_INSTALL_PREFIX="$install_directory"
make -j "$ncores" && make -j "$ncores" install

# Compiling SimGear
echo ""
echo "#====== Compiling SimGear."
cd "$compiler_out_directory"/SimGear && cmake "$download_directory"/SimGear -DCMAKE_BUILD_TYPE="$buildtype"  -DBUILD_TESTING=OFF -DENABLE_TESTS=OFF -DENABLE_SIMD_CODE=ON -DENABLE_SIMD=ON -DCMAKE_CXX_FLAGS_RELEASE="$cflags" -DCMAKE_C_FLAGS_RELEASE="$cflags" -DCMAKE_INSTALL_PREFIX="$install_directory"
make -j "$ncores" && make -j "$ncores" install

# Compiling FlightGear
echo ""
echo "#====== Compiling FlightGear."
cd "$compiler_out_directory"/FlightGear && cmake "$download_directory"/FlightGear -DCMAKE_BUILD_TYPE="$buildtype" -DSYSTEM_FLITE=OFF -DENABLE_AUTOTESTING=OFF -DENABLE_SIMD=ON -DCMAKE_CXX_FLAGS_RELEASE="$cflags" -DCMAKE_C_FLAGS_RELEASE="$cflags" -DCMAKE_INSTALL_PREFIX="$install_directory"
make -j "$ncores" && make -j "$ncores" install

echo ""
echo "#====== If something went wrong when compiling FlightGear then make sure"
echo "#====== you have all dependencies required."

echo ""
echo "#====== Creating fgfs runner script."

# Creates $installdir/flightgear
# To learn more about fg home and root read http://wiki.flightgear.org/$FG_HOME and http://wiki.flightgear.org/$FG_ROOT

FG_HOME="$install_directory"/fghome
FG_ROOT="$install_directory"/data
FG_SCENERY="$install_directory"/scenery
FG_AIRCRAFT="$install_directory"/aircraft
FG_LOG="$install_directory"/logs

mkdir -p "$FG_HOME"
mkdir -p "$FG_SCENERY"
mkdir -p "$FG_AIRCRAFT"
mkdir -p "$FG_LOG"

# Creates $installdir/flightgear
cat << EOF > "$install_directory"/flightgear
#!/bin/bash
export OSG_NUM_DATABASE_THREADS=$(expr $(nproc) '*' 2)
export OSG_OPTIMIZER=REMOVE_REDUNDANT_NODES
export OSG_NUM_HTTP_DATABASE_THREADS=$(expr $(nproc) '*' 2)
export OSG_GL_TEXTURE_STORAGE=on
export OSG_COMPILE_CONTEXTS=on
export FG_PROG="$install_directory"
export LD_LIBRARY_PATH="$install_directory"/lib
export FG_HOME="$FG_HOME"
export FG_ROOT="$FG_ROOT"
export FG_SCENERY="$FG_SCENERY"
"$install_directory"/bin/fgfs --disable-hud-3d --prop:/sim/rendering/multithreading-mode=CullThreadPerCameraDrawThreadPerContext --prop:/sim/gui/current-style=0 --prop:/sim/nasal-gc-threaded=true --fg-aircraft="$FG_AIRCRAFT" --prop:/sim/rendering/cache=true --prop:/sim/rendering/multithreading-mode=CullThreadPerCameraDrawThreadPerContext --prop:/sim/gui/current-style=0 --prop:/sim/nasal-gc-threaded=true --terrasync-dir="$FG_SCENERY" --log-level=info --log-dir=$FG_LOG \$*
EOF
chmod +x "$install_directory"/flightgear # Sets it as executable

echo ""
echo "#====== Creating a Desktop shortcut for FlightGear-$release"

# Creates desktop luncher
cat << EOF > "$HOME"/Desktop/FlightGear-$release.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.4
Type=Application
Categories=Game;Simulation
Terminal=false
Icon=$install_directory/share/icons/hicolor/scalable/apps/flightgear.svg
Path=$install_directory
Exec=sh -c "cd $install_directory && ./flightgear --launcher"
Name=FlightGear-$release
Comment=FlightGear-$release Launcher Compiled with FlightGear Builder
Hidden=false
Keywords=Flight Simulator;Simulation;Flight;FlightGear;FlightGear Builder;FGB;Aviation;Airplanes
EOF
chmod +x "$HOME"/Desktop/FlightGear-$release.desktop # Sets it as executable

echo ""
echo "#====== Adding FlightGear-$release menu entry."

mkdir -p $HOME/.local/share/applications # Creating this directory if it doesn't exist
cp "$HOME"/Desktop/FlightGear-$release.desktop $HOME/.local/share/applications/ # Adds FlightGear to the list of software in the users menu.

echo ""
echo "#====== If you don't want the shortcuts, simply delete them from your $HOME/Desktop and $HOME/.local/share/applications"

echo ""
echo "#====== Done. Enter $install_directory and run $install_directory/flightgear to start the sim."
echo "#====== The command flightgear will take the same arguments as fgfs, such as \`flightgear --launcher\`"
echo ""
echo "#====== If everything went well then you can run FlightGear"
echo "#====== by running the command \`./flightgear\` or \`./flightgear --launcher\`."
echo ""
echo "#====== You can also run FlightGear from your Applications menu/launcher or "
echo "#====== searching for flight simulator, simulation, flight or aviation"
echo "#====== in your Applications launcher/GNOME 3."
echo ""
echo "#====== Don't forget to run Download_Data.sh if you want to get FGData."
echo ""
echo "#====== Feel free to ask for help and contribute to this script at"
echo "#====== https://github.com/Megaf/FlightGearBuilder "
echo ""

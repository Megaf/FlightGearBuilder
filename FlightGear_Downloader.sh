#!/bin/bash

### ABOUT
# FlightGear_Downloader.sh
# This script will download, from Git repositories, the source code for
# the OpenSceneGraph, PLIB, SimGear and FlightGear.

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

# Directory where the source files will be downloaded to.
download_directory="$HOME"/FlightGear-Stable_Source_Files

# Git Repository to download the source files from.
openscenegraph_repository="https://github.com/openscenegraph/OpenSceneGraph"
plib_repository="https://git.code.sf.net/p/libplib/code"
simgear_repository="git://git.code.sf.net/p/flightgear/simgear"
flightgear_repository="git://git.code.sf.net/p/flightgear/flightgear"

# Branches/Versions of each component.
openscenegraph_branch="OpenSceneGraph-3.6.5"
plib_branch="master"
#simgear_branch="version/2020.3.6"
#flightgear_branch="version/2020.3.6"
simgear_branch="release/2020.3"
flightgear_branch="release/2020.3"

# By default, without command line arguments the script will download the stable
# version of FlightGear, the following "if" statement downloads the "next"
# development version of FlightGear.
#
# It will also install FlightGear to folder name FlightGear-Next instead of 
# FlightGear-Stable
if [ "$*" = "--next" ]; then
    simgear_branch="next"
    flightgear_branch="next"
    download_directory="$HOME"/FlightGear-Next_Source_Files
fi

### CHECKS AND GIT CLONE
# We will perform a series of checks to see if the repos were cloned
# already or not, if they were not cloned yet, then git clone will run,
# Otherwise, the script will try to update, git pull, the repos.

### INTRODUCTION PART
clear
echo ""
echo "#====== Welcome to FlightGear Downloader $version !"
echo "#====== This script will download OpenSceneGraph, PLIB, SimGear and FlightGear."
echo ""
echo "#====== This script will not download nor update FlightGear Data. To do that,"
echo "#====== you can run the script \`./Download_Data.sh\` in a different terminal window."
echo "#====== While you run \`FlightGear_Downloader.sh\` and \`FlightGear_Compiler.sh\`"

# Waits for the user to press a key to continue.
echo ""
echo "======= Run this script with the flag --next to build the testing/next version of FlightGear."
echo "======= Selected FlighthGear version is $flightgear_branch"
echo ""
echo "#====== Press any key to continue or Ctrl + C to cancel."
read -rsn1
clear

# Checking OpenSceneGraph
echo ""
echo "#====== Checking if OpenSceneGraph was already downloaded."
if [ -d "$download_directory"/OSG ]; then
    echo "#======  OpenSceneGraph found, updating the repo if neded."
    cd "$download_directory"/OSG && git pull # Try to update existing previously cloned repo.
        else
            echo "#====== OpenSceneGraph not found, downloading now."
            git clone --depth=1 -b "$openscenegraph_branch" "$openscenegraph_repository" "$download_directory"/OSG # Clone repo from Git
fi

# Checking PLIB
echo ""
echo "#====== Checking if PLIB was already downloaded."
if [ -d "$download_directory"/PLIB ]; then
    echo "#======  PLIB found, updating the repo if neded."
    cd "$download_directory"/PLIB && git pull # Try to update existing previously cloned repo.
        else
            echo "#====== PLIB not found, downloading now."
            git clone --depth=1 -b "$plib_branch" "$plib_repository" "$download_directory"/PLIB # Clone repo from Git
fi

# Checking SimGear
echo ""
echo "#====== Checking if SimGear was already downloaded."
if [ -d "$download_directory"/SimGear ]; then
    echo "#======  SimGear found, updating the repo if neded."
    cd "$download_directory"/SimGear && git pull # Try to update existing previously cloned repo.
        else
            echo "#====== SimGear not found, downloading now."
            git clone -b "$simgear_branch" "$simgear_repository" "$download_directory"/SimGear # Clone repo from Git
fi

# Checking FlightGear
echo ""
echo "#====== Checking if FlightGear was already downloaded."
if [ -d "$download_directory"/FlightGear ]; then
    echo "#======  FlightGear found, updating the repo if neded."
    cd "$download_directory"/FlightGear && git pull # Try to update existing previously cloned repo.
        else
            echo "#====== FlightGear not found, downloading now."
            git clone -b "$flightgear_branch" "$flightgear_repository" "$download_directory"/FlightGear # Clone repo from Git
fi

echo ""
echo "#====== If everything went well then you can compile FlightGear"
echo "#====== by running the command ./FlightGear_Compiler.sh"
echo "#====== Remember, you can run Download_Data.sh at the same time you"
echo "#====== run any of the other scripts."
echo ""
echo "#====== Feel free to ask for help and contribute to this script at"
echo "#====== https://github.com/Megaf/FlightGearBuilder "
echo ""

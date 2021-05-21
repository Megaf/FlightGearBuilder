#!/bin/bash

### ABOUT
# FlightGear_Data_Downloader.sh
# This script will download, from Git repositories, the data files
# required to run the FlightGear Flight Simulator.

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
install_directory="$HOME/FGB/FGData-Stable"

# Git Repository to download the source files from.
fgdata_repository="git://git.code.sf.net/p/flightgear/fgdata"

# Branches/Versions of each component.
#fgdata_branch="version/2020.3.6"
fgdata_branch="release/2020.3"

# By default, without command line arguments the script will download the stable
# version of FlightGear, the following "if" statement downloads the "next"
# development version of FlightGear.
#
# It will also install FlightGear to folder name FlightGear-Next instead of
# FlightGear-Stable
if [ "$*" = "--next" ]; then
    install_directory="$HOME/FGB/FGData-Next"
    fgdata_branch="next"
fi

### INTRODUCTION PART
clear
echo "#====== Welcome to FlightGearBuilder $version !"
echo "#====== This script will download FlightGear data files."
echo ""
echo "#====== Use --next to download the development version of FGData."
echo ""

# Waits for the user to press a key to continue.
echo ""
echo "#====== Will get data $fgdata_branch - Press any key to continue or Ctrl + C to cancel."
read -rsn1
clear

# Checking FlightGear Data.
echo ""
echo "#====== Checking if FlightGear Data was already downloaded."
if [ -d "$install_directory"/data ]; then
    echo "#======  FlightGear Data found, updating the repo if neded."
    cd "$install_directory"/data && git pull # Try to update existing previously cloned repo.
        else
            echo "#====== FlightGear Data not found, downloading now."
            git clone -b "$fgdata_branch" "$fgdata_repository" "$install_directory"/data # Clone repo from Git
fi

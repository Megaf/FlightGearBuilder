#!/bin/bash

# FlightGearBuilder.sh v0.2
# DownloadFGdata.sh v0.1

### AUTHOR
# This software was created by Megaf - https://github.com/Megaf
# On the 24/10/2020

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
# This script will download, from Git repositories, the FGDATA files.

# Directory where everything will be installed at.
installdir="$HOME/FlightGear"

# Variables defining which branches will be used for each repository.
fgbranch="next" # Branches for FlightHear and SimGear

### CHECKS AND GIT CLONE
# We will perform a series of checks to see if the repos were cloned
# already or not, if they were not cloned yet, then git clone will run,
# Otherwise, the script will try to update, git pull, the repos.

# Checking FlightGear Data.
echo "#====== Checking if FlightGear data was already downloaded."
if [ -d "$installdir/data" ]; then
echo "#======  FlightGear Data found, updating the repo if neded."
cd $installdir/data && git pull
else
echo "#====== FlightGear Data not found, downloading now."
git clone --depth=1 -b $fgbranch git://git.code.sf.net/p/flightgear/fgdata $installdir/data
fi

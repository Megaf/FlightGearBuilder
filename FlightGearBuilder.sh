#!/bin/bash

# First function of this shell script.
# This fuction runs sudo apt to install all dependencies that are required for a complete OSG, SG and FG build. PLIB is listed as a dependency here
# and will not be compiled, but installed from the distros repository.
# This function at the present time is only for Debian based distros.
deb_install_deps() {
    clear
    echo "======================================"
    echo "=> Hello there."
    echo "=> I hope you are having a good time!"
    echo "=> If not, I wish you all the best!"
    echo "--------------------------------------"
    echo "=> - Megaf mmegaf [at] gmail [dot] com"
    echo "======================================"
    echo ""
    echo "=> We are about to install all the dependencies required to compile FlightGear."
    echo "-------------------------------------------------------------------------------"
    echo ""
    echo "=> You will be asked, by sudo, to enter your user password so it can use apt to"
    echo "=> install all the required libs and software."
    echo ""
    echo "=> If you want to skip this step, press Ctrl + c."
    echo ""
    sudo apt install -y subversion build-essential git cmake ccache libgmp-dev subversion libboost-dev libopenal-dev zlib1g-dev liblzma-dev libcurl4-gnutls-dev libjsoncpp-dev libudev-dev libnvtt-dev libnvtt2 libfreetype6-dev libsdl2-dev libsdl2-gfx-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-net-dev libsdl2-ttf-dev libjpeg-dev libxml2-dev libtiff-dev libpng-dev qt5-default qtdeclarative5-dev qttools5-dev qtbase5-dev-tools qttools5-dev-tools qml-module-qtquick2 qml-module-qtquick-window2 qml-module-qtquick-dialogs libqt5opengl5-dev libqt5svg5-dev libqt5websockets5-dev qml-module-qtquick-controls2 libgtk2.0-dev librsvg2-dev libgtkglext1-dev libgtkglextmm-x11-1.2-dev libevent-dev libevent-extra-2.1-6 libevent-pthreads-2.1-6 libglew-dev # libplib-dev
}

# Here we are setting some variables that will be used for the whole script.
HOME="/home/$USER" # This is mostly redundant, we are making sure that the users home is the users home.

# In this first batch of variables we are setting for the stable and default version of FlightGear. ie, without using --next
fg_install="$HOME/FGB/FlightGear-Stable" # Where FlightGear will be installed to.
fg_branch="release/2020.3" # Defining the branch we want to compile against, at the moment Im writing this the latest stable is 2020.3.
osg_branch="OpenSceneGraph-3.6" # Defining branch and version for OpenSceneGraph.
dir="$HOME/FGB/FlightGear-Sources-Stable" # Where the source code for OSG, SG and FG will be kept. A full download is done first. Later updated.
ldlib="export LD_LIBRARY_PATH=$fg_install/lib:$fg_install/lib64" # All our libs are located withing the FG install location.
release_type="Stable" # Will be used to set the launcher name in the desktop and menus.

# This batch of variables are similar to the above, here we simply check if the user wants to build FG Next and adjust variables accordinly.
if [ "$*" = "--next" ]; then
    fg_install="$HOME/FGB/FlightGear-Next"
    fg_branch="next"
    osg_branch="master"
    dir="$HOME/FGB/FlightGear-Sources-Next"
    ldlib="export LD_LIBRARY_PATH=$fg_install/lib"
    release_type="Next"
fi

# Our second function
# Some general variables, defining locations of files and directories for FlightGear.
set_globals() {
    fg_common="$HOME/FGB/FlightGear-Common" # FlightGear-Common is where we put FG_HOME and downloaded content.
    fg_home="$fg_common/FG_HOME" # FG_HOME is where logs and settings live.
    fg_scenery="$fg_common/Scenery" # Scenery will be downloaded by terrasync to Scenery, inside FlightGear-Common. Add custom scenery here.
    fg_aircraft="$fg_common/Aircraft" # Add your downloaded aircraft here, to Aircraft in FlightGear-Common
    export PATH="/usr/lib/ccache:$PATH" # This is so the compiler actually caches what's built, so it can reuse compile code when possible.
    echo "=> Here are our directories."
    echo ""
    echo "=> The downloaded source codes are located at $dir"
    echo "=> FG_HOME, Scenery and Aircraft are located at $fg_common"
    echo "=> Your FG_HOME, the place where the settings and logs live is $fg_home"
    echo "=> TerraSunk will download the scenery to $fg_scenery, you can add custom scenery there."
    echo "=> $fg_aircraft Is where you can put your manually downloaded aircraft."
}

# Third function of our script, how the source will be downloaded
svn_checkout() {
    echo ""
    echo "=> Now downloading $target from $url"
    local to_check="$dir/$target"
    if [ -d "$to_check" ]; then
        cd $to_check && svn update
    else
        svn checkout "$url"/"$target" "$to_check"
    fi
}

git_clone() {
    echo ""
    echo "=> Now downloading $target from $url"
    local to_check="$dir/$target"
    if [ -d "$to_check" ]; then
        cd $to_check && git checkout "$branch" && git pull
    else
        git clone -b "$branch" "$url"/"$target" "$to_check"
    fi
}

compile() {
    echo "oo Compiling $target oo"
    local cc_flags="-w -march=native -mtune=native -Ofast"
    local CXXFLAGS=$cc_flags
    local CFLAGS=$cc_flags
    echo "dir = $dir"
    echo "target = $target"
    cd "$dir/$target"
    ./autogen.sh
    ./configure --prefix="$fg_install"
    make clean && make -j "$(expr $(nproc) '+' 2)"
}

build() {
    echo "oo Compiling $target oo"
    local cc_flags="-w -march=native -mtune=native -Ofast"
    local cmake_flags="-DCMAKE_C_FLAGS=$cc_flags -DCMAKE_CXX_FLAGS=$cc_flags -DCMAKE_INSTALL_PREFIX=$fg_install -DCMAKE_BUILD_TYPE=Release $cmflags"
    local bld_dir="$dir"/building/"$target"
    rm -rf "bld_dir" && mkdir -p "$bld_dir" && cd "$bld_dir"
    cmake $cmake_flags "$dir"/"$target"
    make clean && make -j "$(expr $(nproc) '+' 2)"
}

make_runner() {
    echo "oo Generating Runner oo"
cat << EOF > "$fg_install"/flightgear
#!/bin/bash
export OSG_NUM_DATABASE_THREADS="$(expr $(nproc) '+' 1)"
export OSG_OPTIMIZER=REMOVE_REDUNDANT_NODES
export OSG_NUM_HTTP_DATABASE_THREADS="$(expr $(nproc) '+' 1)"
export OSG_GL_TEXTURE_STORAGE=on
export OSG_COMPILE_CONTEXTS=on
export FG_HOME="$fg_home"
export FG_PROG="$fg_install"
export FG_SCENERY="$fg_scenery"
$ldlib
"$fg_install"/bin/fgfs --fg-aircraft="$fg_aircraft" --terrasync-dir="$fg_scenery" --prop:/sim/rendering/bump-mapping=true --prop:/sim/rendering/enhanced-lighting=true --prop:/sim/rendering/lightning-enable=true --disable-hud-3d --prop:/sim/nasal-gc-threaded=true --prop:/sim/rendering/multithreading-mode=CullThreadPerCameraDrawThreadPerContext --prop:/sim/gui/current-style=0 --prop:/sim/rendering/cache=true --prop:/sim/rendering/texture-cache/cache-enabled=true --prop:/sim/nasal-gc-threaded=true --prop:/sim/rendering/use-vbos=true --enable-distance-attenuation --enable-horizon-effect --enable-specular-highlight --shading-smooth --fog-nicest --texture-filtering=16 --prop:/sim/rendering/multi-sample-buffers=true --prop:/sim/rendering/multi-samples=4 \$*
EOF

chmod +x "$fg_install"/flightgear

cat << EOF > "$fg_install"/launcher_loop
#!/bin/bash

while :
do
    "$fg_install"/flightgear --enable-fullscreen --launcher
done
EOF

chmod +x "$fg_install"/launcher_loop
}

install() {
    make install
}

set_globals

# Install dependencies
deb_install_deps

# Build and Install PLIB
url="svn://svn.code.sf.net/p/plib/code"
target="trunk"
svn_checkout
compile
install
unset target url

# Build and Install OpenSceneGraph
url="https://github.com/openscenegraph"
target="OpenSceneGraph.git"
branch="$osg_branch"
cmflags="-DBUILD_OSG_APPLICATIONS=0 -DBUILD_OSG_DEPRECATED_SERIALIZERS=0 -DOpenGL_GL_PREFERENCE=GLVND"
git_clone
build
install
unset cmflags target url branch

# Build and Install SimGear
url="https://gitlab.com/flightgear"
target="simgear.git"
branch="$fg_branch"
cmflags="-DBUILD_TESTING=0 -DENABLE_SIMD_CODE=1 -DENABLE_TESTS=0"
git_clone
build
install
unset cmflags target url branch

# Build and Install FlightGear
url="https://gitlab.com/flightgear"
target="flightgear.git"
branch="$fg_branch"
cmflags="-DFG_BUILD_TYPE=Release -DBUILD_TESTING=0 -DENABLE_AUTOTESTING=0"
git_clone
build
install
unset cmflags target url branch

# Making the launcher
make_runner
mkdir -p "$fg_common"
mkdir -p "$fg_home" "$fg_scenery" "$fg_aircraft"

echo ""
echo "#====== Creating a Desktop shortcut for FlightGear-$release_type"

release="$fg_branch"
install_directory="$fg_install"

# Creates desktop luncher
cat << EOF > "$HOME/Desktop/FlightGear-$release_type.desktop"
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.4
Type=Application
Categories=Game;Simulation
Terminal=false
Icon=$install_directory/share/icons/hicolor/scalable/apps/flightgear.svg
Path=$install_directory
Exec=sh -c "cd $install_directory && ./flightgear --launcher"
Name=FlightGear-$release_type
Comment=FlightGear-$release_type Launcher Compiled with FlightGear Builder
Hidden=false
Keywords=Flight Simulator;Simulation;Flight;FlightGear;FlightGear Builder;FGB;Aviation;Airplanes
EOF
chmod +x "$HOME"/Desktop/FlightGear-$release_type.desktop # Sets it as executable

echo ""
echo "#====== Adding FlightGear-$release_type menu entry."

mkdir -p $HOME/.local/share/applications # Creating this directory if it doesn't exist
cp "$HOME"/Desktop/FlightGear-$release_type.desktop $HOME/.local/share/applications/ # Adds FlightGear to the list of software in the users menu.

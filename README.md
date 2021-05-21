# FlightGearBuilder
An elegant script to download and build OpenSceneGraph, PLIB, SimgGear and,
FlightGear.

## What Does It Do?
FlightGearBuilder is a shell script that will download the source code for OSG, PLIB, SimGear and FlightGear.
Then it will compile a nice and stable version of them. Or unstable, if so you chose.

## How do I run it?

#### Installing FlightGear
Download the script run it with **`./FlightGearBuilder.sh`**.
You may or may not need to mark it as executable first with **`chmod +x FlightGearBuilder.sh`**

Add **`--next`** flag to each script if you want to download the very
latest testing version of FlightGear.

#### FlightGear Data
FlightGear Data are required files to run FlightGear.
It is an absolutelty huge and ever growing thing that I don't want to deal with anymore, email FG devs to change that.
Following are some places where you can get fgdata yourself. Observe if you are downloading the right version.
https://download.flightgear.org/builds/
https://gitlab.com/flightgear/fgdata

#### Uninstalling FlightGear
Simply remove the **`FGB`** directory from your **`$HOME`** folder.
There will be a launcher at **`$HOME/.local/share/applications/`**, remove it to remove FlightGear from the applications menu.

## Where is FlightGear Installed to?
By default the script will install to **`~/FGB`**.

## How to I run FlightGear?
If everything wel well, you can run **`./flightgear --launcher`** from
the folder **`~/FGB/FlightGear-Stable/Next`**.
Or, by simply searching for and clicking in **FlightGear** in your DEs applications menu/dashboard.


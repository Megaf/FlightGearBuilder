# FlightGearBuilder

## About
FlightGearBuilder is an elegant and simple script that will:
On Debian based distros, it will download and install all depedencies required to build FlightGear and its components from the source.
Download the source code of PLIB, OpenSceneGraph, SimgGear and, FlightGear.
Compile each of the components after its source is downloaded.

## What Does It Do?
FlightGearBuilder is a shell script that will download the source code for OSG, PLIB, SimGear and FlightGear.
Then it will compile a nice and stable version of them. Or unstable, if so you chose.

## How do I run it? How to use it?

#### Installing FlightGear
Download the script run it with **`./FlightGearBuilder.sh`**.
You may or may not need to mark it as executable first with **`chmod +x FlightGearBuilder.sh`**

Add **`--next`** flag to each script if you want to download the very
latest testing version of FlightGear.

## FGDataDownloader.sh

## About FGDataDownloader.sh
FGDataDownloader is a tiny script that will download the "Data" required to run FlightGear.
The Data will be downloaded to the FGB folder, tipically located in your home folder.

## Running FGDataDownloader.sh
Download the script run it with **`./FGDataDownloader.sh`**.
You may or may not need to mark it as executable first with **`chmod +x FGDataDownloader.sh`**

Add **`--next`** flag to each script if you want to download the very
latest testing version of FlightGear.

#### FlightGear Data
FlightGear Data are required files to run FlightGear.
https://download.flightgear.org/builds/
https://gitlab.com/flightgear/fgdata

## Uninstalling FlightGear
Simply remove the **`FGB`** directory from your **`$HOME`** folder.
There will be a launcher at **`$HOME/.local/share/applications/`**, remove it to remove FlightGear from the applications menu.

## Where is FlightGear Installed to?
By default the script will install to **`~/FGB`**.

## How to I run FlightGear?
If everything wel well, you can run **`./flightgear --launcher`** from
the folder **`~/FGB/FlightGear-Stable/Next`**.
Or, by simply searching for and clicking in **FlightGear** in your DEs applications menu/dashboard.


# !! ATTENTION !!!
- A new version of the script will soon be released.
## Changes from Version 2 onwards.
- Downloader and Compiler are not merged into FlightGearBuilder.sh script.
- Download_Data is now called FGDataDownloader
- The scripts are now based on Shell Script functions, it is even more open and flexible now.

# FlightGearBuilder
- An elegant script to download and build OpenSceneGraph, PLIB, SimgGear and, FlightGear.

## What Does It Do?
- FlightGearBuilder is a small collection of shell scripts that will download the source code for OSG, PLIB, SimGear and FlightGear.
- Then it will then compile a nice and stable version of them.

## How do I run it?

#### Installing FlightGear
- Download the script run it with **`./FlightGear_Downloader`** and, then **`./FlightGear_Compiler`**.
- Add **`--next`** flag to each script if you want to download the very latest testing version of FlightGear.

#### FlightGear Data
- If you want to download/update the large fgdata files too, then run **`Download_Data.sh`**.
- You can run it from a different terminal window at the same time you are running either the downloader or compiler, use **`--next`** flag to donwload the latest unstable version.

#### Uninstalling FlightGear
- Simply remove the **`FlightGear-*`** directories from your **`$HOME`** folder.
- There will be a launcher at **`$HOME/.local/share/applications/`**, remove it to remove FlightGear from the applications menu.

## Where is FlightGear Installed to?
- By default the script will install to **`~/FlightGear-Stable/Next`**.

## How to I run FlightGear?
- If everything wel well, you can run **`./flightgear --launcher`** from the folder **`~/FlightGear-Stable/Next`**.
- Or, by simply searching for and clicking in **FlightGear** in your DEs applications menu/dashboard.

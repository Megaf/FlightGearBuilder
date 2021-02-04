# FlightGearBuilder
An elegant script to download and build OpenSceneGraph, PLIB, SimgGear and,
FlightGear.

## What Does It Do?
FlightGearBuilder is a shell script that will download the source code for OSG,
PLIB, SG and FG.
Then it will compile a nice and stable version of it.

## How do I run it?

#### Installing FlightGear
Download the script run it with **`./FlightGear_Downloader`** and,
then **`./FlightGear_Compiler`**.

Add **`--next`** flag to each script if you want to download the very
latest testing version of FlightGear.

#### FlightGear Data
If you want to download/update the large fgdata files too,
then run **`Download_Data.sh`**.
You can run it from a different terminal window at the same time
you are running either the downloader or compiler, use **`--next`** flag
to donwload the latest unstable version.

#### Uninstalling FlightGear
Simply remove the **`FlightGear-*`** directories from your **`$HOME`** folder.

## Where is FlightGear Installed to?
By default the script will install to **`~/FlightGear-Stable/Next`**.

## How to I run FlightGear?
If everything wel well, you can run **`./flightgear --launcher`** from
the folder **`~/FlightGear-Stable/Next`**.


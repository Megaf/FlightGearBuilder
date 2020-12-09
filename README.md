# FlightGearBuilder
An elegant script to download and build OpenSceneGraph, PLIB, SimgGear and FlightGear.

## What Does It Do?
FlightGearBuilder is a shell script that will download the source code for OSG, PLIB, SG and FG.
Then it will compile a nice and stable version of it.

## How do I run it?

#### Installing FlightGear
Download the script run it with `./flightgear_downloader` and then `./flightgear_compiler`.

Add "`--next`" flag to `flightgear_downloader` if you want to download the very latest testing version of FlightGear.

#### FlightGear Data
If you want to download/update the large fgdata files too then run `fgdata_downloader`.
You can run it from a different terminal window at the same time you run `flightgear_compiler`.

#### Uninstalling FlightGear
Run `./flightgear_uninstaller.`

## Where is FlightGear Installed to?
By default the script will install to **~/FlightGear**.

## How to I run FlightGear?
If everything wel well, you can run `./flightgear --launcher` from **`~/FlightGear`**.

## Configuration

### Install Location
You can change where you want to install FlightGear to by editing the file `INSTALL_LOCATION`.

If you'd like to install it to `/usr/local/FlightGear`, then simply put that in `INTALL_LOCATION`.

One of of doing that is by running `echo "/usr/local/FlightGear" > INSTALL_LOCATION`.

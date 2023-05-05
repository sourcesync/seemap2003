# Introduction

Welcome to the code and presentation materials repository for the practical ML tutorial for SEEEMAPL 2023.  

You will find here:
* All the presentation materials
* The jupyter notebooks for the tutorial/workshop
* Setup and management scripts for the workshop machines
* Hardware setup instructions for the workshop

# Requirements

This tutorial/workshop requires the following:

* One Nighthawk Netgear router 
* One multi-port Netgear switch
* Two headless 2020 mac-minis
* 10 NVidia Jetson NANOs 
* One laptop for administration
* At least one usb keyboard, one usb mouse, and hdmi monitor (for mac-mini/Jetson NANO setup)
* Lots of ethernet cables (recommend at least 12 at 10 foot or less)
* Lots of power strips
* Thumb-drive with software setup

( Note that it's possible to setup with similar hardware, and the setup instructions may change accordingly. )

# Setup and Installation

These instructions will take you through the hardware and software setup from scratch.  Some steps may be skipped if the machines were setup already.

## Network Setup

### Nighthawk Netgear Router

* Power on the router and wait for a solid light for the LAN (WAN will not be used.)
* Connect the administration laptop to the WIFI access point called NIGHTHWAWK (use the default password printed on the touter.)
* Browse to the router admin page: routerlogin.net and enter the credentials from the hardware
* Setup the LAN to allocate dynamic IP address in the range 192.168.10.20-192.168.10.254
* Locate the entry for the laptop and lock down its IP address to 192.168.10.2

### Mac-Mini(s)

* Connect usb keyboard, usb mouse, hdmi display to 1 mac-mini and power up
* Login using the adminitrator account ( or setup your mac-mini if it's new )
* Connect an ethernet cable to router
* Via the router admin page, locate the mac-mini and its MAC address
* Lock it's IP address to 192.168.10.3 (verify the change on the mac-mini)
* Make sure to put a label of the IP address on the mac-mini
* Repeat these step for the other mac-mini but use 192.168.10.4

### Jetson NANO(s)

* If the Jetson NANO((s) are new, make sure to follow the setup guide (choose "workshop" as the name/pass of the primary admin account.)
* Connect the switch to the router power it up
* Connect 1 Jetson NANO to the switch via an ethernet cable
* Power up the Jetson NANO
* In the router admin interface, make sure you see the NANO
* Lock down its IP address to 192.168.10.5 (verify the change on the NANO and the laptop)
* Make sure to put a label of the IP address on the NANO
* Repeat these step for the other NANOs, incrementing the IP address as you go

## Software Setup

### Mac-Mini(s)

#### Setup From thumb drive backup

This is the likely setup since there won't be public internet:

* Choose a mac-mini and login to the administrator account
* Insert the thumb drive with the software backup
* From the thumb drive, copy the "seemap2023" workshop directory to the home folder
* run the "./install.sh" script
* This will take a few minutes
* It will indicate success at the end, otherwise consult the troubleshooting directions below

#### Setup from the Internet

If there is public internet, you can run these instructions.  
* Login to the admin account and connect a mac-mini to the public internet
* Clone this repository to the home directory
* cd into the "seemap2023" folder and run the "./install.sh" script
* It will indicate success at the end, otherwise consult the troubleshooting directions below

### Jetson NANO(s)

* From the control laptop, "scp" the directory "seemapld20233/nano_workshop" to the "workshop" home directory of each NANO.
* From the control laptop, login to each NANO and run the script "~/nano_workshop/setup.sh"
* It will indicate success at the end, otherwise consult the troubleshooting directions below
* Reboot the NANO

## Launch the Workshop

Before the workshop begins:

* Make sure all the hardware is powered on and status lights are steady/postive
* Via the admin laptop, ping all the mac-minis and all the NANOs via their locked down IP addresses
* Advertise to workshop attendees the router WIFI access point and password
* On the control laptop, login to a mac-mini
* cd into "seemap2023" and run the "workshop.sh" script and follow the directions.
* Repeat for the other mac-mini.
* Tell the attendees to use their browser and browse to "http://seepmap2023.net" (no credentials needed)

# Troubleshooting


# TODO

* custom authenticator based on MAC address list
* intelligent load-balancing across mac-minis
* get dataset for hardware/machine failure prediction
* setup scripts for nanoA
* fix jupyterhub exists logic in workshop.sh script (use netstat)
* propogate sudo to screen command

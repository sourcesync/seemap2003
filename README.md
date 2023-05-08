# Introduction

Welcome to the code and presentation materials repository for the practical ML tutorial for SEEEMAPL 2023.  

You will find here:
* All the presentation materials
  * [01 Intro And Survival Analysis ML](01_Intro_And_Survival_Analysis_ML.pdf)
  * [03 AI Hardware, Pytorch, and Computer Vision](03_AI_Hardware_PyTorch_And_Computer_Vision.pdf)
* The jupyter notebooks
  * [02 Coding Part I](02_seemapld2023.ipynb)
  * [04 Coding Part II](04_seemapld2023.ipynb)
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

## Device Setup

When you have internet, you should get all the machine's ready with these setup instructions.

### Mac-Mini(s)

( These setup instructions assume you will be putting the machine on the public internet somehow. )

* If it's a new mac-mini perform a typical setup
* Login and setup an admin account called "seemapld" with a secure password.
* Clone this repo to the home directory
* Sync to the home directory the data file data_transfer.tar.gz from the backup (ie, thumb drive) or cloud directory (TBD)
* You should configure remote (VNC) login in the settings
* Create standard users named "workshop_1" to "workshop_25" for the first mac-mini at 2.4
* Create standard users named "workshop_26" to "workshop_50" for the second mac-mini at 2.5
* Copy the data_transer.tar.gz file to the home directory
* cd into the cloned repo directory and run ./install.sh script

### Jetson NANOs

( These setup instructions assume you will be putting the machine on the public internet somehow. )

* If it's a new NANO, perform a typical setup
* Login and setup an admin account called "seemapld" with a secure password.
* Clone this repo to the home directory
* Sync to the home directory the data file data_transfer.tar.gz
* Run the "nano_install.sh" script from the cloned repo directory.

## Network Setup

( Once you've setup the machines above, you will take them off the internet and follow these instructions. )

### Nighthawk Netgear Router

* Power on the router and wait for a solid light for the LAN (WAN will not be used.)
* Connect the administration laptop to the WIFI access point called NIGHTHWAWK (use the default password printed on the router.)
* Browse to the router admin page: routerlogin.net and enter the credentials from the hardware
* Setup the LAN to allocate dynamic IP address in the range 192.168.2.20-192.168.2.254
* Locate the entry for the laptop and lock down its IP address to 192.168.2.2
* Do not put the router on the internet (ie, nothing connected to WAN )
* Extend the router with the swtich (as needed)

### Mac-Mini(s)

* Connect usb keyboard, usb mouse, hdmi display to 1 mac-mini and power up
* Login using the adminitrator account ( or setup your mac-mini if it's new )
* Connect an ethernet cable to router
* Via the router admin page, locate the mac-mini and its MAC address
* Lock it's IP address to 192.168.2.4 (verify the change on the mac-mini)
* Make sure to put a label of the IP address on the mac-mini
* Repeat these step for the other mac-mini but use 192.168.2.5


### Jetson NANO(s)

* Connect to the router (or switch as needed) 
* Connect 1 Jetson NANO to the switch via an ethernet cable
* Power up the Jetson NANO
* In the router admin interface, make sure you see the NANO
* Lock down its IP address to 192.168.2.6 (verify the change on the NANO and the laptop)
* Make sure to put a label of the IP address on the NANO
* Repeat these step for the other NANOs, incrementing the IP address as you go

## Launch the Workshop

Before the workshop begins:

* Make sure all the hardware is powered on and status lights are steady/postive
* Via the admin laptop, ping all the mac-minis and all the NANOs via their locked down IP addresses
* Advertise to workshop attendees the router WIFI access point and password
* On the control laptop, login to each mac-mini
* cd into "seemap2023" and run the "screen" command
* Launch the script "jhub_launch.sh"
* Repeat for the other mac-mini.
* You will need to figure out how to dole account workshop_x accounts to attendees as they arrive
* Tell the attendees to browse to the IP address of the mac-mini depending on their workshop_x account name

# Troubleshooting

TBD

# TODO

* nbconvert load test
* custom authenticator based on MAC address list
* intelligent load-balancing across mac-minis
* get dataset for hardware/machine failure prediction
* setup scripts for nanoA
* fix jupyterhub exists logic in workshop.sh script (use netstat)
* propogate sudo to screen command
* precache datasets
* test without any WAN on router
* finish transfer pytorch model to NANO section in notebook
* stress test (virtual ips on client laptop?)
* conda activate in workshop login
* explore the jupyterhub sqlite dbase for format
* fix "sudo -X" and opencv high window support on Nano
* add dataset copy/unpack to script
* create thumb drive/cloud backup
* complete dagsurv experiments
* put a hardware limits section in this readme
* investigate mars images for fine-tuning notebook
* figure out yolo compatibility in nano
* figure out python torch compatibility in nano
* figure out factor reset in nano
* fix opencv highgui/namedwindow issue
* add model/network diagrams into notebook instead of text


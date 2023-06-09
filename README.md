# Introduction

Welcome to the code and presentation materials repository for the practical ML tutorial for SEEEMAPLD 2023.  

The workshop comprises dovetailing presentations and interactive coding sessions via jupyter notebooks.

Participants come to the tutorial session with a laptop and browser if they wish to participate in the interactive coding essions.  No installation of software is required.

When attendees arrive they will be told to connect to the workshop WIFI router and browse to an internal server machine which hosts interactive python notebooks.

The workshop instructor will lead them through the coding sessions, so no prior ML expereience will be required.

All of the software and data is self-contained and will not require participants to connect to the public internet.

# What's In This Repository

You will find here:
* All the presentation materials
  * [01 Intro And Survival Analysis ML](01_Intro_And_Survival_Analysis_ML.pdf)
  * [04 AI Hardware, Pytorch, and Computer Vision](04_AI_Hardware_PyTorch_And_Computer_Vision.pdf)
* The jupyter notebooks
  * [02 Coding Part I](02_seemapld2023_jupyter_notebooks.ipynb)
  * [03 Coding Part II](03_seemapld2023_survival.ipynb)
  * [05 Coding Part III](05_seemapld2023_fastai_mnist.ipynb)
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
* See additional mac-mini optional setup optimizations in the Appendix below
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
* You should keep open these terminals to each mac-mini to monitor machines during the workshop
* Also, its a good idea to open and maintain a remote VNC seession to each mac-mini on the control laptop ( use "Connect To Server" feature using addressees vnc://192.168.2.5:5900 andd vnc://192.168.2.4:5900 )
* You will need to figure out how to dole account workshop_x accounts to attendees as they arrive
* Tell the attendees to browse to the IP address of the mac-mini depending on their workshop_x account name

During the workshop:
* It's a good idea the deattach the "screen" command you launched above (but attach as needed)
* I recommend running continuous performance monitoring such as "top"


# Appendix

## Mac-Mini Optional System Optimizations

I recommend you also do the following:
* Make sure there is an autologin on restart using your admin account
* Disable FileVault
* Disable csrutil via ( https://eshop.macsales.com/blog/74502-boot-an-m1-mac-into-recovery-mode/, https://www.howtogeek.com/230424/how-to-disable-system-integrity-protection-on-a-mac-and-why-you-shouldnt/ )
* Disable photoanalysisd via https://forums.macrumors.com/threads/high-cpu-consumption-of-photos-processes-photolibraryd-and-photoanalysisd.2376267/, not to get your uid via this command at terminal "echo $UID"
* Turn off indexing via "sudo mdutil -i off"
* Disable all aspects of automatic software update
* I recommend manually performing all software updates before you takee it off public interneet
* Do a reboot to make sure all of the settings above were permanent
* Remember to do a final test of the workshop before internet becomes unavailable ( such as at the conference site )

### Jetson NANO Optional System Optimizations

* At terminal, run "docker version" and if you can't see the server version then follow the docker post-installation steps (https://docs.docker.com/engine/install/linux-postinstall/)

# TODO

* DNS for nanos?
* pytorch warning in nano
* vision_learner warning
* refactor jupyter intro cells into their own notebook
* use mars rover images for transfer learning (see the mars rise paper)
* dockerize to allow for per user resource quotas
* support MLP for MNIST training ( HF? custom NN module? )
* nchan=1 optimization for fastai nb?
* make a way to restrict running certain compute intensive cells
* rename NETGEAR to SEEMAP
* pre-made post-its with logins
* scripts to progressivly add/remove notebooks during workshop
* support self-signed cert HTTPS for jupyter
* cleanup extraneous mini/nano login accounts (may also free up some data)
* sync jupyter settings
* disable notebook autosave
* fix repeated copy files logic in install.sh and sync.sh
* test various jupyterhub failure conditions 1) multiple tabs 2) tab remains open across jupyterhub restarts
* restrict pytorch training via system whitelist
* nbconvert load tests with looping
* custom authenticator based on MAC address list
* intelligent load-balancing across mac-minis
* get dataset for hardware/machine failure prediction
* finish transfer pytorch model to NANO section in notebook
* stress test (virtual ips on client laptop?)
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
* final test without any WAN on router


# QT cross compile setup scripts for 64-bit Rasperry Pi 4&5
 
## PREREQUITES  
### HARDWARE
Host [PC/Laptop]: Any x86/x86_64 AMD/Intel machine<br>
Target [Raspberry Pi 4&5]: Raspberry Pi 5 or Raspberry Pi 4  

### SOFTWARE
Host: Any Linux machine (Ubuntu 22.04.1 LTS Tested)<br>
Target: Raspberry Pi 4&5 Linux 64-bit OS (Raspberry Pi OS Bookworm Lite/Desktop tested)<br>

### NOTE
This is based on https://www.interelectronix.com/qt-cross-compile-setup-scripts-raspberry-pi-4.html scripts. The main differences are downloading 64-bit cross-compiler instead of 32-bit and mkspecs for 64-bit Pi4 taken from Qt 6.6.1 source code is copied to the unpacked Qt 5.15.8 source code into the folder ~/rpi-qt/qt-everywhere-src-5.15.8/qtbase/mkspecs/devices/linux-rasp-pi4-aarch64. In the background the cross compile toolchains for Raspberry Pi from <a href="https://github.com/abhiTronix/raspberry-pi-cross-compilers">abhiTronix</a> are used.

### OTHERS
Storage and Time Requirements: The build directory takes around ~10GB space and about 2-5 hours to complete (based on dependencies & Host Machine Specifications).
Networking: Your Target Machine (Raspberry Pi) and Host Machine (where you cross-compiling) both MUST have Internet Access, and MUST be on SAME Network to follow these instructions.

## STEPS/SETTINGS FOR TARGET MACHINE (RASPBERRY PI)
### 1. START FROM SCRATCH (OPTIONAL)
#### IMPORTANT
If you just brought a new Raspberry Pi or wanted to start from scratch just follow along. Otherwise, if you already has your Raspberry Pi setup, running, and Network Ready, then just skip to step 2.

#### NOTE
This section assume you have at least 10GB SDcard or USB stick for installing Raspberry Pi Bookworm 64-bit OS and a Laptop/PC for uploading it.

### 1.1. DOWNLOAD SOFTWARES & PREPARE THE USB or SD CARD
Install rpi-imager<br>
>sudo apt install rpi-imager<br>
>rpi-imager<br>

Select 64-bit Raspberry Pi OS Bookworm Lite/Desktop. Adjust settings form the gear button. For target storage select USB stick or sd card. I used USB since its much faster than sdcard. <br>

If u dont want to use rpi-imager then:<br>

Download the latest version of Raspberry Pi 64-bit OS from <a href="https://www.raspberrypi.org/software/operating-systems/">here</a> on your laptop/pc.
You will be needing an image writer to write the downloaded OS into the USB/SD card (micro SD card in our case). You can use Balena Etcher.
Insert the SUB/SD card into the laptop/pc and run the image writer. Once open, browse and select the downloaded Raspbian image file. Select the correct device, that is the drive representing the USB/SD card.
#### NOTE
If the drive (or device) selected is different from the SD card then the other selected drive will become corrupted. SO BE CAREFUL!
<br>
- Once the write is complete, eject the SD card and insert it into the Raspberry Pi and turn it on. It should start booting up. - Please remember that after booting the Pi, there might be situations when the user credentials like the "username" and password will be asked. Raspberry Pi comes with a default username `pi` and password `raspberry` and so use it whenever it is being asked.
### 1.2 SET UP NETWORK
Now the you have your Raspberry Pi up and Running, its time to connect it your network with one of following ways:
<br>
If you have Monitor: Connect it to your raspberry pi along with a keyboard and mouse to navigate, and follow this guide https://www.raspberrypi.org/documentation/configuration/wireless/desktop.md<br>
If you don't have Monitor: Follow this guide https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md
## 2. SET UP SSH
If you have Monitor: On the Raspberry Pi terminal, type: sudo raspi-config and menu should pop up on your terminal. To enable SSH, go to: Interfacing Options -> SSH -> Yes, and Click OK to enable it. Choose Finish finally and exit.
<br>
If you don't have Monitor: After setting up the network, if you don't have monitor or you operating it remotely. Then, enable SSH by just taking out your SD card, and hook it your computer, and simply create an empty file called ssh in the /boot/parition path inside SD card. Now insert back SD card into the Raspberry Pi.

## 3. OPEN TERMINAL
From another Laptop/PC using SSH: To connect to your Pi from a different computer, copy and paste the following command into the terminal window but replace 192.160.1.47 with the IP address of the Raspberry Pi.
>ssh pi@192.168.1.47<br>

It will ask for password, and if not changed, it is default (raspberry), and so use it whenever it is being asked.

### NOTE
It is possible to configure your Raspberry Pi to allow access from another computer without needing to provide a password each time you connect. For more details, see here.

## 4. GET SCRIPTS
Connect to your Pi with ssh and download the zip file:

>ssh pi@192.168.1.47

>wget https://github.com/henrihallik/qt-cross-compile-pi5_aarch64/archive/refs/heads/main.zip<br>
>unzip main.zip<br>
>cd qt-cross-compile-pi5_aarch64<br>

You can also download the zip file via browser from here https://github.com/henrihallik/qt-cross-compile-pi5_aarch64/archive/refs/heads/main.zip.<br>

Make the script qt-cross-compile-script-pi4.sh executable and execute it:

>sudo chmod +x qt-cross-compile-script-pi4.sh<br>
>sudo ./qt-cross-compile-script-pi4.sh<br>

After a while all needed packages are installed, the needed directories are created and the symlinks are correctly set.

### IMPORTANT
Make sure your Raspberry Pi and this Host machine (where you cross-compiling) MUST be on the SAME Network.

## STEPS/SETTINGS FOR HOST MACHINE (LINUX UBUNTU)
For testing, we used a PC with Ubuntu 22.04.1 LTS version.

### 1. DOWNLOAD ZIP FILE
>wget https://github.com/henrihallik/qt-cross-compile-pi5_aarch64/archive/refs/heads/main.zip<br>
>unzip main.zip<br>
>cd qt-cross-compile-pi5_aarch64<br>

You can also download the zip file via browser from here. https://github.com/henrihallik/qt-cross-compile-pi5_aarch64/archive/refs/heads/main.zip

### 2. MAKE THE SCRIPT QT-CROSS-COMPILE-SCRIPT-PI4.SH EXECUTABLE AND EXECUTE IT
>chmod +x qt-cross-compile-script-host.sh
### 3. CHANGE VARIABLES IN THE SCRIPT
You need to change the ip address (raspberry_ip) of your raspberry pi in the script and if you changed the user (raspberry_user) and password (raspberry_pwd) of the raspberry.

>nano qt-cross-compile-script-host.sh
### 4. EXECUTE THE SCRIPT
>sudo ./qt-cross-compile-script-host.sh<br>

The script performs the following actions:<br>

install all needed packages<br>
create needed directories (~/rpi-qt)<br>
download and extract Qt sources<br>
patch Qt sources<br>
download and extract cross compiler<br>
rsync files from raspberry pi<br>
download symlinker and set symlinks<br>
configure Qt build
make and make install Qt build<br>
rsync Qt binaries to raspberry<br>

### NOTE
ERROR: Feature 'kms' was enabled, but the pre-condition 'libs.drm' failed. The ./configure command in the host script tried to find drm.h from /usr/include but such file did not exist in that folder so one must look where the libdrm headers are actually located. In my case i had to add to the ./configure command in the host script: <br>
>-I$HOME/rpi-qt/sysroot/usr/include/libdrm </br>

Also if the libdrm.so file is not located in the ~/rpi-qt/sysroot/usr/lib/aarch64-linux-gnu then might need to specify that also with -L tag in the configure script

## FINAL STEP FOR TARGET MACHINE (RASPBERRY PI)
### UPDATE LINKER ON RASPBERRY PI
Enter the following command to update the device letting the linker to find the new QT binary files:<br>

>echo /usr/local/qt5.15/lib | sudo tee /etc/ld.so.conf.d/qt5.15.conf<br>
>sudo ldconfig<br>

## CONFIGURE QT CREATOR FOR CROSS COMPILING
Read the blog Configuring <a href="https://www.interelectronix.com/configuring-qt-creator-ubuntu-20-lts-cross-compilation.html">Qt-Creator on Ubuntu 20 Lts for cross-compilation</a> for including the compiled binaries (folder ~/rpi-qt/qt5.15) in Qt Creator. 

## Could not initalize egl display ##
Current workaround is to install qt5 with apt-get and then copy 2 files from its installation folder to the qt5.15 folder that was cross-compiled in your pc:<br>
>pi@pi5:/usr/lib/aarch64-linux-gnu/qt5/plugins/egldeviceintegrations $ sudo cp libqeglfs-kms-integration.so /usr/local/qt5.15/plugins/egldeviceintegrations/libqeglfs-kms-integration.so<br>
>pi@pi5:/usr/lib/aarch64-linux-gnu/qt5/plugins/egldeviceintegrations $ sudo cp libqeglfs-x11-integration.so /usr/local/qt5.15/plugins/egldeviceintegrations/libqeglfs-x11-integration.so<br>

Then there should be 4 files in /usr/local/qt5.15/plugins/egldeviceintegrations/ folder:<br>
> libqeglfs-emu-integration.so  libqeglfs-kms-egldevice-integration.so  libqeglfs-kms-integration.so  libqeglfs-x11-integration.so

## Cannot create window: no screens available ##
drmModeGetResources failed (Operation not supported)<br>
no screens available, assuming 24-bit color<br>

https://stackoverflow.com/questions/64312387/rpi4-qt5-qml-drmmodegetresources-failed-error
eglfs using default card for card0, and this is not work. Need to force using card1 for eglfs.<br>

Create a file to home folder eglfs.json<br>
>nano ~/eglfs.json<br>
insert into it<br>
>{ "device": "/dev/dri/card1" }<br>
save file<br>

now before starting your app add a variable before your app name in terminal<br>
>QT_QPA_EGLFS_KMS_CONFIG=/home/YOURUSERNAME/eglfs.json /path/to/YOURAPP<br>

or<br>

put the variable at the beginning of your apps main method<br>
>int main(int argc, char *argv[]){<br>
>  qputenv("QT_QPA_EGLFS_KMS_CONFIG", QByteArray("/home/pi/eglfs.json"));<br>
> ...<br>
> }<br>


I will later look into automatic these fixes in the scripts. Probably will need to add -x11 and maybe something else to the ./configure parameters

## undefined reference to `std::condition_variable::wait(std::unique_lock<std::mutex>&)@GLIBCXX_3.4.30'
## undefined reference to `std::__exception_ptr::exception_ptr::_M_release()@CXXABI_1.3.13'

It seems that libcamera wants to use wait( GLIBCXX_3.4.30 method from but the cross-compiler im using has older libstc++ version thats GLIBCXX_3.4.11<br>
1. Delete all the files that start with libstc++ from the folder ~/rpi-qt/tools/cross-pi-gcc-10.3.0-64/aarch64-linux-gnu/lib64<br>
2. Copy contents of the qt-cross-compile-pi5_aarch64/lib64 to ~/rpi-qt/tools/cross-pi-gcc-10.3.0-64/aarch64-linux-gnu/lib64<br>

a more detailed solution here https://forum.arducam.com/t/error-undefined-reference-to-libcamera-generateconfiguration-when-cross-compiling/5698/8?u=henri<br>

Will automate this also later


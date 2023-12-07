#!/bin/bash

# ===============================================




# ===============================================

cecho(){
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    YELLOW="\033[1;33m"
    # ... ADD MORE COLORS
    NC="\033[0m" # No Color
    # ZSH
    # printf "${(P)1}${2} ${NC}\n"
    # Bash
    printf "${!1}${2} ${NC}\n"
}

# update system and install packages
cecho "YELLOW" "Update system and install packages"
sudo sed -i -e 's/\#deb-src/deb-src/g' /etc/apt/sources.list
sudo apt-get update
sudo apt-get -y dist-upgrade
echo "$USER ALL=NOPASSWD:$(which rsync)" | sudo tee --append /etc/sudoers
sudo apt-get install -y build-essential cmake unzip pkg-config gfortran
sudo apt-get build-dep -y qt5-qmake libqt5gui5 libqt5webengine-data libqt5webkit5 libudev-dev libinput-dev libts-dev libxcb-xinerama0-dev libxcb-xinerama0 gdbserver libdrm-dev
sudo apt-get install -y libxcb-randr0-dev libxcb-xtest0-dev libxcb-shape0-dev libxcb-xkb-dev

# install additional packages
cecho "YELLOW" "Install additional packages"
## additional (multimedia) packages
sudo apt install -y libjpeg-dev libpng-dev libtiff-dev
sudo apt install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt install -y libxvidcore-dev libx264-dev openjdk-8-jre-headless
## audio packages
sudo apt install -y libopenal-data libsndio7.0 libopenal1 libopenal-dev pulseaudio
## bluetooth packages
sudo apt install -y bluez-tools
sudo apt install -y libbluetooth-dev
## gstreamer (multimedia) packages
sudo apt install -y libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio
sudo apt install -y libgstreamer1.0-dev  libgstreamer-plugins-base1.0-dev

# Create directory for Qt deployment
sudo mkdir /usr/local/qt5.15
sudo chown -R pi:pi /usr/local/qt5.15

# Setup important symlinks
if [ ! -f ~/SSymlinker ]
then
    sudo wget -P ~/ https://raw.githubusercontent.com/abhiTronix/raspberry-pi-cross-compilers/master/utils/SSymlinker
    sudo chmod +x ~/SSymlinker
fi

#uncomment next 8 lines for 32-bit cross-compilation
#~/SSymlinker -s /usr/include/arm-linux-gnueabihf/asm -d /usr/include
#~/SSymlinker -s /usr/include/arm-linux-gnueabihf/gnu -d /usr/include
#~/SSymlinker -s /usr/include/arm-linux-gnueabihf/bits -d /usr/include
#~/SSymlinker -s /usr/include/arm-linux-gnueabihf/sys -d /usr/include
#~/SSymlinker -s /usr/include/arm-linux-gnueabihf/openssl -d /usr/include
#~/SSymlinker -s /usr/lib/arm-linux-gnueabihf/crtn.o -d /usr/lib/crtn.o
#~/SSymlinker -s /usr/lib/arm-linux-gnueabihf/crt1.o -d /usr/lib/crt1.o
#~/SSymlinker -s /usr/lib/arm-linux-gnueabihf/crti.o -d /usr/lib/crti.o

#and uncomment these for 64-bit cross-compilation and vice versa
~/SSymlinker -s /usr/include/aarch64-linux-gnu/asm -d /usr/include
~/SSymlinker -s /usr/include/aarch64-linux-gnu/gnu -d /usr/include
~/SSymlinker -s /usr/include/aarch64-linux-gnu/bits -d /usr/include
~/SSymlinker -s /usr/include/aarch64-linux-gnu/sys -d /usr/include
~/SSymlinker -s /usr/include/aarch64-linux-gnu/openssl -d /usr/include
~/SSymlinker -s /usr/lib/aarch64-linux-gnu/crtn.o -d /usr/lib/crtn.o
~/SSymlinker -s /usr/lib/aarch64-linux-gnu/crt1.o -d /usr/lib/crt1.o
~/SSymlinker -s /usr/lib/aarch64-linux-gnu/crti.o -d /usr/lib/crti.o

cecho "GREEN" "Basic setup Pi5 ready!"

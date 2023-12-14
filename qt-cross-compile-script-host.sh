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

# variables
raspberry_ip="pi5.local"
raspberry_user="pi"
raspberry_pwd="pi"

cecho "GREEN" "Used Raspberry IP: $raspberry_ip"

# system updates
sudo apt update
sudo apt install -y build-essential cmake unzip gfortran
sudo apt install -y gcc git bison python gperf pkg-config gdb-multiarch wget
sudo apt-get -y install sshpass gcc g++ gperf flex texinfo gawk bison openssl pigz libncurses-dev autoconf automake tar figlet
cecho "GREEN" "system updated and used packages installed."

# create folders
if [ ! -d ~/rpi-qt ]
then
    sudo mkdir ~/rpi-qt
fi
if [ ! -d ~/rpi-qt/build ]
then
    sudo mkdir ~/rpi-qt/build
fi
if [ ! -d ~/rpi-qt/tools ]
then
    sudo mkdir ~/rpi-qt/tools
fi
if [ ! -d ~/rpi-qt/sysroot ]
then
    sudo mkdir ~/rpi-qt/sysroot
fi
if [ ! -d ~/rpi-qt/sysroot/usr ]
then
    sudo mkdir ~/rpi-qt/sysroot/usr
fi
if [ ! -d ~/rpi-qt/sysroot/opt ]
then
    sudo mkdir ~/rpi-qt/sysroot/opt
fi
sudo chown -R 1000:1000 ~/rpi-qt
cecho "GREEN" "Needed folders created."

# Download and extract QT source
cecho "YELLOW" "Download and extract QT source."
if [ ! -f ~/rpi-qt/qt-everywhere-opensource-src-5.15.8.tar.xz ]
then
   #sudo wget -P ~/rpi-qt http://download.qt.io/archive/qt/5.15/5.15.8/single/qt-everywhere-src-5.15.8.tar.xz
    sudo wget -P ~/rpi-qt  http://download.qt.io/archive/qt/5.15/5.15.8/single/qt-everywhere-opensource-src-5.15.8.tar.xz
    cecho "GREEN" "Qt source downloaded."
    if [ ! -d ~/rpi-qt/qt-everywhere-src-5.15.8 ]
    then
        cecho "YELLOW" "Extracting Qt source."
        sudo tar xf ~/rpi-qt/qt-everywhere-opensource-src-5.15.8.tar.xz -C ~/rpi-qt/
        sudo chown -R 1000:1000 ~/rpi-qt
        cecho "GREEN" "Qt source extracted."
    fi
else
    cecho "GREEN" "Qt source already exist."
    if [ ! -d ~/rpi-qt/qt-everywhere-src-5.15.8 ]
    then
        cecho "YELLOW" "Extracting Qt source."
        sudo tar xfv ~/rpi-qt/qt-everywhere-opensource-src-5.15.8.tar.xz -C ~/rpi-qt/
        sudo chown -R 1000:1000 ~/rpi-qt
        cecho "GREEN" "Qt source extracted."
    fi
fi
cecho "GREEN" "QT source downloaded and extracted."

# patch QT source
cecho "YELLOW" "Patching Qt source"
#uncomment next 2 lines for 32-bit cross-compilation
#cp -R ~/rpi-qt/qt-everywhere-src-5.15.8/qtbase/mkspecs/linux-aarch64-gnu-g++ ~/rpi-qt/qt-everywhere-src-5.15.8/qtbase/mkspecs/linux-arm-gnueabihf-g++
#sed -i -e 's/arm-linux-gnueabi-/arm-linux-gnueabihf-/g' ~/rpi-qt/qt-everywhere-src-5.15.8/qtbase/mkspecs/linux-arm-gnueabihf-g++/qmake.conf
#uncomment this if for 64-bit cross-compilation
if [ ! -d ~/rpi-qt/qt-everywhere-src-5.15.8/qtbase/mkspecs/devices/linux-rasp-pi4-aarch64 ]
then
    sudo cp -r linux-rasp-pi4-aarch64 ~/rpi-qt/qt-everywhere-src-5.15.8/qtbase/mkspecs/devices/linux-rasp-pi4-aarch64
fi
sed -i -e 's/\"main\"\: \"vc_dispmanx_display_open(0)\;\"/\"main\"\: \[\"vc_dispmanx_display_open(0)\;\"\, \"EGL_DISPMANX_WINDOW_T \*eglWindow \= new EGL_DISPMANX_WINDOW_T\;\"\]/g' ~/rpi-qt/qt-everywhere-src-5.15.8/qtbase/src/gui/configure.json
echo
cecho "GREEN" "Qt patched"

# Download and extract compiler
cecho "YELLOW" "Download and extract cross compiler."
#if [ ! -f ~/rpi-qt/tools/cross-gcc-10.3.0-pi_3+.tar.gz ]
if [ ! -f ~/rpi-qt/tools/cross-gcc-10.3.0-pi_64.tar.gz ]
then
    #uncomment next 1 lines for 32-bit cross-compilation and comment out the line after that
    #sudo wget -P ~/rpi-qt/tools https://sourceforge.net/projects/raspberry-pi-cross-compilers/files/Raspberry%20Pi%20GCC%20Cross-Compiler%20Toolchains/Bullseye/GCC%2010.3.0/Raspberry%20Pi%203A%2B%2C%203B%2B%2C%204/cross-gcc-10.3.0-pi_3%2B.tar.gz
    sudo wget -P ~/rpi-qt/tools https://sourceforge.net/projects/raspberry-pi-cross-compilers/files/Bonus%20Raspberry%20Pi%20GCC%2064-Bit%20Toolchains/Raspberry%20Pi%20GCC%2064-Bit%20Cross-Compiler%20Toolchains/Bullseye/GCC%2010.3.0/cross-gcc-10.3.0-pi_64.tar.gz
    cecho "GREEN" "Cross compiler downloaded."
    if [ ! -d ~/rpi-qt/tools/cross-pi-gcc-10.3.0* ]
    then
        sudo tar xf ~/rpi-qt/tools/cross-gcc-*.tar.gz -C ~/rpi-qt/tools/
        sudo chown -R 1000:1000 ~/rpi-qt
        cecho "GREEN" "Cross compiler extracted."
    fi
else
    cecho "GREEN" "Cross compiler already downloaded."
    if [ ! -d ~/rpi-qt/tools/cross-pi-gcc-10.3.0* ]
    then
        sudo tar xf ~/rpi-qt/tools/cross-gcc-*.tar.gz -C ~/rpi-qt/tools/
        sudo chown -R 1000:1000 ~/rpi-qt
        cecho "GREEN" "Cross compiler extracted."
    fi
fi
cecho "GREEN" "Cross compiler downloaded and extracted."

# rsync files from raspberry
cecho "YELLOW" "Syncing files from raspberry pi."
touch ~/.ssh/known_hosts
ssh-keyscan $raspberry_ip >> ~/.ssh/known_hosts
sshpass -p "$raspberry_pwd" rsync -avz --rsync-path="sudo rsync" --delete "$raspberry_user"@"$raspberry_ip":/lib ~/rpi-qt/sysroot
sshpass -p "$raspberry_pwd" rsync -avz --rsync-path="sudo rsync" --delete "$raspberry_user"@"$raspberry_ip":/usr/include ~/rpi-qt/sysroot/usr
sshpass -p "$raspberry_pwd" rsync -avz --rsync-path="sudo rsync" --delete "$raspberry_user"@"$raspberry_ip":/usr/lib ~/rpi-qt/sysroot/usr
sshpass -p "$raspberry_pwd" rsync -avz --rsync-path="sudo rsync" --delete "$raspberry_user"@"$raspberry_ip":/opt/vc ~/rpi-qt/sysroot/opt
sshpass -p "$raspberry_pwd" rsync -avz --rsync-path="sudo rsync" --delete "$raspberry_user"@"$raspberry_ip":/usr/local/include ~/rpi-qt/sysroot/usr/local
sshpass -p "$raspberry_pwd" rsync -avz --rsync-path="sudo rsync" --delete "$raspberry_user"@"$raspberry_ip":/usr/local/lib ~/rpi-qt/sysroot/usr/local
sshpass -p "$raspberry_pwd" rsync -avz --rsync-path="sudo rsync" --delete "$raspberry_user"@"$raspberry_ip":/etc/alternatives ~/rpi-qt/sysroot/etc
cecho "GREEN" "Files synced from raspberry pi."

# Fix symbolic links
cecho "YELLOW" "Fix symbolic links."
if [ ! -f ~/rpi-qt/sysroot-relativelinks.py ]
then
    wget -P ~/rpi-qt https://raw.githubusercontent.com/abhiTronix/rpi_rootfs/master/scripts/sysroot-relativelinks.py
    sudo chmod +x ~/rpi-qt/sysroot-relativelinks.py
fi
~/rpi-qt/sysroot-relativelinks.py ~/rpi-qt/sysroot
cecho "GREEN" "Symbolic links fixed."

# Configure Qt build
cecho "YELLOW" "Configure Qt build."
cd ~/rpi-qt/build
#CROSS_COMPILER_LOCATION="$HOME"/rpi-qt/tools/cross-pi-gcc-*
#../qt-everywhere-src-5.15.8/configure -release -opengl es2 -eglfs -device linux-rasp-pi4-v3d-g++ -device-option CROSS_COMPILE=$(echo $CROSS_COMPILER_LOCATION)/bin/arm-linux-gnueabihf- -sysroot ~/rpi-qt/sysroot/ -prefix /usr/local/qt5.15 -extprefix ~/rpi-qt/qt5.15 -#opensource -confirm-license -skip qtscript -skip qtwayland -skip qtwebengine -nomake tests -make libs -pkg-config -no-use-gold-linker -v -recheck -L$HOME/rpi-qt/sysroot/usr/lib/arm-linux-gnueabihf -I$HOME/rpi-qt/sysroot/usr/include/arm-linux-gnueabihf
CROSS_COMPILER_LOCATION="$HOME"/rpi-qt/tools/cross-pi-gcc-*
../qt-everywhere-src-5.15.8/configure -release -opengl es2 -eglfs -device linux-rasp-pi4-aarch64 -device-option CROSS_COMPILE=$(echo $CROSS_COMPILER_LOCATION)/bin/aarch64-linux-gnu- -sysroot ~/rpi-qt/sysroot/ -prefix /usr/local/qt5.15 -extprefix ~/rpi-qt/qt5.15 -opensource -confirm-license -skip qtscript -skip qtwayland -skip qtwebengine -nomake tests -make libs -pkg-config -no-use-gold-linker -v -recheck -L$HOME/rpi-qt/sysroot/usr/lib/aarch64-linux-gnu -I$HOME/rpi-qt/sysroot/usr/include/aarch64-linux-gnu -I$HOME/rpi-qt/sysroot/usr/include/libdrm
cecho "GREEN" "Configured Qt build."

# Build Qt
cecho "YELLOW" "Build Qt."
make -j$(nproc)
make install
cecho "GREEN" "Qt built."

# rsync Qt binaries to raspberry
cecho "YELLOW" "rsync Qt binaries to raspberry."
sshpass -p "$raspberry_pwd" rsync -avz --rsync-path="sudo rsync" ~/rpi-qt/qt5.15 "$raspberry_user"@"$raspberry_ip":/usr/local
cecho "GREEN" "Qt binaries synced to raspberry."

cecho "RED" "Finally update linker on Raspberry Pi"


# Building Qt 6.5.2 for Khadas VIM3

I’ve tested newest Qt 6 with Khadas VIM3 board and it works great. It is manual how to cross-compile Qt6.5.2 from sources for Khadas VIM3 board (maybe it can be used for VIM4 board).

Qt6 has cool features as Timeline, quick3d and examples how to use it (with QtCreator or Qt Design Studio). That’s powerful tools to create custom automotive applications.  
In general performance of VIM3 board is enough to render simple 3d animation (via OpenGL ES and quick3d module). Demo applications displays smooth and fast. It even little bit faster than RaspberryPi 4 with Vulkan drivers. 
Ulas Dikme created detailed manual for Qt6.3.0 and RaspberryPi  4 (thanks a lot):  https://github.com/PhysicsX/QTonRaspberryPi/blob/main/README.md
It manual also can be used for VIM3, except some details.

Several steps need to be taken:

# 1. Host machine preparing

Requirements: Ubuntu 22.04, Gnome,  Linux 6.2., gcc 11 version

```bash
sudo apt install cmake  // 3.22 version
sudo apt-get install make build-essential libclang-dev ninja-build gcc git bison \
python3 gperf pkg-config libfontconfig1-dev libfreetype6-dev libx11-dev libx11-xcb-dev \
libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev libxcb-glx0-dev \
libxcb-keysyms1-dev libxcb-image0-dev libxcb-shm0-dev libxcb-icccm4-dev libxcb-sync-dev \
libxcb-xfixes0-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-render-util0-dev \
libxcb-util-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
libatspi2.0-dev libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev

sudo apt install libxcb-cursor-dev // needed to avoid XCB compilation error
```

Installing a cross-compiler. I use g++ v11, older versions fails with linker errors (for Qt 6.5.2).


```bash
sudo apt install g++-aarch64-linux-gnu
```

# 2. Building Qt6 for Host machine

```bash
cd ~
$ wget https://download.qt.io/official_releases/qt/6.5/6.5.2/submodules/qtbase-everywhere-src-6.5.2.tar.xz

$ mkdir qt6_5_2_Host
$ cd qt6_5_2_Host

$ tar xf ../qtbase-everywhere-src-6.5.2.tar.xz
$ cd qtbase-everywhere-src-6.5.2
cmake -GNinja -DCMAKE_BUILD_TYPE=RelWithDebInfo -DINPUT_opengl=es2 -DQT_BUILD_EXAMPLES=OFF -DQT_BUILD_TESTS=OFF -DQT_FEATURE_xcb=ON -DCMAKE_INSTALL_PREFIX=/home/vks/qt6_5_2_HostBuild
```

In summary listing check that:


```bash
EGL-X11 Plugin ..................... yes 
```

```bash
$ cmake --build . --parallel 4
$ cmake --install .
```

To use QML applications need to build qtdeclarative module:

```bash
cd  ~
$ wget https://download.qt.io/official_releases/qt/6.5/6.5.2/submodules/qtshadertools-everywhere-src-6.5.2.tar.xz
$ wget https://download.qt.io/official_releases/qt/6.5/6.5.2/submodules/qtdeclarative-everywhere-src-6.5.2.tar.xz

$ cd qt6_5_2_Host
$ tar xf ../qtshadertools-everywhere-src-6.5.2.tar.xz
$ tar xf ../qtdeclarative-everywhere-src-6.5.2.tar.xz

$ cd qtshadertools-everywhere-src-6.5.2

$ /home/vks/qt6_5_2_HostBuild/bin/qt-configure-module .
$ cmake --build . --parallel 4
$ cmake --install .

$ cd ../qtdeclarative-everywhere-src-6.5.2
$ /home/vks/qt6_5_2_HostBuild/bin/qt-configure-module .
$ cmake --build . --parallel 4
$ cmake --install .
```


# 3. Test Qt on Host machine 

Install QtCreator.

$sudo apt install qtcreator
$qtcreator

Tools->Options->Kits

Qt Versions-> Add-> Select ~/qt6_5_2_HostBuild/bin/qmake 

Kits->Compiler GCC 
Select Qt compiler -> Qt6.5.2

Note: QtCreator available from Ubuntu repository is old 6.0.2 version. Good idea is to build from sources newer QtCreator.


Download some QML examples:

```bash
$cd ~
$git clone https://github.com/vkshardware/khadas_vim3_Qt6


```

Open QML test project, check that’s Qt6 works properly. You can open these examples with QtCreator, Qt Design Studio or directly from command line:

```bash

//Qt CoffeeMachine example

$ /home/vks/qt6_5_2_HostBuild/bin/qml -I /home/vks/khadas_vim3_Qt6/CoffeeMachine/imports /home/vks/khadas_vim3_Qt6/CoffeeMachine/content/App.qml

```
![alt text](https://github.com/vkshardware/khadas_vim3_Qt6/blob/main/coffee_machine.png)


Examples listed below need to build and install following modules:

qtquicktimeline-everywhere-src-6.5.2.tar.xz
qtquick3d-everywhere-src-6.5.2.tar.xz
qt5compat-everywhere-src-6.5.2.tar.xz
qtserialbus-everywhere-src-6.5.2.tar.xz
qtquickdesigner-components


```bash
//Qt ClusterTutorial project

$ /home/vks/qt6_5_2_HostBuild/bin/qml -I /home/vks/khadas_vim3_Qt6/ClusterTutorial/imports -I /home/vks/khadas_vim3_Qt6/ClusterTutorial/asset_imports /home/vks/khadas_vim3_Qt6/ClusterTutorial/content/App.qml
```

![alt text](https://github.com/vkshardware/khadas_vim3_Qt6/blob/main/cluster_tutorial.png)

```bash
//My ATV project

$ /home/vks/qt6_5_2_HostBuild/bin/qml -I /home/vks/khadas_vim3_Qt6/clutch_dashboard/qml/imports -I /home/vks/khadas_vim3_Qt6/clutch_dashboard/qml/asset_imports /home/vks/khadas_vim3_Qt6/clutch_dashboard/qml/content/App.qml
 
```

![alt text](https://github.com/vkshardware/khadas_vim3_Qt6/blob/main/clutch_dashboard.png)


# 4. Prepare Khadas VIM3 

Requirements: Ubuntu 22.04, Gnome,  Linux 6.2, gcc 11 version.
Using of GCC libs v9 and v10 on VIM3 will cause of linker errors with Qt 6.5.2, so GCC v11 included in Ubuntu 22.04 is required.

To build own image for VIM3 board use https://github.com/khadas/fenix

Install dependencies:
```bash
$ sudo apt-get install -y libudev-dev libinput-dev libts-dev \
libmtdev-dev libjpeg-dev libfontconfig1-dev libssl-dev libdbus-1-dev libglib2.0-dev \
libxkbcommon-dev libegl1-mesa-dev libgbm-dev libgles2-mesa-dev mesa-common-dev \
libasound2-dev libpulse-dev gstreamer1.0-omx libgstreamer1.0-dev \
libgstreamer-plugins-base1.0-dev  gstreamer1.0-alsa libvpx-dev libsrtp0-dev libsnappy-dev \
libnss3-dev "^libxcb.*" flex bison libxslt-dev ruby gperf libbz2-dev libcups2-dev \
libatkmm-1.6-dev libxi6 libxcomposite1 libfreetype6-dev libicu-dev libsqlite3-dev libxslt1-dev

$ sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev \
libx11-dev freetds-dev libsqlite0-dev libpq-dev libiodbc2-dev firebird-dev \
libgst-dev libxext-dev libxcb1 libxcb1-dev libx11-xcb1 libx11-xcb-dev \
libxcb-keysyms1 libxcb-keysyms1-dev libxcb-image0 libxcb-image0-dev libxcb-shm0 libxcb-shm0-dev \
libxcb-icccm4 libxcb-icccm4-dev libxcb-sync1 libxcb-sync-dev libxcb-render-util0 \
libxcb-render-util0-dev libxcb-xfixes0-dev libxrender-dev libxcb-shape0-dev libxcb-randr0-dev \
libxcb-glx0-dev libxi-dev libdrm-dev libxcb-xinerama0 libxcb-xinerama0-dev libatspi2.0-dev \
libxcursor-dev libxcomposite-dev libxdamage-dev libxss-dev libxtst-dev libpci-dev libcap-dev \
libxrandr-dev libdirectfb-dev libaudio-dev libxkbcommon-x11-dev

sudo apt install libxcb-cursor-dev
```

# 5. Copying VIM3 libs
On Host machine: 

```bash
cd ~

$ mkdir khadas-sdk 
$ cd khadas-sdk

$ mkdir sysroot sysroot/usr

$ rsync -avz --rsync-path="sudo rsync" root@192.168.43.183:/usr/include sysroot/usr
$ rsync -avz --rsync-path="sudo rsync" root@192.168.43.183:/lib sysroot
$ rsync -avz --rsync-path="sudo rsync" root@192.168.43.183:/usr/lib sysroot/usr 

$ wget https://raw.githubusercontent.com/riscv/riscv-poky/master/scripts/sysroot-relativelinks.py

$ chmod +x sysroot-relativelinks.py 
$ python3 sysroot-relativelinks.py sysroot
```

# 6. Cross-compile

```bash
$ cd ~
$ mkdir qt-cross
$ cd qt-cross
```
Create here toolchain.cmake file with following:


```bash
cmake_minimum_required(VERSION 3.16) 
include_guard(GLOBAL) 
 
set(CMAKE_SYSTEM_NAME Linux) 
set(CMAKE_SYSTEM_PROCESSOR arm) 
 
set(TARGET_SYSROOT /home/vks/khadas-sdk/sysroot) 
 
set(CMAKE_C_COMPILER "/usr/bin/aarch64-linux-gnu-gcc-11") 
set(CMAKE_CXX_COMPILER "/usr/bin/aarch64-linux-gnu-g++-11") 
set(CMAKE_FIND_ROOT_PATH /usr/aarch64-linux-gnu) 
 
 
set(CMAKE_SYSROOT ${TARGET_SYSROOT}) 
 
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER) 
 
 
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE arm64) 
 
 
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fPIC -Wl,-rpath-link,${CMAKE_SYSROOT}/usr/lib/${CMAKE_LIBRARY_ARCHITECTURE} -L${CMAKE_SYSROOT}/usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}") 
 
set(CMAKE_C_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -Wl,-rpath-link,${CMAKE_SYSROOT}/usr/lib/${CMAKE_LIBRARY_ARCHITECTURE} -L${CMAKE_SYSROOT}/usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}") 
 
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -Wl,-rpath-link,${CMAKE_SYSROOT}/usr/lib/${CMAKE_LIBRARY_ARCHITECTURE} -L${CMAKE_SYSROOT}/usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}") 
 
set(QT_COMPILER_FLAGS "-march=armv8-a -mfpu=crypto-neon-fp-armv8 -mtune=cortex-a72 -mfloat-abi=hard") 
set(QT_COMPILER_FLAGS_RELEASE "-O2 -pipe") 
set(QT_LINKER_FLAGS "-Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed") 
 
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER) 
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY) 
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY) 
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY) 
 
set(CMAKE_THREAD_LIBS_INIT "-lpthread") 
set(CMAKE_HAVE_THREADS_LIBRARY 1) 
set(CMAKE_USE_WIN32_THREADS_INIT 0) 
set(CMAKE_USE_PTHREADS_INIT 1) 
set(THREADS_PREFER_PTHREAD_FLAG ON)

```

Then process cross-compiling: 


```bash
$ tar xf ../qtbase-everywhere-src-6.5.2.tar.xz

$ cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DQT_FEATURE_eglfs_egldevice=OFF -DQT_FEATURE_eglfs_gbm=OFF -DQT_BUILD_TOOLS_WHEN_CROSSCOMPILING=ON  -DQT_BUILD_EXAMPLES=OFF -DQT_BUILD_TESTS=OFF -DQT_HOST_PATH=/home/vks/qt6_5_2_HostBuild -DCMAKE_STAGING_PREFIX=/home/vks/qt6khadas -DCMAKE_INSTALL_PREFIX=/home/vks/qt6crosskhadas -DCMAKE_PREFIX_PATH=/home/vks/khadas-sdk/sysroot/usr/lib/ -DCMAKE_TOOLCHAIN_FILE=/home/vks/qt-cross/toolchain.cmake /home/vks/qt-cross/qtbase-everywhere-src-6.5.2/

$ cmake --build . --parallel 4
$ cmake --install .

```

If compilation of core succeseed, check that file architecture of qmake is correct:

```bash

$ file qt6khadas/bin/qmake

qt6khadas/bin/qmake: ELF 64-bit LSB pie executable, ARM aarch64, version 1 
```


Process building of the QML modules:

```bash
$ tar xf ../qtshadertools-everywhere-src-6.5.2.tar.xz
$ tar xf ../qtdeclarative-everywhere-src-6.5.2.tar.xz

$ cd qtshadertools-everywhere-src-6.5.2

$ /home/vks/qt6khadas/bin/qt-configure-module .
$ cmake --build . --parallel 4
$ cmake --install .

$ cd ../qtdeclarative-everywhere-src-6.5.2
$ /home/vks/qt6khadas/bin/qt-configure-module .
$ cmake --build . --parallel 4
$ cmake --install .
```

Send installation to VIM3 board:

```bash
rsync -avz --rsync-path="sudo rsync" /home/vks/qt6khadas root@192.168.43.183:/usr/local 
```

# 7. Test Khadas VIM3 compilation

On VIM3 board download and test examples:

git clone https://github.com/vkshardware/khadas_vim3_Qt6


//Qt CoffeeMachine example
$ /usr/local/qt6khadas/bin/qml -I /home/khadas/khadas_vim3_Qt6/CoffeeMachine/imports /home/khadas/khadas_vim3_Qt6/CoffeeMachine/content/App.qml

```
Examples listed below need to cross-compile and install following dependensies:
qtquicktimeline-everywhere-src-6.5.2.tar.xz
qtquick3d-everywhere-src-6.5.2.tar.xz
qt5compat-everywhere-src-6.5.2.tar.xz
qtserialbus-everywhere-src-6.5.2.tar.xz
qtquickdesigner-components


```bash
//Qt ClusterTutorial project

$ /usr/local/qt6khadas/bin/qml -I /home/khadas/khadas_vim3_Qt6/ClusterTutorial/imports -I /home/khadas/khadas_vim3_Qt6/ClusterTutorial/asset_imports /home/khadas/khadas_vim3_Qt6/ClusterTutorial/content/App.qml
```

```bash
//My ATV project

$ /usr/local/qt6khadas/bin/qml -I /home/khadas/khadas_vim3_Qt6/clutch_dashboard/qml/imports -I /home/khadas/khadas_vim3_Qt6/clutch_dashboard/qml/asset_imports /home/khadas/khadas_vim3_Qt6/clutch_dashboard/qml/content/App.qml

```

If error message occured

```bash
qt.qpa.plugin: Could not find the Qt platform plugin "wayland" in ""
```

Try to define xcb platform before running application:

export QT_QPA_PLATFORM="xcb"

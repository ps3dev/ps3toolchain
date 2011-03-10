#!/bin/bash
# toolchain-mingw.sh by Miigotu (miigotu@hotmail.com)

MINGW32EXPORTS=\
('export GITINSTALLDIR=/c/msysgit' \
'export PATH="$PATH:$GITINSTALLDIR/bin"' \
'export PATH="$PATH:$GITINSTALLDIR/mingw/bin"' \
'export PYINSTALLDIR=/c/python27' \
'export PATH="$PATH:$PYINSTALLDIR"' \
'export PS3DEV=/usr/local/ps3dev' \
'export PATH="$PATH:$PS3DEV/bin"' \
'export PATH="$PATH:$PS3DEV/host/ppu/bin"' \
'export PATH="$PATH:$PS3DEV/host/spu/bin"' \
'export PSL1GHT=$PS3DEV/psl1ght' \
'export PATH="$PATH:$PSL1GHT/host/bin"')

DO_SET_EXPORTS=1
HAS_ANSWERED=0
NEWLINE=0
RESTART=0

ask_permission()
{
	if [ $DO_SET_EXPORTS -ne 0 ]; then
		if [ $HAS_ANSWERED -ne 1 ]; then
			echo -e "\E[1;31mWARNING:\E[0m\E[1m If you continue, his script will modify your global profile!\E[0m"
			echo
			echo The purpose of this change is to add export paths to your profile.
			echo To undo this, edit /etc/profile and removing these lines from the bottom:
			echo -e '(\E[4mNote:\E[0m These are also the exports that will be added, take note.)'
			echo
			echo -e '\E[0;32m	export GITINSTALLDIR=/c/msysgit'
			echo '	export PATH="$PATH:$GITINSTALLDIR/bin"'
			echo '	export PATH="$PATH:$GITINSTALLDIR/mingw/bin"'
			echo '	export PYINSTALLDIR=/c/python27'
			echo '	export PATH="$PATH:$PYINSTALLDIR"'
			echo '	export PS3DEV=/usr/local/ps3dev'
			echo '	export PATH="$PATH:$PS3DEV/bin"'
			echo '	export PATH="$PATH:$PS3DEV/host/ppu/bin"'
			echo '	export PATH="$PATH:$PS3DEV/host/spu/bin"'
			echo '	export PSL1GHT=$PS3DEV/psl1ght'
			echo -e '	export PATH="$PATH:$PSL1GHT/host/bin"\E[0m'
			echo
			echo It is highly recommended that you do this, to have the same build that most 
			echo others have, so that it is easier for others to help you when you have issues.
			echo Also, the buildscripts will fail if certain paths and variables are not set.
			echo
			echo -e '\E[1mDo you want to set these exports?\E[0m'
			echo

			PS3="Enter 1, 2, or 3: "
			options=("Yes, change my profile for me." "No, I have set them myself, but continue." "Quit, I will set them myself.")
			select opt in "${options[@]}"
			do
				case $opt in
				"Yes, change my profile for me.")
					DO_SET_EXPORTS=1
					HAS_ANSWERED=1
					break
					;;
				"No, I have set them myself, but continue.")
					DO_SET_EXPORTS=0
					HAS_ANSWERED=1
					break
					;;
				"Quit, I will set them myself.")
					echo
					echo -e "\E[1mExitting, Run this script again when you are ready.\E[0m"
					exit 0
					;;
				*) echo Invalid option, please try again.
					;;
				esac
			done
		fi
	fi
}

if [ $MSYSTEM == MINGW32 ]; then
	for((i = 0; i < ${#MINGW32EXPORTS[*]}; i++)); do
		if ! grep -q "${MINGW32EXPORTS[${i}]}" /etc/profile; then
			ask_permission
			if [ $DO_SET_EXPORTS -ne 0 ]; then
				if [ $NEWLINE -ne 1 ]; then
					echo >> /etc/profile ##In cases where no new line is at EOF.
					NEWLINE=1
				fi
				echo ${MINGW32EXPORTS[${i}]} >> /etc/profile
				RESTART=1
			fi
		fi
	done
	if [ $RESTART -eq 1 ]; then
		echo -e "Please restart mingw, or type \E[1m'. /etc/profile'\E[0m (without quotes)"
		echo "and then run this script again."
		exit 1
	fi

INSTALL_PACKAGES=

	## Install Dependancy packages
	if [ ! -f /usr//include/gmp.h ]; then
		INSTALL_PACKAGES+="msys-libgmp-dev gmp gmp-dev "
	fi
	if [ ! -f /usr//include/crypt.h ]; then
		INSTALL_PACKAGES+="msys-libcrypt "
	fi
	if [ ! -f /usr/include/zlib.h ]; then
		INSTALL_PACKAGES+="msys-zlib "
	fi
	if [ ! -f /mingw/include/zlib.h ]; then
		INSTALL_PACKAGES+="libz "
	fi
	if [ ! -f /mingw/include/curses.h ]; then 
		INSTALL_PACKAGES+="libpdcurses "
	fi
	if [ ! -f /mingw/bin/pexports ]; then 
		INSTALL_PACKAGES+="pexports "
	fi
	if [ ! -f /usr/bin/wget ]; then 
		INSTALL_PACKAGES+="msys-wget "
	fi	
	if [ ! -f /usr/bin/patch ]; then 
		INSTALL_PACKAGES+="msys-patch "
	fi
	if [ ! -f /usr/bin/unzip ]; then 
		INSTALL_PACKAGES+="msys-unzip "
	fi
	if [ ! -f /usr/include/openssl/sha.h ]; then 
		INSTALL_PACKAGES+="msys-libopenssl "
	fi

	if [ ${INSTALL_PACKAGES} ]; then
		mingw-get install $INSTALL_PACKAGES
	fi

	## Create the build directory.
	mkdir -p build && cd build || { echo "ERROR: Could not create the build directory."; exit 1; }

	## Install libelf
	if [ ! -f /mingw/include/libelf.h ]; then 
		wget http://www.mr511.de/software/libelf-0.8.13.tar.gz
		tar -zxvf libelf-0.8.13.tar.gz
		cd libelf-0.8.13
		./configure --prefix="/mingw"
		make -j4 && make install
		cd ..
	fi


	## Install pkg-config and dependancy dll's
	if [ ! -f /usr/bin/pkg-config ]; then 
		wget http://ftp.gnome.org/pub/gnome/binaries/win32/dependencies/pkg-config_0.25-1_win32.zip
		unzip -o pkg-config_0.25-1_win32.zip bin/*.exe -d /usr > NUL
	fi
	if [ ! -f /usr/bin/intl.dll ]; then 	
		wget http://ftp.gnome.org/pub/gnome/binaries/win32/dependencies/gettext-runtime_0.18.1.1-2_win32.zip
		unzip -o gettext-runtime_0.18.1.1-2_win32.zip bin/*.dll -d /usr > NUL
	fi
	if [ ! -f /usr/bin/libglib-2.0-0.dll ]; then 
		wget http://ftp.gnome.org/pub/gnome/binaries/win32/glib/2.26/glib_2.26.1-1_win32.zip
		unzip -o glib_2.26.1-1_win32.zip bin/*.dll -d /usr > NUL
	fi

	rm -Rf pkg-config_0.25-1_win32.zip glib_2.26.1-1_win32.zip gettext-runtime_0.18.1.1-2_win32.zip libelf-0.8.13.tar.gz libelf-0.8.13

	## Convert python.dll to a shared library
	if [ ! -f $PYINSTALLDIR/libs/libpython27.a ]; then
		PYDLL="$WINDIR\SysWOW64\python27.dll"
		pexports "$PYDLL" > python27.def
		if [ $? != 0 ]; then
			PYDLL="$WINDIR\System32\python27.dll"
			pexports "$PYDLL" > python27.def
		fi
		dlltool --dllname "$PYDLL" --def python27.def --output-lib libpython27.a 
		mv libpython27.a $PYINSTALLDIR/libs
		rm -Rf python27.def
	fi

	## Enter the ps3toolchain directory.
	cd ..

	## Run the toolchain script.
	./toolchain.sh $@ || { echo "ERROR: Could not run the toolchain script."; exit 1; }
else
	echo "MinGW was not detected as your kernel, exitting."
fi
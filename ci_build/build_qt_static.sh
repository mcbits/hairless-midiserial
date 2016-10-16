#!/bin/bash
#
# Shell script to build Qt static, runs as part
# of the Travis continuous integration build.

set -e

wget "${QTURL}"
tar zxf ${QTPKG}.tar.gz
cd ${QTPKG}

QTCOMMONOPTS="-opensource -release -static -silent -prefix ${QTDIR} -no-qt3support -no-cups -no-opengl -no-dbus -no-openssl -no-xmlpatterns -no-openvg -no-xinput -no-xkb -no-javascript-jit"

case $TARGET in
	native)
		QTOPTS=""
		;;
	win32)
		QTOPTS="-xplatform win32-g++ -device-option CROSS_COMPILE=i686-w64-mingw32-"
		;;
esac

echo "Configure arguments ${QTCOMMONOPTS} ${QTOPTS}"
echo 'yes' | ./configure ${QTCOMMONOPTS} ${QTOPTS}
# hack to avoid log limits, at most output last 100 lines of build
echo "Building Qt silently, will print error on failure"
make install 2>&1 > /tmp/qtbuild.log || tail -n 100 /tmp/qtbuild.log

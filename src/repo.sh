#!/bin/bash
#
echo "Removing some unnecessary files and folders"
rm -rfv ".git*"
rm -rfv ".github*"
rm -rfv "LICENSE*"
rm -rfv "README*"
rm -rfv "*.md"
rm -rfv "*.txt"
if [ -e $INPUT_SCRIPT ]
then
    echo "::group::Script Output"
        echo "--------------------"
        dos2unix $INPUT_SCRIPT
        bash $INPUT_SCRIPT
        rm -rf $INPUT_SCRIPT
        echo "--------------------"
    echo "::endgroup::"
fi
echo "Checking some folders"
if [ -d package*/*/ ];then
    cd package*/*/
fi
if [ -d DEBIAN ];then
    DEBIAN_DIR=DEBIAN
elif [ -d debian ];then
    DEBIAN_DIR=debian
else
    echo "We have no way to detect your package, leaving with error 12"
    find .
    exit 12
fi

echo "Debian Package file directory: $DEBIAN_DIR "
NAME="$(cat $DEBIAN_DIR/control | grep 'Package:' | sed 's|Package: ||g' | sed 's|Package:||g')"
VERSION="$(cat $DEBIAN_DIR/control | grep 'Version: ' | grep -v 'Standards-Version' | sed 's|Version: ||g')"
ARCH="$(cat $DEBIAN_DIR/control | grep 'Architecture: ' | sed 's|Architecture: ||g')"

echo "Package name:         $NAME"
echo "Package version:      $VERSION"
echo "Package architecture: $ARCH"

sudo chmod 0775 $DEBIAN_DIR
sudo chmod 0775 $DEBIAN_DIR/*

# Execute in all bin foldes 
for abin in $(find . -name '*bin')
do
 chmod -R a+x ${abin}
 chmod -R 777 ${abin}
done

DEB_OUTPUT="$(echo "$NAME $VERSION $ARCH" | sed 's| |_|g').deb"
dpkg-deb --build --verbose . /tmp/$DEB_OUTPUT
if [ -e /tmp/$DEB_OUTPUT ]
then
    echo "::group::Remove foldes"
        rm -rfv *
        mv -fv /tmp/$DEB_OUTPUT ./$DEB_OUTPUT
    echo "::endgroup::"
    echo "DEB_PATH=$PWD/$DEB_OUTPUT" >> $GITHUB_ENV
    echo "DEB_NAME=$NAME" >> $GITHUB_ENV
    echo 'Use ${{ env.DEB_PATH }} to get the file'
    echo "DEB_PATH=$PWD/$DEB_OUTPUT"
    exit 0
else
    echo "A successful package has not been created!"
    exit 23
fi
exit 0
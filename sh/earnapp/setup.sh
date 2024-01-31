#!/bin/bash
wget -qO- https://brightdata.com/static/earnapp/install.sh > /opt/earnapp/earnapp.sh

archs=`uname -m`
PRODUCT="earnapp"
VERSION=$(grep VERSION= /opt/earnapp/earnapp.sh | cut -d'"' -f2)

if [ $archs = "x86_64" ]; then
    file=$PRODUCT-x64-$VERSION
elif [ $archs = "amd64" ]; then
    file=$PRODUCT-x64-$VERSION
elif [ $archs = "armv7l" ]; then
    file=$PRODUCT-arm7l-$VERSION
elif [ $archs = "armv6l" ]; then
    file=$PRODUCT-arm7l-$VERSION
elif [ $archs = "aarch64" ]; then
    file=$PRODUCT-aarch64-$VERSION
elif [ $archs = "arm64" ]; then
    file=$PRODUCT-aarch64-$VERSION
else
    file=$PRODUCT-arm7l-$VERSION
fi
wget -cq --no-check-certificate https://cdn-earnapp.b-cdn.net/static/$file -O /opt/earnapp/earnapp
echo | md5sum /opt/earnapp/earnapp
chmod +x /opt/earnapp/earnapp

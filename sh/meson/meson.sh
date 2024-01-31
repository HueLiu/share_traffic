#!/bin/bash
sudo /opt/meson/meson_cdn config set --token=$MESON_TOKEN --https_port=$MESON_PORT --cache.size=30
sudo /opt/meson/meson_cdn

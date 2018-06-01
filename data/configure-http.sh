#!/bin/bash

PREFIX=/usr/local/apache

./configure --prefix=${PREFIX} --with-mpm=prefork --with-apr=${PREFIX}/bin/apr-1-config --with-apr-util=${PREFIX}/bin/apu-1-config

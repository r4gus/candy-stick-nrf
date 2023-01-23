#!/bin/bash

path1="./libs/fido2"
path2="./libs/ztap"

cd $path1
git checkout 0.11.0
cd $path2
git checkout 0.11.0
cd ../../../..

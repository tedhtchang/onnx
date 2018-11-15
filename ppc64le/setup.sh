#!/bin/bash

export NUMCORES=`grep -c ^processor /proc/cpuinfo`
if [ ! -n "$NUMCORES" ]; then
  export NUMCORES=`sysctl -n hw.ncpu`
fi
echo Using $NUMCORES cores

sudo apt-get update 

sudo apt-get install -y \
         protobuf-compiler \
         libprotobuf-dev \
         cmake

# use python3 venv based on the env variable PYTHON_VERSION
if [ "${PYTHON_VERSION}" == "python3" ]; then
    sudo apt-get install -y \
         python3-pip \
         python3-venv
    python3 -m venv venv_py3
    source venv_py3/bin/activate
else
    sudo apt-get install -y \
         python-pip 
fi

python -V
pip -V

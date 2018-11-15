#!/bin/bash

if [ "${PYTHON_VERSION}" == "python3" ]; then
    source venv_py3/bin/activate
fi

# onnx c++ API tests
export LD_LIBRARY_PATH="./.setuptools-cmake-build/:$LD_LIBRARY_PATH"
./.setuptools-cmake-build/onnx_gtests
./.setuptools-cmake-build/onnxifi_test_driver_gtests onnx/backend/test/data/node

# onnx python API tests
pip install numpy pytest nbval
pytest

# lint python code
pip install --quiet flake8
flake8

pip uninstall -y onnx
bash -c 'rm -rf .setuptools-cmake-build; \
pip install .'

# check line endings to be UNIX
sudo apt install dos2unix -y
find . -type f -regextype posix-extended -regex '.*\.(py|cpp|md|h|cc|proto|proto3|in)' | xargs dos2unix --quiet
git status
git diff --exit-code

# check auto-gen files up-to-date
python onnx/defs/gen_doc.py
python onnx/gen_proto.py
python onnx/backend/test/stat_coverage.py
backend-test-tools generate-data
git status
git diff --exit-code

# Do not hardcode onnx's namespace in the c++ source code, so that
# other libraries who statically link with onnx can hide onnx symbols
# in a private namespace.
! grep -R '--include=*.cc' '--include=*.h' 'namespace onnx' .
! grep -R '--include=*.cc' '--include=*.h' onnx:: .

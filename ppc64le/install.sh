#!/bin/bash

if [ "${PYTHON_VERSION}" == "python3" ]; then
    source venv_py3/bin/activate
fi

pip install wheel

#git submodule update --init --recursive

bash -c 'export CMAKE_ARGS="-DONNX_WERROR=ON"; \
export CMAKE_ARGS="${CMAKE_ARGS} -DONNXIFI_DUMMY_BACKEND=ON"; \
export ONNX_NAMESPACE=ONNX_NAMESPACE_FOO_BAR_FOR_CI; \
export ONNX_BUILD_TESTS=1; \
python setup.py --quiet bdist_wheel --universal --dist-dir .; \
find . -maxdepth 1 -name "*.whl" -ls -exec pip install {} \;'

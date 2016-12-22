#!/bin/bash

echo "deploy stage after success. uploading files..."
pip install twine
VERSION="$(python setup.py --version)"

if [[ "$UPLOAD_SDIST" == "1" ]]; then
    echo " -> uploading source distribution"
    python setup.py sdist
    twine upload -u $PYPI_USERNAME -p $PYPI_PASSWORD dist/vmprof-$VERSION.tar.gz
fi

if [[ "$MAC_WHEEL" == "1" ]]; then
    echo " -> uploading mac wheel distribution"
    pip install auditwheel
    pip wheel . -w dist
    for whl in dist/*.whl; do
        if [[ $whl == *"vmprof"* ]]; then
            auditwheel repair $whl -w dist/
        fi
    done
    twine upload -u $PYPI_USERNAME -p $PYPI_PASSWORD dist/vmprof-$VERSION.tar.gz
fi

if [[ "$BUILD_LINUX_WHEEL" == "1" ]]; then
    echo " -> uploading wheels"
    twine upload -u $PYPI_USERNAME -p $PYPI_PASSWORD wheels/vmprof-$VERSION*.whl
fi

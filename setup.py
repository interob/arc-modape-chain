#!/usr/bin/env python
# pylint: disable=invalid-name,E0401
import os
import sys
import setuptools

try:
    from src import _version
except ImportError:
    sys.path.append(os.path.dirname(__file__))
    from src import _version

assert setuptools.__version__ == "57.5.0", \
    "Installing arc-modape-chain is bound to GDAL 3.2.0 which requires Setuptools version 57.5.0"

setuptools.setup(
    version=_version.__version__,
    python_requires=">=3, <4",
)

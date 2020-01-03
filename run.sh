#!/bin/bash
set -e
# Include current directory in LD_LIBRARY_PATH, to find fmod dynamic library
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:libraries/x86_64-linux/"
./steam_cge

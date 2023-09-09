#!/bin/sh
#
# Requires:
#   python3: python3
#     pip3 install morph-kgc # in r2rml/requirements.txt

set -eu

CURDIR=`dirname "$0"`
cd $CURDIR

python3 -m morph_kgc data-ice.ini

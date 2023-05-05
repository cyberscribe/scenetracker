#!/bin/bash
if [[ "$#" -ne 3 ]]; then
    echo "Usage: write.sh act scene page"
    exit 1
fi
./venv/bin/python write.py $@

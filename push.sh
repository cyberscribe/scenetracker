#!/bin/bash
if [[ "$#" -ne 3 ]]; then
    echo "Usage: push.sh act scene page"
    exit 1
fi
./venv/bin/python3 push.py "$@"

#!/bin/bash

cd /var/www/html

if [[ -f bin/cli ]]; then
    echo $(bin/cli status)

    if [[ $(bin/cli status --code) != '3' ]]; then
        bin/cli install --fast --no-interaction
    fi
fi
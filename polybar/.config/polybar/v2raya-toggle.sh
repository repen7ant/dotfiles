#!/bin/bash

if systemctl is-active --quiet v2raya; then
    sudo systemctl stop v2raya
else
    sudo systemctl start v2raya
fi

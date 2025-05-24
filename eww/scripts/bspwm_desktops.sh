#!/bin/bash

bspc subscribe report |
while read -r line; do
    # Each desktop is prefixed by: 
    #   - O: occupied, F: focused, U: urgent, o: free
    #   - L: locked, G: sticky, P: private (capitalized if focused)
    desktops=()
    while [[ $line =~ ([oOfuFU][a-zA-Z0-9_-]+) ]]; do
        code="${BASH_REMATCH[1]}"
        state="${code:0:1}"
        name="${code:1}"

        if [[ "$state" =~ [FOU] ]]; then
            desktops+=("{\"name\":\"$name\",\"focused\":true}")
        else
            desktops+=("{\"name\":\"$name\",\"focused\":false}")
        fi

        line=${line#*"${code}"}
    done

    echo "[${desktops[*]}]"
done

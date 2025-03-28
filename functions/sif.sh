#!/bin/bash

function sif() {
	cd ~/Documents/code/projects/sif
	
	local url=""
    local s_flag=false
    local d_flag=false
    
    if [ $# -lt 1 ]; then
        echo "Error: Missing url."
        echo "Usage: sif <url> [-s] [-d]"
        return 1
    fi

    url="https://$1"
    shift

    while [ $# -gt 0 ]; do
        case "$1" in
            -s)
                s_flag=true
                ;;
            -d)
                d_flag=true
                ;;
            *)
                echo "Error: Unknown option: $1"
                echo "Usage: sif <url> [-s] [-d]"
                return 1
                ;;
        esac
        shift
    done

    echo "url: $url"
    
    if $s_flag; then
        ./sif -u $url -dnslist medium
    fi
    
    if $d_flag; then
        ./sif -u $url -dirlist medium
    fi
}

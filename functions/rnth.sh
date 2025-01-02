#!/bin/bash
function rnth() {
    NUM=$1
    ls --color=never | tail -n$((NUM+1)) | head -n1
}

function cdnth() {
    NUM=$1
    cd "$(rnth $((NUM)))"   
}
#!/bin/bash

function cd() {
    builtin cd "$@" && ls
}
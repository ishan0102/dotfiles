#!/bin/bash

# cd
function cd() {
	builtin cd "$@" && ls
}
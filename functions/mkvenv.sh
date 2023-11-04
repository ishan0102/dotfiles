#!/bin/bash

# Create a new python3 virtual environment
function mkvenv() {
    python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
}
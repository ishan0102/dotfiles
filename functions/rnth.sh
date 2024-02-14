#!/bin/bash

function rnth() {
	NUM=$1
	ls | tail -n$((NUM+1)) | head -n1
}

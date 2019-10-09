#!/bin/sh

docker run --rm --init -v `pwd`:/src taobeier/backslide export

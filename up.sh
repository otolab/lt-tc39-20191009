#!/bin/sh

docker run --rm --init -p 4100:4100 -v `pwd`:/src taobeier/backslide serve -s -p 4100

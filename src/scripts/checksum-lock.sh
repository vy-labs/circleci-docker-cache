#!/bin/bash
if [ -f "poetry.lock" ]; then
    checksum_python=$(md5sum poetry.lock | awk '{print $1}')
else
    checksum_python="n"
fi

if [ -f "Gemfile.lock" ]; then
    checksum_ruby=$(md5sum Gemfile.lock | awk '{print $1}')
else
    checksum_ruby="n"
fi

echo "$checksum_python-$checksum_ruby" > /tmp/checksum_key

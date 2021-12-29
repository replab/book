#!/bin/bash -l

# This script builds the sphinx documentation

echo "Executing entrypoint.sh"

echo argument=$1

pwd
ls -al

git rev-parse HEAD

# Prepare doc folder and install python requirements
ls -al docs
pip3 install -r sphinx/requirements.txt

# Run commands
if ./build.sh; then
  # Check where we ended up and what's going on where we are
  pwd
  ls -alh docs
else
  # The commands failed
  exit 1
fi

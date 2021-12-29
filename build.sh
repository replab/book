#! /usr/bin/bash

# call sphinx
sphinx-build -b html sphinx docs

# return exit code
status=$?
exit $status


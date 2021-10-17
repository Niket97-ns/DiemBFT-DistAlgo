#!/bin/sh

currLogFile="file$1.log"
echo "${currLogFile}"



cmdd="python -m da --logfile $currLogFile signing_test.da"
eval $cmdd
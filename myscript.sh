#!/bin/bash

BUILD_HOST="rschmied@172.17.0.1"
PROJECTS="projects"

echo "building stuff..."
#ls -la
#env

echo "copying files to destination"
scp -r ${PROJECTS}/ ${BUILD_HOST}:
ssh ${BUILD_HOST} "

# activate the environment
source venv/bin/activate
cd $PROJECTS

# create the log directory and empty it
test -d LOGS || mkdir LOGS
rm LOGS/*

# run the sim for all sim test definitions
for v in $(find . -name \"*.yml\" -type f); do
    virltester 2>&1 --nocolor \"$v\" | tee $(basename -s yml \"$v\")log
done

# move all log files into the artifacts dir
mv *.log LOGS
"

retcode=$?

if [ $retcode -eq 0 ]; then
    echo "copying file back"
    scp -r ${BUILD_HOST}:${PROJECTS}/ .
fi

exit $retcode

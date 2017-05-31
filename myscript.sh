#!/bin/bash

BUILD_HOST="rschmied@172.17.0.1"
VIRL_HOST=""
PROJECTS="projects"

echo "building stuff..."
#ls -la
#env

echo "copying files to destination"
scp -r ${PROJECTS}/ ${BUILD_HOST}:
ssh ${BUILD_HOST} "
source venv/bin/activate
cd $PROJECTS
mkdir LOGS
touch LOGS/GAGA
virltester --help
"

echo "copying file back"
scp -r ${BUILD_HOST}/${PROJECTS}/ .

exit 0

#!/bin/bash

BUILD_HOST="rschmied@172.17.0.1"
VIRL_HOST=""

echo "building stuff..."

echo "copying files to destination"
scp -r project/ ${BUILD_HOST}:
ssh ${BUILD_HOST} '
source venv/bin/activate;
cd project
touch GAGA
virltester --help
'

echo "copying file back"
scp -R ${BUILD_HOST}/project/ .

exit 0

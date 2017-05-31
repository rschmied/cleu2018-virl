#!/bin/bash

BUILD_HOST="rschmied@172.17.0.1"

echo "building stuff..."
echo "copying files to destination"
scp 2>&1 -r projects/ ${BUILD_HOST}:

printenv VIRL_HOST
printenv VIRL_PORT

VIRL_PORT=$(printenv VIRL_HOST)
VIRL_HOST=$(printenv VIRL_PORT)

ssh ${BUILD_HOST} '

'VIRL_HOST=$VIRL_HOST'
'VIRL_PORT=$VIRL_PORT'

# activate the environment
source venv/bin/activate
cd projects

# create the log directory and empty it
test -d LOGS || mkdir LOGS
rm LOGS/*

# run the sim for all sim test definitions
#for v in \"$(find . -name *.yml -type f)\"; do
echo "HOST:"$VIRL_HOST
for file in ./*.yml
do
    echo \"[\"$file\"]\"
    virltester 2>&1 --nocolor $file | tee $(basename -s yml $file)log
done
# move all log files into the artifacts dir
mv *.log LOGS

'


retcode=$?

if [ $retcode -eq 0 ]; then
    echo "copying file back"
    scp -r ${BUILD_HOST}:projects/LOGS/ .
fi

exit $retcode

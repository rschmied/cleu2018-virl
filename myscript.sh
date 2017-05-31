#!/bin/bash

BUILD_HOST="rschmied@172.17.0.1"

echo "building stuff..."

echo "erasing destination"
ssh ${BUILD_HOST} 'rm -rf projects'

echo "copying files to destination"
scp 2>&1 -r projects/ ${BUILD_HOST}:

echo "running the simulation(s)"
ssh ${BUILD_HOST} '

'VIRL_HOST=$(printenv VIRL_HOST)'
'VIRL_PORT=$(printenv VIRL_PORT)'
'VIRL_LXC_PORT=$(printenv VIRL_LXC_PORT)'

# activate the environment
export VIRL_HOST
export VIRL_PORT
export VIRL_LXC_PORT
source venv/bin/activate
cd projects

# create the log directory and empty it
test -d LOGS && rm -rf LOGS
mkdir LOGS

# run the sim for all sim test definitions
status=0
for file in $(find . -name \*.yml -type f); do
    echo "*** $file ***"
    simname=$(basename -s .yml $file)

    virltester 2>&1 -l3 --nocolor $file | tee ${simname}.log
    if ! [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo "FAILED"
        let status+=1
    fi
    echo "CODE: " $status

    # move all log files into the artifacts dir
    echo "move files to logdir"
    mkdir LOGS/$simname
    mv *.log LOGS/$simname/

done
echo "FINAL code: " $status
exit $status
'


retcode=$?

if [ $retcode -eq 0 ]; then
    echo "copying files back"
    scp -r ${BUILD_HOST}:projects/LOGS/ .
fi

exit $retcode

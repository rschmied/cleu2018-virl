#!/bin/bash
echo "building stuff..."
ssh rschmied@172.17.0.1 'source venv/bin/activate; virltester --help'
exit 0

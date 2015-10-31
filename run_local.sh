#!/bin/bash
#
# Use this script to run the everware analysis container
# on your local computer.
#
# This script starts a docker container and makes the repository
# available to you via your browser just like `everware` would.
# This is useful for running your analysis locally and testing
# if the Dockerfile you made works.
#
# This script does not build the docker image for you. You can
# do this with a command like:
#
#   docker build -t betatim/everware_cern_analysis .
#
# Once you have done this, replace the value of $CONTAINER
# with the tag you gave to the container when building it.
#
set -e
WORKDIR=`pwd`

CONTAINER="betatim/everware_cern_analysis:31102015"

# Directory inside the container which will contain the analysis code
C_ANADIR="/home/jupyter/analysis"

# Unclear why exactly you need to run the notebook with `sh -c`
# Found this solution from ipython/ipython#7062 and ipython/docker-notebook#6
container_id=`docker run -d -v $WORKDIR:$C_ANADIR -p 8888 $CONTAINER sh -c "ipython notebook --port=8888 --ip=0.0.0.0 --no-browser --notebook-dir=$C_ANADIR"`

if hash boot2docker 2>/dev/null; then
    connect_string=`docker port $container_id 8888 | sed -e 's/0.0.0.0/'$(boot2docker ip)'/'`
else
    connect_string=`docker port $container_id 8888`
fi

echo "Once you are done run the following two commands to clean up:"
echo
echo "    docker stop "$container_id
echo "    docker rm "$container_id
echo
echo "To get started point your browser at: "$connect_string

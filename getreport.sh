#!/bin/bash
#Get a Aqua MicroScanner HTML report from the container to the host
cid=$(docker create $1)
echo $cid
docker cp $cid:/amc-output.html amc-output$2.html
docker rm -v $cid
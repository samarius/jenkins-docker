#!/bin/bash

docker run \
    --name "jenkins" \
    -p 8080:8080 \
    -d \
    samarius/jenkins

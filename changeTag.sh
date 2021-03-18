#! /bin/bash

sed "s/tagNumber/$1/g" Deployment-apiserver.yaml > deployment-config.k8s.yaml
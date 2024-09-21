#!/bin/bash

set -x

catch_delete_deployment() {
  argocd app delete ${NAME}
}

NAME=$1
REPO=$2
REVISION=$3
NAMESPACE=$4
DESTINATION_SERVER=$5
LABEL=$6
ARGOCD_SERVER=$7

argocd login ${ARGOCD_SERVER} --name "admin" --password "FTzSauYgabur1-S7" --grpc-web --insecure --username admin

argocd app delete ${NAME}
sleep 30

argocd app create ${NAME} --repo ${REPO} \
        --insecure \
        --helm-chart ${NAME} \
        --revision ${REVISION}  \
        --dest-namespace ${NAMESPACE}\
        --dest-server ${DESTINATION_SERVER} \
        --sync-policy none \
        --name ${NAME} \
        --label ${LABEL} \
        #--self-heal \
        #--sync-option Prune=true \
        #--sync-retry-limit 10 \
        --validate \
        --server ${ARGOCD_SERVER}
sleep 30

argocd app sync ${NAME} --force
sleep 30

trap catch_delete_deployment SIGTERM 

sleep 365d

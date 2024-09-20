#!/bin/bash

set -x

NAME=$1
REPO=$2
REVISION=$3
NAMESPACE=$4
DESTINATION_SERVER=$5
LABEL=$6
ARGOCD_SERVER=$6

argocd app create ${NAME} --repo ${REPO} \
        --insecure \
        --helm-chart ${NAME} \
        --revision ${REVISION}  \
        --dest-namespace ${NAMESPACE}\
        --dest-server ${DESTINATION_SERVER} \
        --sync-policy automatic \
        --name ${NAME} \
        --label ${LABEL} \
        --self-heal \
        --sync-option Prune=true \
        --sync-retry-limit 10 \
        --validate \
        --server ${ARGOCD_SERVER}


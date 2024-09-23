#!/bin/bash

set -x

sleep 7
# Create a ArgoCD app from git
declare NAME=$1
declare REPO=$2
declare PATH=$3
declare NAMESPACE=$4
declare DESTINATION_SERVER=$5
declare LABEL=$6
declare ARGOCD_SERVER=$7
declare VALUES_FILE=$8
sleep 7

catch_delete_deployment() {
  /usr/local/bin/argocd app delete argo-cd/${NAME} \
	--app-namespace ${NAMESPACE} \
	--yes --propagation-policy foreground --cascade \
        --insecure \
        --server ${ARGOCD_SERVER}
}

/usr/local/bin/argocd login ${ARGOCD_SERVER} --name "admin" --password "FTzSauYgabur1-S7" --grpc-web --insecure --username admin

sleep 7

exit 0
sleep 7

argocd app set ${NAME} --values ${REPO}/${PATH}/${VALUES_FILE}

argocd app create ${NAME} --repo ${REPO} \
        --insecure \
        --path ${PATH} \
        --dest-namespace ${NAMESPACE}\
        --dest-server ${DESTINATION_SERVER} \
        --sync-policy automatic \
        --self-heal \
        --sync-option Prune=true \
        --sync-option CreateNamespace=true \
        --sync-retry-limit 10 \
        --name ${NAME} \
        --label ${LABEL} \
        --validate \
	--upsert \
        --server ${ARGOCD_SERVER}
sleep 7

trap catch_delete_deployment SIGTERM SIGTSTP EXIT 

while true; do
  sleep 7;
done

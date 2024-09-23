#!/usr/bin/env bash

set -x

catch_delete_deployment() {
  /usr/local/bin/argocd app delete argo-cd/${NAME} \
	--app-namespace ${NAMESPACE} \
	--yes --propagation-policy foreground --cascade \
        --insecure \
        --server ${ARGOCD_SERVER}
}

# Create a ArgoCD app from git
NAME=$1
REPO=$2
PATH=$3
NAMESPACE=$4
DESTINATION_SERVER=$5
LABEL=$6
ARGOCD_SERVER=$7
VALUES_FILE=$8

/usr/local/bin/argocd login ${ARGOCD_SERVER} --name "admin" --password "FTzSauYgabur1-S7" --grpc-web --insecure --username admin

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

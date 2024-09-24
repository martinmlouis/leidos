#!/bin/bash

set -x

catch_delete_deployment() {
  #argocd app delete ${NAME} --wait --yes --propagation-policy foreground --cascade 
  #argocd login ${ARGOCD_SERVER} --name "admin" --password "FTzSauYgabur1-S7" --grpc-web --insecure --username admin
  #sleep 7
  argocd app delete argo-cd/${NAME} \
	--app-namespace ${NAMESPACE} \
	--yes --propagation-policy foreground --cascade \
        --insecure \
        --server ${ARGOCD_SERVER}
}

NAME=$1
REPO=$2
REVISION=$3
NAMESPACE=$4
DESTINATION_SERVER=$5
LABEL=$6
ARGOCD_SERVER=$7

argocd login http://${ARGOCD_SERVER} --name "admin" --password "UEdnzGuEOq-3nnqn" --grpc-web --insecure --username admin

sleep 77

if [[ $(argocd app list |grep ${NAME}|wc -l) > 0 ]]; then
argocd app patch ${NAME} --repo ${REPO} \
        --insecure \
        --helm-chart ${NAME} \
        --revision ${REVISION}  \
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
  sleep 365d
fi

argocd app create ${NAME} --repo ${REPO} \
        --insecure \
        --helm-chart ${NAME} \
        --revision ${REVISION}  \
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
        --server http://${ARGOCD_SERVER}
sleep 7

trap catch_delete_deployment SIGTERM SIGTSTP EXIT 

while true; do
  sleep 77;
done

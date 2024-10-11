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

if [ $(echo "${ARGOCD_SERVER}"|grep dev|wc -l) > 0 ]; then
  ENVIRONMENT="prod"     
elif [ $(echo "${ARGOCD_SERVER}"|grep "test"|wc -l) > 0 ]; then
  ENVIRONMENT="test"    
elif [ $(echo "${ARGOCD_SERVER}"|grep impl|wc -l) > 0 ]; then
  ENVIRONMENT="impl"    
elif [ $(echo "${ARGOCD_SERVER}"|grep prod|wc -l) > 0 ]; then
  ENVIRONMENT="prod"
fi

argocd login ${ARGOCD_SERVER} --name "admin" --password "3THH9qWBzQnV4JrA" --grpc-web --insecure --username admin

sleep 7


if [ "$(argocd app list |grep "${NAME}"|wc -l)" -gt  "0" ]; then
  argocd app patch ${NAME} --patch "{\"spec\": { \"source\": { \"helm\": {\"valueFiles\": [\"${ENVIRONMENT}-values.yaml\"] } }}}" --type merge
  #argocd app delete ${NAME}
  sleep 120
fi


trap catch_delete_deployment SIGTERM SIGTSTP EXIT 

while true; do
  sleep 1;
done

argocd app create ${NAME} --repo ${REPO} \
        --values "${ENVIRONMENT}-values.yaml" \
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
sleep 7

trap catch_delete_deployment SIGTERM SIGTSTP EXIT 

while true; do
  sleep 1;
done

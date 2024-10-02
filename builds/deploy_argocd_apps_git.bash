#!/bin/bash

set -x

# Create a ArgoCD app from git
declare NAME=$1
declare REPO=$2
declare PATH=$3
declare NAMESPACE=$4
declare DESTINATION_SERVER=$5
declare LABEL=$6
declare ARGOCD_SERVER=$7
declare VALUES_FILE=$8

if [ $(echo "${ARGOCD_SERVER}"|grep dev|wc -l) > 0 ]; then
  ENVIRONMENT="prod"
elif [ $(echo "${ARGOCD_SERVER}"|grep "test"|wc -l) > 0 ]; then
  ENVIRONMENT="test"
elif [ $(echo "${ARGOCD_SERVER}"|grep impl|wc -l) > 0 ]; then
  ENVIRONMENT="impl"
elif [ $(echo "${ARGOCD_SERVER}"|grep prod|wc -l) > 0 ]; then
  ENVIRONMENT="prod"
fi

/usr/local/bin/argocd login "${ARGOCD_SERVER}" --name "admin" --password "UQ0g7aTIafIfAzJS" --grpc-web --insecure --username admin

/bin/sleep 7

/usr/local/bin/argocd app create "${NAME}" --repo "${REPO}" \
        --values "${VALUES_FILE}" \
        --insecure \
        --path "${PATH}" \
        --dest-namespace "${NAMESPACE}"\
        --dest-server "${DESTINATION_SERVER}" \
        --sync-policy automatic \
        --self-heal \
        --sync-option Prune=true \
        --sync-option CreateNamespace=true \
        --sync-retry-limit 10 \
        --name "${NAME}" \
        --label "${LABEL}" \
        --validate \
	--upsert \
        --server "${ARGOCD_SERVER}"

/bin/sleep 7


exit 0


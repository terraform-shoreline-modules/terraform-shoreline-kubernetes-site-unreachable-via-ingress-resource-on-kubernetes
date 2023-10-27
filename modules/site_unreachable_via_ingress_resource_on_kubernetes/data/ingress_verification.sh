

#!/bin/bash



# Set the ingress name and namespace

INGRESS_NAME=${INGRESS_NAME}

NAMESPACE=${NAMESPACE}



# Check the ingress configuration settings

ingress=$(kubectl get ingress $INGRESS_NAME -n $NAMESPACE -o json)

if [[ $? -ne 0 ]]; then

  echo "Error: Ingress $INGRESS_NAME not found in namespace $NAMESPACE"

  exit 1

fi



# Verify that the ingress is properly configured

rules=$(echo $ingress | jq -r '.spec.rules')

if [[ $rules == "" ]]; then

  echo "Error: Ingress $INGRESS_NAME in namespace $NAMESPACE has no rules configured"

  exit 1

fi



# Check that the ingress is routing traffic to the correct destination

backend=$(echo $ingress | jq -r '.spec.rules[0].http.paths[0].backend.service.name')

if [[ $backend != "${SERVICE_NAME}" ]]; then

  echo "Error: Ingress $INGRESS_NAME in namespace $NAMESPACE is not routing traffic to the correct destination"

  exit 1

fi



echo "Ingress $INGRESS_NAME in namespace $NAMESPACE is properly configured and routing traffic to the correct destination"
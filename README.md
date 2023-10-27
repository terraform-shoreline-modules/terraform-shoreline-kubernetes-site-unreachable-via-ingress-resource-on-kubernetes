
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Site Unreachable via Ingress Resource on Kubernetes
---

This incident type occurs when a website or service deployed on Kubernetes is not accessible via the ingress resource. The incident may be caused by various issues such as the ingress controller not running, misconfigured ingress resources, incorrect service selectors, and no running pods associated with the service. Troubleshooting steps may involve checking the logs of the ingress controller, inspecting the created ingress resources, describing the service and pods, and making sure the ports and endpoints are properly configured.

### Parameters
```shell
export NAMESPACE="PLACEHOLDER"

export POD_NAME="PLACEHOLDER"

export INGRESS_NAME="PLACEHOLDER"

export SERVICE_NAME="PLACEHOLDER"

export LABEL="PLACEHOLDER"

export BACKEND_SERVICE="PLACEHOLDER"

export BACKEND_PORT="PLACEHOLDER"
```

## Debug

### Check the connectivity to website
```shell
# Use curl to check the website connectivity

curl -I $WEBSITE_URL
```

### Check if ingress controller is running
```shell
kubectl get pods -n ${NAMESPACE}
```

### Check the logs of ingress controller
```shell
kubectl logs ${POD_NAME} -n ${NAMESPACE}
```

### Check the created ingress resources
```shell
kubectl get ingress -n ${NAMESPACE}
```

### Describe the ingress resources and verify the ingress resource configuration
```shell
kubectl describe ingress ${INGRESS_NAME} -n ${NAMESPACE}
```

### Describe the service
```shell
kubectl describe service ${SERVICE_NAME} -n ${NAMESPACE}
```

### Check if there are running pods associated with the service
```shell
kubectl get pods -n ${NAMESPACE} -l ${LABEL}
```

### Make sure the ports are matching to what you expected
```shell
kubectl describe service ${SERVICE_NAME} -n ${NAMESPACE}
```

### Check the IP column to make sure it is going to the correct pod IP
```shell
kubectl get pods -n ${NAMESPACE} -o wide 
```



### Check the ingress configuration settings to ensure that they are properly set up and routing traffic to the correct destination.
```shell


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


```
## Repair

### Check the created ingress resources and verify that they are properly configured to route traffic to the intended service and port.
```shell


#!/bin/bash



# Get the ingress resource name and namespace as command line arguments

ingress_name=${INGRESS_NAME}

namespace=${NAMESPACE}



# Get the backend service and port from the ingress resource

backend_service=$(kubectl get ingress $ingress_name -n $namespace -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}')

backend_port=$(kubectl get ingress $ingress_name -n $namespace -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}')



# Update the ingress resource with the correct backend service and port

kubectl patch ingress $ingress_name -n $namespace -p '{"spec":{"rules":[{"http":{"paths":[{"path":"/","backend":{"serviceName":"'${BACKEND_SERVICE}'","servicePort":'${BACKEND_PORT}'}}]}}]}}'


```
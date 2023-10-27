

#!/bin/bash



# Get the ingress resource name and namespace as command line arguments

ingress_name=${INGRESS_NAME}

namespace=${NAMESPACE}



# Get the backend service and port from the ingress resource

backend_service=$(kubectl get ingress $ingress_name -n $namespace -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}')

backend_port=$(kubectl get ingress $ingress_name -n $namespace -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}')



# Update the ingress resource with the correct backend service and port

kubectl patch ingress $ingress_name -n $namespace -p '{"spec":{"rules":[{"http":{"paths":[{"path":"/","backend":{"serviceName":"'${BACKEND_SERVICE}'","servicePort":'${BACKEND_PORT}'}}]}}]}}'
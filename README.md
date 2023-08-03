
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High Request Duration on CoreDNS
---

This incident type refers to an alert triggered due to high request duration on CoreDNS, which is a DNS server that translates domain names to IP addresses. The alert indicates that the request duration process for CoreDNS is high, meaning that it is taking longer than expected to process DNS requests. This can cause delays or failures in the resolution of domain names, leading to potential service disruptions or outages.

### Parameters
```shell
# Environment Variables

export POD_NAME="PLACEHOLDER"

export SERVICE_NAME="PLACEHOLDER"

export NAMESPACE="PLACEHOLDER"

export DEPLOYMENT_NAME="PLACEHOLDER"

export CPU_LIMIT="PLACEHOLDER"

export MEMORY_LIMIT="PLACEHOLDER"

export CPU_REQUEST="PLACEHOLDER"

export MEMORY_REQUEST="PLACEHOLDER"
```

## Debug

### Get the name(s) of the pod(s) running CoreDNS
```shell
kubectl get pods -l k8s-app=kube-dns
```

### Check the logs of the CoreDNS pod(s) for errors
```shell
kubectl logs ${POD_NAME} -n kube-system
```

### Check the CPU and memory usage of the CoreDNS pod(s)
```shell
kubectl top pods -n kube-system | grep ${POD_NAME}
```

### Check the Kubernetes events related to the CoreDNS pod(s)
```shell
kubectl get events --sort-by=.metadata.creationTimestamp | grep ${POD_NAME}
```

### Check the status of the container(s) in the CoreDNS pod(s)
```shell
kubectl describe pod ${POD_NAME} -n kube-system | grep -A 2 -B 2 ContainerStatuses:
```

### Check the network latency between the CoreDNS pod(s) and other pods/services
```shell
kubectl exec ${POD_NAME} -n kube-system -- nslookup ${SERVICE_NAME}
```

### Check the Kubernetes services and endpoints related to CoreDNS
```shell
kubectl get svc,endpoints -n kube-system | grep kube-dns
```

## Repair

### Scale the CoreDNS deployment to handle the increased load.
```shell
kubectl scale deployment $DEPLOYMENT_NAME --replicas=$REPLICAS -n $NAMESPACE
```

### Update resources limits for CoreDNS deployment to handle the increased load.
```shell
kubectl patch deployment ${DEPLOYMENT_NAME} -n ${NAMESPACE} --type=json -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/resources", "value": {"limits": {"cpu": "${CPU_LIMIT}", "memory": "${MEMORY_LIMIT}"}, "requests": {"cpu": "${CPU_REQUEST}", "memory": "${MEMORY_REQUEST}"}}}]'
```

### Increase the resources allocated to the affected system to handle the increased load.
```shell
kubectl set resources deployment <deployment-name> --limits=<resource-limits>
```
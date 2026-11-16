# Break scenarios

Pick a fault that matches something the user has already learned, ideally from
"Usikkert" in the progress file. Introduce exactly one fault at a time. Give
only the symptom, as a user or colleague would report it.

After they fix it, ask: "How would you have found this faster?" The goal is a
debugging method, not a memorized list:
`get` → `describe` (Events!) → `logs` (`--previous`) → `get events --sort-by=.lastTimestamp` → `exec`/debug Pod.

| # | Fault | How to introduce | Symptom to report | Teaches |
|---|-------|------------------|-------------------|---------|
| 1 | Wrong image tag | `kubectl set image` to a tag that doesn't exist | "The new version never came up" | ImagePullBackOff, Events, rollout undo |
| 2 | Crashing container | Override command to `exit 1` or bad arg | "Pods keep restarting" | CrashLoopBackOff, `logs --previous` |
| 3 | Selector mismatch | Change Service selector label | "Site is down, but Pods are Running" | Endpoints/EndpointSlices, labels |
| 4 | Wrong targetPort | Service targetPort ≠ containerPort | "Connection refused via the Service" | Port vs targetPort vs containerPort |
| 5 | Missing ConfigMap key | Reference a key that doesn't exist | "Pod stuck in CreateContainerConfigError" | Config dependencies |
| 6 | Failing readiness probe | Probe wrong path/port | "Pods Running but 0/1 Ready, no traffic" | Readiness vs liveness |
| 7 | Too-low memory limit | Limit far below need | "Pods die randomly" | OOMKilled, `describe` Last State |
| 8 | Impossible requests | CPU request larger than node | "New Pods stuck Pending" | Scheduler, FailedScheduling |
| 9 | PVC never binds | Non-existent storageClassName | "Database won't start" | PVC/PV/StorageClass |
| 10 | Wrong namespace | Create resource in another namespace | "I applied it but it isn't there" | Namespaces, context |
| 11 | Taint without toleration | Taint the worker node (multi-node) | "Pods Pending after a node change" | Taints/tolerations |
| 12 | RBAC denied | ServiceAccount without needed Role | "App logs show 403 Forbidden" | `auth can-i` |
| 13 | NetworkPolicy blocks DB | Default-deny without allow rule | "API can't reach database" | NetworkPolicy |
| 14 | Ingress host mismatch | Wrong host in Ingress rule | "404 from the ingress controller" | Ingress rules, controller logs |

Combine two faults only once the user handles single faults comfortably.

Before revealing the answer, let them climb the hint ladder. Afterwards,
restore the system or let them fix it themselves (preferred).

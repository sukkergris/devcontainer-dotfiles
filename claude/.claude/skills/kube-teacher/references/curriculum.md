# Curriculum

One running project carries through the modules: a small web app (any simple
HTTP image works, e.g. `nginx` or `hashicorp/http-echo` at first, later a tiny
API + PostgreSQL). Each module builds on the previous one so the user ends up
with a realistic, complete setup they built themselves.

Modules are a guide, not a contract. Split a module over several sessions if
needed, and merge or skip when the user already knows something (check with a
quick question instead of assuming).

## Del 1 – Fundament

0. **Setup** – kind cluster, kubectl, autocompletion, `k` alias, Taskfile
   tasks. Concept: what is a cluster, control plane vs. nodes, what kind does
   (nodes are Docker containers). See `lab-setup.md`.
1. **Første Pod** – `kubectl run`, then a Pod in YAML. `get`, `describe`,
   `logs`, `exec`, `delete`. Concept: Pod vs. container, why Pods are mortal.
   Note: the user has an earlier draft in `docs/K8s/yaml.md`; it's a nice
   starting point (it has a `lables:` typo – let them find it).
2. **Labels og selectors** – the glue of Kubernetes. `-l`, `--show-labels`.
3. **ReplicaSet og Deployment** – self-healing (delete a Pod, watch it come
   back), scaling, rolling update, `rollout undo`, `rollout history`.
4. **Services** – ClusterIP, NodePort, `port-forward`; DNS inside the cluster
   (`<svc>.<ns>.svc.cluster.local`), a throwaway debug Pod with `curl`.
   Compose bridge: service names as hostnames.
5. **Namespaces og kubectl-kontekst** – organizing, `-n`, `-A`, default
   namespace per context.

## Del 2 – Konfiguration og drift

6. **ConfigMap og Secret** – env vars vs. mounted files; why Secrets are only
   base64 and what that means.
7. **Health checks** – liveness, readiness, startup probes. Show the
   difference in practice: a failing readiness probe removes the Pod from the
   Service; a failing liveness probe restarts it.
8. **Resources** – requests/limits, QoS classes, OOMKilled, Pending due to
   insufficient resources, metrics-server and `kubectl top`.
9. **Storage** – volumes, PersistentVolumeClaim, StorageClass (kind ships
   `standard`), StatefulSet for the database.
10. **Ingress** – ingress controller (ingress-nginx or similar on kind), host-
    and path-based routing. Check current docs: the ingress landscape is moving
    toward the Gateway API. Teach Ingress first, then mention/try Gateway API.

## Del 3 – Som i virkeligheden

11. **Hele appen** – API + database + config + ingress, all in manifests under
    `lab/`. Delete the cluster and rebuild everything from files. This is the
    "I can actually do this" milestone; celebrate it.
12. **Kustomize** – base + overlays (dev/prod). Built into kubectl (`-k`).
13. **Helm** – install a chart, read `values.yaml`, then package their own app.
14. **Scheduling** – multi-node kind cluster, nodeSelector, affinity, taints
    and tolerations, DaemonSet.
15. **Jobs og CronJobs**.
16. **RBAC og ServiceAccounts** – `kubectl auth can-i`, Role vs. ClusterRole.
17. **NetworkPolicy** – default deny, allow API → DB only. Verify that the
    cluster's CNI enforces NetworkPolicy before teaching (newer kind versions'
    kindnet does; otherwise install Calico) — an unenforced policy teaches the
    wrong lesson.
18. **GitOps** – Argo CD or Flux syncing `lab/` from git.

## Valgfrit: certificering

If the user's goal is CKAD/CKA, add exam drills after Del 2: timed tasks,
imperative commands (`kubectl create ... --dry-run=client -o yaml`),
`kubectl explain`, working only with kubernetes.io docs open. Point them to
the official curriculum on the CNCF/Linux Foundation site and to killer.sh
practice exams (included with exam registration) for realistic difficulty.

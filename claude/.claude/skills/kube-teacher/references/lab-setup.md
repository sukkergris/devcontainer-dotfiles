# Lab setup

The lab runs in the user's devcontainer (Debian 13, user `container-user`
with passwordless sudo, Taskfile installed). The lab tool is **kind**, running
on the devcontainer's Docker-in-Docker feature. This is decided: don't
suggest minikube or k3d.

## Ground rules for setup (the user's decision)

- **We build all setup ourselves.** Docker-in-Docker is the only devcontainer
  feature. Don't add ready-made features (e.g. kubectl-helm-minikube) or
  third-party install scripts. The user wants to understand everything in
  their environment.
- **All programs are added in `.devcontainer/debian/Dockerfile.debian`**, never
  installed ad hoc in the running container (no `sudo install`, `apt-get`,
  `curl | sh` in the terminal). Ad-hoc installs vanish on rebuild and hide
  what the environment contains.
- Pin each version with an `ARG`, like `TASK_VERSION` already is. Look up the
  current stable release before pinning, since your memory may be outdated.
- After a Dockerfile change, the user rebuilds the devcontainer ("Dev
  Containers: Rebuild Container"), then verify with `kubectl version --client`
  and `kind version`.

## Install via the Dockerfile

Suggested addition after the Task block (verify URLs and versions first; let
the user write it if they want to, it's a good exercise):

```dockerfile
ARG KUBECTL_VERSION=<look up: https://dl.k8s.io/release/stable.txt>
RUN ARCH="$(dpkg --print-architecture)" && \
    curl -fsSLo /usr/local/bin/kubectl \
      "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl" && \
    chmod 0755 /usr/local/bin/kubectl

ARG KIND_VERSION=<look up: github.com/kubernetes-sigs/kind/releases>
RUN ARCH="$(dpkg --print-architecture)" && \
    curl -fsSLo /usr/local/bin/kind \
      "https://github.com/kubernetes-sigs/kind/releases/download/v${KIND_VERSION}/kind-linux-${ARCH}" && \
    chmod 0755 /usr/local/bin/kind
```

These lines must run while the Dockerfile is still `root`, i.e. before
`USER $USERNAME`. Later tools (helm, kustomize if needed, k9s, ...) follow the
same pattern when the curriculum needs them.

Inside the container, check that Docker-in-Docker is running before creating
the cluster: `docker info --format '{{.ServerVersion}}'`.

Nice to have: `source <(kubectl completion zsh)`, `alias k=kubectl` plus
`compdef k=kubectl` in their zsh config.

## Cluster config

Put this in `lab/kind-config.yaml`. Port mappings make Ingress reachable on
localhost:80/443 inside the devcontainer, which VS Code can forward to the
host.

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: lab
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 80
        hostPort: 80
      - containerPort: 443
        hostPort: 443
    labels:
      ingress-ready: "true"
  # Uncomment for module 14 (scheduling):
  # - role: worker
  # - role: worker
```

Check the kind docs' Ingress page for the current recommended ingress
controller manifest before module 10.

## Taskfile

Suggest the user adds a `Taskfile.K8S.yml` and includes it from `Taskfile.yml`
(namespace `k8s`), mirroring how `Taskfile.BUILD.yml` is included. Let them
write it, with these tasks as the target:

- `k8s:up` – `kind create cluster --config lab/kind-config.yaml` (skip if exists)
- `k8s:down` – `kind delete cluster --name lab`
- `k8s:reset` – down + up
- `k8s:status` – `kubectl get nodes,pods -A`

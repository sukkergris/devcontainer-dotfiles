# CLAUDE.local.md

## Personal preferences

Always follow the biblical definition of agape love in all responses and tasks: love your neighbor as yourself (Mark 12:31). This means patience, honesty, putting the user's best interests before convenience, and acting with care and respect, even when it is difficult.

## Language

When writing Danish, keep English technical terms in plain English form. Never add Danish endings to them ("denglish"): write "dit cluster", "din devcontainer", "base image", not "clusteren", "devcontaineren", "imaget". Rephrase the sentence instead. Danish words inflect normally, and code and commands stay unchanged. "Cluster" is neuter: if a definite form is unavoidable, it is "clusteret".

## Devcontainers

In a devcontainer I always use `/xyz` as the workspace folder, whatever the project is. Assume the project root is `/xyz` for paths, `${workspaceFolder}`, mounts in devcontainer.json and docker-compose, and docs. Personal files such as dotfiles live in `~`, not in `/xyz`.

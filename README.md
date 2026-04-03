# Quotes API Application

A containerized three-tier application that serves motivational quotes through a REST API and web frontend. Deployed with Docker Compose and fully migrated to Kubernetes with Secrets, Init Containers, Persistent Volumes, Health Probes, and Resource Limits.

## Architecture
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Frontend   │────▶│   Backend   │────▶│   MySQL DB   │
│  (Flask UI)  │     │ (Flask API) │     │  (mysql:5.7) │
│  Port: 3001  │     │  Port: 3000 │     │  Port: 3306  │
└─────────────┘     └─────────────┘     └─────────────┘
                     ▲ /healthz              ▲
                     │ liveness +        ┌───┴───────────┐
                     │ readiness         │  Data Script   │
                     │ probes            │ (Alpine+mysql) │
                                         │ Init Container │
                                         │ waits for DB   │
                                         └────────────────┘
```

## Services

| Service | Description | Port | Base Image | K8s Probes |
|---------|-------------|------|------------|------------|
| **front** | Web UI — greets user with a random quote | 3001 | python:3.6 | — |
| **back** | REST API — GET/POST quotes | 3000 | python:3.6 | Liveness + Readiness |
| **data** | MySQL database storing quotes | 3306 | mysql:5.7 | — |
| **data-script** | One-shot DB seeder with Init Container | — | alpine | Init Container |

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/v1/get-quote` | Returns a random quote |
| `POST` | `/api/v1/set-quote` | Adds a new quote |
| `GET` | `/healthz` | Health check (used by K8s probes) |

## Quick Start (Docker Compose)
```bash
git clone https://github.com/kim081890/quotes-app-docker-k8s.git
cd quotes-app-docker-k8s
cp .env.example .env
make build && make up
# Wait 2 minutes for DB seeding, then:
make test-all
```

## Kubernetes Deployment
```bash
make k8s-deploy
kubectl get pods,svc,pvc
```

## Production Features (Kubernetes)

| Feature | What it does | Why it matters |
|---------|-------------|----------------|
| **Secrets** | Credentials stored in `quotes-secret`, injected as env vars | No passwords in source code or image layers |
| **Init Container** | Polls MySQL every 2s before seeding | Replaces unreliable `sleep 120` |
| **PersistentVolumeClaim** | 5Gi EBS gp2 at `/var/lib/mysql` | Data survives pod restarts |
| **Liveness Probe** | `GET /healthz` every 15s | Auto-restarts unhealthy API pods |
| **Readiness Probe** | `GET /healthz` every 10s | Only routes traffic when DB connection is verified |
| **Resource Limits** | CPU/memory requests and limits on all containers | Prevents noisy-neighbor issues |

---
*312 School — DevOps Engineering Bootcamp, Batch 25C*
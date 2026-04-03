# Changelog

All notable changes to the Quotes App are documented in this file.

## [v2] - Kubernetes Migration

### Changed
- **back.py**: Removed hardcoded MySQL connection string. Now reads `SQLALCHEMY_DATABASE_URI` from environment variable via `os.environ`. This allows credentials to be injected by Kubernetes Secrets instead of living in source code.
- **import.sh**: Replaced hardcoded `mysql -h data -uroot -proot` with environment variables `$MYSQL_DB_HOST`, `$MYSQL_USER`, `$MYSQL_USER_PASSWORD`. Removed `sleep 120` — database readiness is now handled by a Kubernetes Init Container.

### Added
- Kubernetes Secret (`quotes-secret.yaml`) — single source of truth for all credentials
- Init Container on `data-script` — polls MySQL every 2 seconds until it responds, replacing the unreliable 120-second sleep
- PersistentVolumeClaim (`data-pvc.yaml`) — 5Gi EBS gp2 volume mounted at `/var/lib/mysql` so data survives pod restarts
- Liveness and Readiness probes on the `back` Deployment using the `/healthz` endpoint
- Resource requests and limits on all containers for predictable scheduling
- `api` Service as a DNS alias so `front.py` can resolve `http://api:3000` in Kubernetes

### Images
- `kim081890/quotes-back:v2` — updated back.py
- `kim081890/quotes-data-script:v2` — updated import.sh

## [v1] - Docker Compose Deployment

### Added
- Four-service architecture: front (Flask UI), back (Flask API), data (MySQL 5.7), data-script (Alpine seeder)
- Docker Compose orchestration with shared bridge network
- Dockerfiles for all 4 services with layer caching optimization
- REST API: GET `/api/v1/get-quote`, POST `/api/v1/set-quote`, GET `/healthz`
- Web frontend at `/hello/<n>` displaying random quotes

### Images
- `kim081890/quotes-back:v1`
- `kim081890/quotes-front:v1`
- `kim081890/quotes-data:v1`
- `kim081890/quotes-data-script:v1`
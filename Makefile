PHONY: build up down ps logs test-api test-post test-all clean

# ═══════════════════════════════════════════
#  Quotes App — Makefile
# ═══════════════════════════════════════════

## Build all Docker images
build:
	docker-compose build

## Start all services
up:
	docker-compose up -d

## Stop everything
down:
	docker-compose down

## Show running containers
ps:
	docker-compose ps

## Tail logs
logs:
	docker-compose logs -f

## Test GET quote
test-api:
	@echo "=== GET /api/v1/get-quote ==="
	curl -s http://localhost:3000/api/v1/get-quote | python3 -m json.tool

## Test POST quote
test-post:
	@echo "=== POST /api/v1/set-quote ==="
	curl -s -H "Content-Type: application/json" -X POST \
	  -d '{"quote":"Makefile test quote -- DevOps FTW"}' \
	  http://localhost:3000/api/v1/set-quote | python3 -m json.tool

## Test health
test-health:
	@echo "=== GET /healthz ==="
	curl -s http://localhost:3000/healthz | python3 -m json.tool

## Run all tests
test-all: test-health test-api test-post
	@echo "\n=== All tests passed ==="

## Show quotes in DB
show-quotes:
	docker exec db mysql -uroot -proot mydatabase -e "SELECT * FROM quotes;"

## Nuke everything
clean:
	docker-compose down --rmi all --volumes

## ═══════════════════════════════════════════
##  Kubernetes Commands
## ═══════════════════════════════════════════

## Deploy everything to Kubernetes
k8s-deploy:
	kubectl apply -f k8s/quotes-secret.yaml
	kubectl apply -f k8s/data-pvc.yaml
	kubectl apply -f k8s/data-service.yaml
	kubectl apply -f k8s/data-deployment.yaml
	kubectl apply -f k8s/back-service.yaml
	kubectl apply -f k8s/api-service.yaml
	kubectl apply -f k8s/back-deployment.yaml
	kubectl apply -f k8s/back-nodeport-service.yaml
	kubectl apply -f k8s/data-script-deployment.yaml
	kubectl apply -f k8s/front-deployment.yaml
	kubectl apply -f k8s/front-service.yaml
	@echo "\n=== All K8s resources applied ==="

## Show K8s status
k8s-status:
	kubectl get pods,svc,pvc,secrets

## Tear down K8s deployment
k8s-destroy:
	kubectl delete -f k8s/ --ignore-not-found
	@echo "\n=== All K8s resources deleted ==="
#!/usr/bin/env bash
# Run inside an isolated Ubuntu 24.04 lab VM with Docker installed.
set -Eeuo pipefail
cd "$(dirname "$0")/.."
sudo apt-get update
sudo apt-get install -y python3-venv curl
python3 -m venv "$HOME/autogarage-venv"
export PATH="$HOME/autogarage-venv/bin:$HOME/.local/bin:$PATH"
python -m pip install requests==2.32.3 playwright==1.51.1
python -m playwright install --with-deps chromium
printf '127.0.0.1 auth.lokal api.lokal\n' | sudo tee -a /etc/hosts
python scripts/bootstrap.py
mkdir -p evidence
uname -a > evidence/lab-uname.txt
cat /etc/os-release > evidence/lab-os-release.txt
docker compose config --quiet
docker compose up -d --build
docker version > evidence/docker-version.txt
docker compose version >> evidence/docker-version.txt
docker image inspect autogarage-uts:e2e --format '{{json .Id}}' > evidence/api-image-id.txt
python scripts/e2e.py compose | tee evidence/compose-checks.txt
python scripts/browser-proof.py compose
docker compose exec -T backend cat /app/models/manifest.json > evidence/model-manifest.json
docker compose logs --no-color > evidence/compose-service-logs.txt
docker compose down
mkdir -p "$HOME/.local/bin"
arch="$(uname -m)"
case "$arch" in aarch64) target_arch=arm64 ;; x86_64) target_arch=amd64 ;; *) exit 1 ;; esac
curl -fsSLo "$HOME/.local/bin/kind" "https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-$target_arch"
curl -fsSLo "$HOME/.local/bin/kubectl" "https://dl.k8s.io/release/v1.32.2/bin/linux/$target_arch/kubectl"
chmod +x "$HOME/.local/bin/kind" "$HOME/.local/bin/kubectl"
kind create cluster --name autogarage --image kindest/node:v1.32.2 --config kubernetes/kind.yaml
kind load docker-image autogarage-uts:e2e --name autogarage
kubectl version -o json > evidence/kubernetes-version.json
python scripts/deploy-k8s.py
python scripts/e2e.py kubernetes | tee evidence/kubernetes-checks.txt
python scripts/browser-proof.py kubernetes
kubectl -n autogarage get pods -o wide > evidence/kubernetes-pods.txt
kubectl -n autogarage get pvc > evidence/kubernetes-pvc.txt
kubectl -n autogarage get sts,svc,ingress > evidence/kubernetes-objects.txt
kubectl -n autogarage get events --sort-by=.lastTimestamp > evidence/kubernetes-events.txt
kubectl -n autogarage logs postgres-primary-0 > evidence/kubernetes-primary-logs.txt
git rev-parse HEAD > evidence/source-sha.txt
date -u +%FT%TZ > evidence/captured-at.txt
echo 'Local lab integration tests completed successfully.'

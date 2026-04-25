ENV=dev

init:
	@echo '## Initializing...'
	terraform -chdir=./aks-foundation init -upgrade
	@if [[ ($(ENV)=dev) || ($(ENV)=prd) ]]; then \
		echo '\n## Workspace selecting...'; \
		terraform -chdir=./aks-foundation workspace select $(ENV) || terraform -chdir=./aks-foundation workspace new $(ENV); \
		echo '\n selected: $(ENV)'; \
	else \
		echo 'Invalid value (production run: make init ENV=prd )'; \
		exit 1; \
	fi

plan: init
	@echo '## Planning...'
	terraform -chdir=./aks-foundation plan -out=tfplan

apply: plan
	@echo '## Applying...'
	@terraform show 'tfplan' >/dev/null 2>&1 || make plan
	terraform -chdir=./aks-foundation apply 'tfplan'
	rm ./aks-foundation/tfplan

destroy:
	@echo '## Destroying... TAKE CARE MAFREND!!!'
	@echo '## Deleting baseline-addons ArgoCD Application...'
	-kubectl delete application.argoproj.io baseline-addons -n control-plane-system --ignore-not-found --wait=true --timeout=120s
	terraform -chdir=./aks-foundation destroy -lock=false -auto-approve
	
upgrade: init plan apply

rm-tfplan:
	@echo '## Removing...'
	rm aks-foundation/tfplan

# ──────────────────────────────────────────────────────────────────────────────
# CI gates
#
# Invoked by .github/workflows/pr-check.yaml and .github/workflows/acc-test.yaml
# (which delegate to Azure/tfmod-scaffold reusable workflows). Those workflows
# run `make pr-check` and `make e2e-test` inside the azterraform container with
# the repo root mounted at /src.
# ──────────────────────────────────────────────────────────────────────────────

pr-check:
	@echo '## Pre-PR check: terraform fmt + init + validate ...'
	terraform -chdir=./aks-foundation fmt -check -recursive
	terraform -chdir=./aks-foundation init -backend=false -input=false
	terraform -chdir=./aks-foundation validate

build-test:
	@echo '## Build test (compile-only) ...'
	cd aks-foundation/test && go mod download && go build ./...

e2e-test:
	@echo '## E2E test ...'
	@if [ -z "$$ARM_CLIENT_ID" ] || [ -z "$$ARM_SUBSCRIPTION_ID" ] || [ -z "$$ARM_TENANT_ID" ]; then \
		echo 'Skipping: Azure credentials (ARM_CLIENT_ID / ARM_SUBSCRIPTION_ID / ARM_TENANT_ID) are not configured in this repository. Configure OIDC or repo secrets to enable e2e provisioning tests.'; \
	else \
		cd aks-foundation/test && go mod download && go test -v -timeout 90m ./e2e/...; \
	fi

version-upgrade-test:
	@echo '## Version upgrade test ...'
	@if [ -z "$$ARM_CLIENT_ID" ] || [ -z "$$ARM_SUBSCRIPTION_ID" ] || [ -z "$$ARM_TENANT_ID" ]; then \
		echo 'Skipping: Azure credentials (ARM_CLIENT_ID / ARM_SUBSCRIPTION_ID / ARM_TENANT_ID) are not configured in this repository. Configure OIDC or repo secrets to enable upgrade-path provisioning tests.'; \
	else \
		cd aks-foundation/test && go mod download && go test -v -timeout 120m ./upgrade/...; \
	fi

# environment-up:
# 	@echo '## Scaling up...'
# 	kubectl get ns  --no-headers -o custom-columns=":metadata.name" | grep -v kube | xargs -S 1024 -I {} sh -c 'kubectl annotate --overwrite namespace {} downscaler/force-; kubectl annotate --overwrite namespace {} downscaler/force-uptime="true"; kubectl label --overwrite namespace {} downscaler/manual="true"'
# 	kubectl scale --replicas=2 -n kube-system deployment coredns
# 	kubectl scale --replicas=2 -n kube-system deployment karpenter
# 	kubectl scale --replicas=2 -n kube-system deployment ebs-csi-controller

# environment-down:
# 	@echo '## Scaling down...'
# 	for ns in $(kubectl get ns --no-headers -o custom-columns=":metadata.name" | grep -v '^kube'); do echo "Processing $ns"; kubectl annotate --overwrite namespace $ns downscaler/force-uptime-; kubectl annotate --overwrite namespace $$ns downscaler/force-downtime-; kubectl label --overwrite namespace $$ns downscaler/manual-; done
# 	kubectl scale --replicas=1 -n kube-system deployment coredns
# 	kubectl scale --replicas=1 -n kube-system deployment karpenter
# 	kubectl scale --replicas=1 -n kube-system deployment ebs-csi-controller
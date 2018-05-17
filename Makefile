.PHONY: help check-keys build start attach stop

.DEFAULT_GOAL := help


help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'



check-keys:
ifndef DEPLOY_KEY
	$(error Variable DEPLOY_KEY must be specified)
endif
ifndef SIGN_KEY
	$(error Variable SIGN_KEY must be specified)
endif

build: ## Build alpine package host image
	docker build -t alpine-repo-host .

start: check-keys build ## Start alpine package host server
	docker run --privileged --rm -t -d --name alpine-apk-server -p80:80 -p6223:6223 -v $(realpath $(DEPLOY_KEY)):/keys/deploy_key/authorized_keys -v $(realpath $(SIGN_KEY)):/keys/sign_key/$(notdir $(SIGN_KEY)) alpine-repo-host

attach: ## Attach to running container
	docker exec -i -t alpine-apk-server /bin/sh

stop: ## Stop alpine package host server
	docker container stop alpine-apk-server

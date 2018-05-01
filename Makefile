.PHONY: check-keys
check-keys:
ifndef DEPLOY_KEY
	$(error DEPLOY_KEY must be specified.)
endif
ifndef SIGN_KEY
	$(error SIGN_KEY must be specified.)
endif

.PHONY: build-host
build-host:
	docker build -t alpine-repo-host .

.PHONY: start-it-host
start-it-host: check-keys build-host
	docker run --privileged -it --rm --name alpine-apk-server -p80:80 -p6223:6223 -v $(DEPLOY_KEY):/keys/deploy_key/authorized_keys -v $(SIGN_KEY):/keys/sign_key/$(notdir $(SIGN_KEY)) alpine-repo-host

.PHONY: start-host
start-host: build-host
		docker run --privileged --rm --name alpine-apk-server -p80:80 -p6223:6223 -d alpine-repo-host nginx

.PHONY: stop-host
stop-host:
	docker container stop alpine-apk-server

.PHONY: build-host
build-host:
	docker build -t alpine-repo-host .

.PHONY: start-it-host
start-it-host: build-host
	docker run --privileged -it --rm --name alpine-apk-server -p80:80 -p22:22 -p6223:6223 alpine-repo-host

.PHONY: start-host
start-host: build-host
		docker run --privileged --rm --name alpine-apk-server -p80:80 -p22:22 -p6223:6223 -d alpine-repo-host nginx

.PHONY: stop-host
stop-host:
	docker container stop alpine-apk-server

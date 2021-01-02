ID = 23oct2020
APP_IMAGE_NAME = sewardmap_app_$(ID)
BASE_IMAGE_NAME = map_app_09jul2020


default:
	R -f app.R


server:
	python3 -m http.server 9999 &



build:
	docker build -t $(APP_IMAGE_NAME) -f Dockerfile .

build.base:
	docker build -t $(BASE_IMAGE_NAME) -f Dockerfile-base .


bash:
	docker run -it \
           -p 4444:6789 \
           -v ~/github/sewardParkRestoration/allSites/:/appData \
           --entrypoint /bin/bash \
           $(APP_IMAGE_NAME)


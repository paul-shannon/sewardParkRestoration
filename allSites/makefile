default:
	R -f webapp.R


server:
	python3 -m http.server 9999 &



ID = 09jul2020
APP_IMAGE_NAME = sewardmap_app_$(ID)
BASE_IMAGE_NAME = map_app_$(ID)


build:
	docker build -t $(APP_IMAGE_NAME) -f Dockerfile .

build.base:
	docker build -t $(BASE_IMAGE_NAME) -f Dockerfile-base .


bash:
	docker run -it \
           -p 3838:6789 \
           --entrypoint /bin/bash \
           $(APP_IMAGE_NAME)


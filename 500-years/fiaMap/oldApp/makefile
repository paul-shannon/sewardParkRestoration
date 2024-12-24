ID = 23oct2020
APP_IMAGE_NAME = sewardmap_app_$(ID)
BASE_IMAGE_NAME = map_app_09jul2020

default:
	@echo tsvToSiteYaml
	@echo runLocal.localConfig
	@echo runLocal.remoteConfig
	@echo updateConfig

runLocal.localConfig:
	(export localConfig=TRUE; R -f app.R)

runLocal.remoteConfig:
	(export localConfig=FALSE; R -f app.R)


updateConfig:
	scp fiaSites.yaml paulshannnon@pshannon.net:public_html/pshannon.net/sewardParkRestoration/config/
	scp fiaRegions.yaml paulshannnon@pshannon.net:public_html/pshannon.net/sewardParkRestoration/config/

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

tsvToSiteYaml:
	R -f tsvToYaml.R

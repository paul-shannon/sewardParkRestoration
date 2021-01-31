SITE=5yearFernSurvivalExperiment
DEST=paulshannnon@pshannon.net:public_html/pshannon.net/sewardParkRestoration/$(SITE)/

default:  html

all: html png

html:
	scp *.html $(DEST)

jpg:
	- scp *.jpg $(DEST)

png: 
	- scp *.png $(DEST)

view:
	open https://pshannon.net/sewardParkRestoration/$(SITE)


SITE=fernHistory
DEST=paulshannnon@pshannon.net:public_html/pshannon.net/sewardParkRestoration/$(SITE)/

default:  html

all: html png jpg pdf

pdf:
	scp *.pdf $(DEST)

html:
	scp *.html $(DEST)

jpg:
	- scp *.jpg $(DEST)

png:
	- scp *.png $(DEST)

view:
	open https://pshannon.net/sewardParkRestoration/$(SITE)

mkdir:
	ssh paulshannnon@pshannon.net mkdir public_html/pshannon.net/sewardParkRestoration/$(SITE)/


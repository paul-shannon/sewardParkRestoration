SITE=westSideTriangle
DEST=paulshannnon@pshannon.net:public_html/pshannon.net/sewardParkRestoration/$(SITE)/

default:
	@echo mkdir, dir.check, all [html, jpg], view

mkdir:
	ssh paulshannnon@pshannon.net mkdir public_html/pshannon.net/sewardParkRestoration/$(SITE)/

dir.check:
	ssh paulshannnon@pshannon.net ls -l public_html/pshannon.net/sewardParkRestoration/$(SITE)

all: html jpg

html:
	scp *.html $(DEST)

jpg:
	- scp *.jpeg $(DEST)

view:
	open https://pshannon.net/sewardParkRestoration/$(SITE)


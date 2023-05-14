SITE=woodpeckerTrailHollowTree
DEST=paulshannnon@pshannon.net:public_html/pshannon.net/sewardParkRestoration/$(SITE)

default:
	@echo mkdir
	@echo dir.check
	@echo make html
	@echo make jpg
	@echo make all [html, jpg]
	@echo make view

all: html jpg

html:
	scp *.html $(DEST)

jpg:
	- scp *.jp*g $(DEST)

mkdir:
	ssh paulshannnon@pshannon.net mkdir public_html/pshannon.net/sewardParkRestoration/$(SITE)/

dir.check:
	ssh paulshannnon@pshannon.net ls -l public_html/pshannon.net/sewardParkRestoration/$(SITE)


view:
	open https://pshannon.net/sewardParkRestoration/$(SITE)








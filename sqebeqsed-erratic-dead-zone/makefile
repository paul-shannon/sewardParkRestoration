SITE=sqebeqsed-erratic-dead-zone
DEST=paulshannnon@pshannon.net:public_html/pshannon.net/sewardParkRestoration/$(SITE)/



default:
	@echo mkdir dirCheck html jpg view

all: html jpg

html:
	scp *.html $(DEST)

jpg:
	- scp *.jp*g $(DEST)

view:
	open https://pshannon.net/sewardParkRestoration/$(SITE)

mkdir:
	ssh paulshannnon@pshannon.net mkdir public_html/pshannon.net/sewardParkRestoration/$(SITE)/

dirCheck:
	ssh paulshannnon@pshannon.net ls -d public_html/pshannon.net/sewardParkRestoration/$(SITE)

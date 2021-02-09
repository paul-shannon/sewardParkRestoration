SITE=groundZeroContractorPlanting2019.Q1
DEST=paulshannnon@pshannon.net:public_html/pshannon.net/sewardParkRestoration/$(SITE)/

default:  html

all: html jpg

html:
	scp *.html $(DEST)

jpg:
	- scp *.png $(DEST)

view:
	open https://pshannon.net/sewardParkRestoration/$(SITE)

mkdir:
	ssh paulshannnon@pshannon.net mkdir public_html/pshannon.net/sewardParkRestoration/$(SITE)/


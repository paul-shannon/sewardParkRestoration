SITE=cliffIvy.002
DEST=paulshannnon@pshannon.net:public_html/pshannon.net/sewardParkRestoration/$(SITE)/

default:  html

all: html jpg

html:
	scp *.html $(DEST)

jpg:
	- scp *.jpg $(DEST)

view:
	open https://pshannon.net/sewardParkRestoration/$(SITE)


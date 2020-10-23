SITE=dougFir.039
DEST=paulshannnon@pshannon.net:public_html/pshannon.net/sewardParkRestoration/$(SITE)/

default:  html

all: html jpg

html:
	scp *.html $(DEST)

jpg:
	- scp *.jpg $(DEST)
	- scp *.jpeg $(DEST)

view:
	open http://pshannon.net/sewardParkRestoration/$(SITE)


SITE=fairyTree
DEST=paulshannnon@pshannon.net:public_html/pshannon.net/sewardParkRestoration/$(SITE)/

default:
	@echo dir.check, all [html, jpg], view


dir.check:
	ssh paulshannnon@pshannon.net ls -l public_html/pshannon.net/sewardParkRestoration/$(SITE)


jpg:
	scp 2020-07-19-beforeMulching/*.jpg $(DEST)
	scp 2020-07-23-afterMulching/*.jpg $(DEST)
	scp *.jpg $(DEST)
	scp *.jpeg $(DEST)

html:
	scp *.html $(DEST)

all: jpg html

view:
	open http://pshannon.net/sewardParkRestoration/$(SITE)



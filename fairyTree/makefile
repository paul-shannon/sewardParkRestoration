DEST=paulshannnon@pshannon.net:public_html/pshannon.net/sewardParkRestoration/fairyTree/
SITE=fairyTree

default: html

jpg:
	scp 2020-07-19-beforeMulching/*.jpg $(DEST)
	scp 2020-07-23-afterMulching/*.jpg $(DEST)
	scp *.jpg $(DEST)

html:
	scp *.html $(DEST)

all: jpg html

view:
	open http://pshannon.net/sewardParkRestoration/$(SITE)



DEST = paulshannnon@pshannon.net:public_html/pshannon.net/forestResearch/

default:
	@echo html
	@echo publish
	@echo openLocal
	@echo openRemote

html:
	scp *.html paulshannnon@pshannon.net:public_html/pshannon.net/forestResearch/

publish:
	scp *.html $(DEST)
	scp *.png  $(DEST)
	scp *.jpg  $(DEST)
	scp *.jpeg $(DEST)

openLocal:
	open index.html

openRemote:
	open https://pshannon.net/forestResearch



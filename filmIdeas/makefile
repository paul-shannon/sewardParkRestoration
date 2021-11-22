default:
	@echo targets: mkdir publish

mkdir:
	ssh paulshannnon@pshannon.net mkdir public_html/pshannon.net/nextSteps

publish:
	scp *.jpg paulshannnon@pshannon.net:public_html/pshannon.net/nextSteps
	scp *.html paulshannnon@pshannon.net:public_html/pshannon.net/nextSteps
	scp *.pdf paulshannnon@pshannon.net:public_html/pshannon.net/nextSteps
	scp *.png paulshannnon@pshannon.net:public_html/pshannon.net/nextSteps

open:
	open https://pshannon.net/nextSteps/overview.html


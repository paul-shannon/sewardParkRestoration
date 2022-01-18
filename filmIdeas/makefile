default:
	@echo targets: mkdir publish view

mkdir:
	ssh paulshannnon@pshannon.net mkdir public_html/pshannon.net/nextSteps

publish:
	scp *.jpg paulshannnon@pshannon.net:public_html/pshannon.net/nextSteps
	scp *.html paulshannnon@pshannon.net:public_html/pshannon.net/nextSteps
	scp *.pdf paulshannnon@pshannon.net:public_html/pshannon.net/nextSteps
	scp *.png paulshannnon@pshannon.net:public_html/pshannon.net/nextSteps

html: overview
	scp bobEdmonds-source/*.html paulshannnon@pshannon.net:public_html/pshannon.net/nextSteps

overview:
	scp overview.html paulshannnon@pshannon.net:public_html/pshannon.net/nextSteps

view:
	open https://pshannon.net/nextSteps/overview.html

water:
	open https://pshannon.net/nextSteps/overview.html#waterDeficit


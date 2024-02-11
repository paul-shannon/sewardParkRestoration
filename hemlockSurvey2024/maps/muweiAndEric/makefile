PORT = 8088

default:
	@echo json
	@echo venv
	@echo server
	@echo viewLocal
	@echo publish
	@echo viewRemote

json:
	R -f prepTreePoints.R

venv:
	@echo source /Users/paul/github/slexil2/py3105slexil/bin/activate

server:
	python -m http.server $(PORT) &

viewLocal:
	open http://localhost:$(PORT)/mapWithTabs.html

DEST = paulshannnon@pshannon.net:public_html/pshannon.net/hemlockSurvey2024

publish:
	scp mapWithTabs.html $(DEST)/index.html
	scp map.js $(DEST)/
	scp map.css $(DEST)/
	scp hemlocks.json $(DEST)/
	scp tblFinal.csv $(DEST)/

viewRemote:
	open https://pshannon.net/hemlockSurvey2024



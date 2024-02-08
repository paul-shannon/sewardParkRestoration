PORT = 8088

default:
	@echo toJSON
	@echo venv
	@echo server
	@echo viewLocal
	@echo publish
	@echo viewRemote

toJSON:
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

viewRemote:
	open https://pshannon.net/hemlockSurvey2024



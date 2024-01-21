PORT = 8080

default:
	@echo venv
	@echo server
	@echo view
	@echo publish

venv:
	@echo source /Users/paul/github/slexil2/py3105slexil/bin/activate

server:
	python -m http.server $(PORT) &

view:
	open http://localhost:$(PORT)/map.html

DEST = paulshannnon@pshannon.net:public_html/pshannon.net/hemlockSurvey2024

publish:
	scp mapWithTabs.html $(DEST)/index.html
	scp map.js $(DEST)/
	scp map.css $(DEST)/

openRemote:
	open https://pshannon.net/hemlockSurvey2024



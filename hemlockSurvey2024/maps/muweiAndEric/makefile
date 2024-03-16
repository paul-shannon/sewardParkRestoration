PORT = 8089

default:
	@echo json
	@echo venv
	@echo server
	@echo view
	@echo publish
	@echo viewRemote
	@echo wpPublish
	@echo wpViewRemote

json:
	R -f prepTreePoints.R

venv:
	@echo source /Users/paul/github/slexil2/py3105slexil/bin/activate

server:
	python -m http.server $(PORT) &

view:
	open http://localhost:$(PORT)/mapWithTabs.html

DEST = paulshannnon@pshannon.net:public_html/pshannon.net/hemlockSurvey2024

publish:
	scp mapWithTabs.html $(DEST)/index.html
	scp map-pluggable.js $(DEST)/
	scp map.css $(DEST)/
	scp hemlocks.json $(DEST)/
	scp gardenBoundaries.json $(DEST)/
	scp graveyardBoundaries.json $(DEST)/
	scp tblFinal.csv $(DEST)/
	scp hemlocks-merged.csv $(DEST)   

viewRemote:
	open https://pshannon.net/hemlockSurvey2024


DESTWP = paulshannnon@pshannon.net:public_html/pshannon.net/hemlockSurvey2024-wp

wpPublish:
	scp mapWithTabs-woodpeckers.html $(DESTWP)/index.html
	scp map-woodpeckerDamage.js $(DESTWP)/
	scp map.css $(DESTWP)/
	scp hemlocks.json $(DESTWP)/
	scp tblFinal.csv $(DESTWP)/

wpViewRemote:
	open https://pshannon.net/hemlockSurvey2024-wp



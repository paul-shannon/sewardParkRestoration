NAME=hemlockStudy

default:
	@echo knit
	@echo publish
	@echo viewRemote

knit:
	R -e "rmarkdown::render('$(NAME).Rmd')"
	open $(NAME).html

publish:
	scp hemlockStudy.html  paulshannnon@pshannon.net:public_html/pshannon.net/hemlockSurvey2024/
	scp style.css  paulshannnon@pshannon.net:public_html/pshannon.net/hemlockSurvey2024/
	scp *.png paulshannnon@pshannon.net:public_html/pshannon.net/hemlockSurvey2024/
	scp *.Rmd paulshannnon@pshannon.net:public_html/pshannon.net/hemlockSurvey2024/

viewRemote:
	open https://pshannon.net/hemlockSurvey2024/hemlockStudy.html


.PHONY: clean help start stop restart
.DEFAULT_GOAL := help
SERVER_LOC = ''

define BROWSER_PYSCRIPT
import os, webbrowser, sys

try:
	from urllib import pathname2url
except:
	from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

BROWSER := python -c "$$BROWSER_PYSCRIPT"

help:
	@python3 -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

clean: ## remove all docker containers and the container build during compose 
	docker rmi python_flask_nginx_web

start:
	docker-compose up -d 

stop: ## stop docker containers
	docker-compose down

restart: stop clean start ## stop container, remove oldbuild and restart
	@echo "Restarted"

start-server:
	cd app
	python main.py
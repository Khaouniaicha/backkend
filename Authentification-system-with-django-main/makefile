# Makefile for Django project

# Variables
PROJECT_NAME := your_project_name
VENV_NAME := venv10
PYTHON := $(VENV_NAME)\Scripts\python
DJANGO_CMD := $(PYTHON) manage.py

# Targets
.PHONY: all clean migrate run superuser

all: run

clean:
	@rm -rf $(VENV_NAME)

venv:
	@python3 -m venv $(VENV_NAME)

install: venv
	@$(PYTHON) -m pip install -r requirements.txt

migrate:
	@$(DJANGO_CMD) migrate

run:
	@$(DJANGO_CMD) runserver

superuser:
	@$(DJANGO_CMD) createsuperuser

# Example: make shell
shell:
	@$(DJANGO_CMD) shell

# Example: make test
test:
	@$(DJANGO_CMD) test

# Example: make lint
lint:
	@flake8 .

# Example: make collectstatic
collectstatic:
	@$(DJANGO_CMD) collectstatic --noinput

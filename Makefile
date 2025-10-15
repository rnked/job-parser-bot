UV ?= uv
PYVER ?= 3.12

.PHONY: help init sync hooks fmt lint type test cov pc dev-all check clean clean-all

help:
	@echo "init      - install Python $(PYVER) + .venv"
	@echo "sync      - install deps (incl. dev)"
	@echo "hooks     - pre-commit install"
	@echo "fmt       - ruff format + autofix"
	@echo "lint      - ruff check"
	@echo "type      - mypy"
	@echo "test      - pytest"
	@echo "cov       - pytest + coverage (term)"
	@echo "pc        - pre-commit run --all-files"
	@echo "dev-all   - sync+hooks+fmt+lint+type+test+pc"
	@echo "check     - fmt->lint->type->test"
	@echo "clean     - caches"
	@echo "clean-all - + build, venv"

init:
	$(UV) python install $(PYVER)
	$(UV) venv --python $(PYVER)

sync:
	$(UV) sync --dev

hooks:
	$(UV) run pre-commit install

fmt:
	$(UV) run ruff format .
	$(UV) run ruff check . --fix

lint:
	$(UV) run ruff check .

type:
	$(UV) run mypy src tests

test:
	$(UV) run pytest

cov:
	$(UV) run pytest --cov=src --cov-report=term-missing

pc:
	$(UV) run pre-commit run --all-files

dev-all: sync hooks fmt lint type test pc

check: fmt lint type test

clean:
	@find . -name '__pycache__' -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name '.pytest_cache' -type d -exec rm -rf {} + 2>/dev/null || true
	@rm -rf .ruff_cache .mypy_cache .coverage htmlcov 2>/dev/null || true

clean-all: clean
	@rm -rf build dist *.egg-info .venv 2>/dev/null || true

.PHONY: install dev backend frontend build test test-prolog test-backend test-frontend validar
install:
	uv sync --project backend --locked
	cd frontend && npm ci

dev:
	$(MAKE) -j2 backend frontend
backend:
	cd backend && uv run uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
frontend:
	cd frontend && npm run dev
build:
	cd frontend && npm run build

test: test-prolog test-backend test-frontend
test-prolog:
	swipl -q -g run_tests -t halt backend/prolog/test_garden.pl
test-backend:
	cd backend && uv run pytest -q
test-frontend:
	cd frontend && npm test && npm run format:check
validar:
	uv run scripts/validar_entrega.py

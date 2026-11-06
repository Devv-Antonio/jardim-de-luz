"""Contrato HTTP real, incluindo a ponte Janus (sem mocks do Prolog)."""
import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)
ZERO = [0] * 6
ENERGIES = [list(range(1, 7))] + [[1] * 6 for _ in range(5)]
SOLUTION = [2, 4, 6, 1, 3, 5]

def puzzle(**changes):
    return dict(energies=ENERGIES, target=7, givens=ZERO, board=ZERO) | changes

def test_solve():
    response = client.post('/api/solve', json=puzzle())
    assert response.status_code == 200
    assert response.json() == {'board': SOLUTION}

@pytest.mark.parametrize('difficulty,count', [('easy', 2), ('medium', 1), ('hard', 0)])
def test_generate_unique(difficulty, count):
    response = client.post('/api/generate', json={'difficulty': difficulty})
    assert response.status_code == 200
    generated = response.json()
    assert sum(c != 0 for c in generated['givens']) == count
    solved = client.post('/api/solve', json=generated | {'board': generated['givens']})
    assert solved.status_code == 200
    assert len(solved.json()['board']) == 6

def test_forced_hint():
    response = client.post('/api/hint', json=puzzle())
    assert response.status_code == 200
    assert response.json() == {'row': 0, 'column': 2, 'forced': True}

def test_possible_hint():
    response = client.post('/api/hint', json=puzzle(energies=[[1]*6 for _ in range(6)], target=6))
    assert response.status_code == 200
    assert response.json()['forced'] is False

@pytest.mark.parametrize('route', ['solve', 'hint'])
@pytest.mark.parametrize('changes', [
    {'board': [2, 2, 0, 0, 0, 0]}, {'board': [2, 0, 4, 0, 0, 0]},
    {'givens': [3, 0, 0, 0, 0, 0]}, {'target': 54},
    {'board': [1, 2, 3, 4, 5, 6]},
])
def test_impossible(route, changes):
    response = client.post('/api/' + route, json=puzzle(**changes))
    assert response.status_code == 422
    assert 'Não há solução' in response.json()['detail']

def test_complete_hint():
    response = client.post('/api/hint', json=puzzle(board=SOLUTION))
    assert response.status_code == 422
    assert response.json()['detail'] == 'O jardim já está completo.'

@pytest.mark.parametrize('changes', [
    {'board': [0]}, {'board': [7]*6}, {'board': [-1]*6},
    {'board': [True]*6}, {'board': ['2']*6}, {'energies': [[1]]},
    {'energies': [[0]*6]*6}, {'target': 55}, {'target': True},
    {'givens': []}, {'unexpected': 'field'},
])
def test_malformed(changes):
    assert client.post('/api/solve', json=puzzle(**changes)).status_code == 422

def test_invalid_difficulty():
    assert client.post('/api/generate', json={'difficulty': 'impossible'}).status_code == 422

def test_missing_fields():
    assert client.post('/api/solve', json={}).status_code == 422

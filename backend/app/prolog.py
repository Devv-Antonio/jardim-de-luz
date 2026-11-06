"""Ponte JSON local; as regras e a busca ficam em Prolog."""
import json
import subprocess
from pathlib import Path

BRIDGE = Path(__file__).resolve().parent.parent / "prolog" / "bridge.pl"

class NoSolution(Exception):
    pass

class BoardComplete(Exception):
    pass

def query(action: str, payload: dict) -> dict:
    result = subprocess.run(
        ["swipl", "-q", "-s", str(BRIDGE), "-g", "bridge:main", "-t", "halt"],
        input=json.dumps(payload | {"action": action}),
        capture_output=True, encoding="utf-8", timeout=10, check=True,
    )
    response = json.loads(result.stdout)
    match response.get("status"):
        case "unsolvable":
            raise NoSolution
        case "complete":
            raise BoardComplete
    return response

def generate(difficulty: str) -> dict:
    return query("generate", {"difficulty": difficulty})

def solve(puzzle: dict) -> list[int]:
    return query("solve", puzzle)["board"]

def hint(puzzle: dict) -> dict:
    return query("hint", puzzle)

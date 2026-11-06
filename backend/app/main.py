"""Validação HTTP; as decisões do jogo pertencem ao Prolog."""
from typing import Annotated, Literal
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, ConfigDict, Field
from app import prolog

app = FastAPI(title="Jardim de Luz", version="1.0.0")
Column = Annotated[int, Field(strict=True, ge=0, le=6)]
Board = Annotated[list[Column], Field(min_length=6, max_length=6)]
Energy = Annotated[int, Field(strict=True, ge=1, le=9)]
Row = Annotated[list[Energy], Field(min_length=6, max_length=6)]
Energies = Annotated[list[Row], Field(min_length=6, max_length=6)]

class Request(BaseModel):
    model_config = ConfigDict(extra="forbid")

class GenerateRequest(Request):
    difficulty: Literal["easy", "medium", "hard"] = "medium"

class Puzzle(Request):
    energies: Energies
    target: Annotated[int, Field(strict=True, ge=6, le=54)]
    givens: Board

class PlayRequest(Puzzle):
    board: Board

class Solution(BaseModel):
    board: Board

class Hint(BaseModel):
    row: Annotated[int, Field(ge=0, le=5)]
    column: Annotated[int, Field(ge=1, le=6)]
    forced: bool

@app.post("/api/generate", response_model=Puzzle)
def generate(request: GenerateRequest):
    return prolog.generate(request.difficulty)

@app.post("/api/solve", response_model=Solution)
def solve(request: PlayRequest):
    try:
        return {"board": prolog.solve(request.model_dump())}
    except prolog.NoSolution:
        raise HTTPException(422, "Não há solução com estas lanternas. Remova uma jogada ou reinicie.") from None

@app.post("/api/hint", response_model=Hint)
def hint(request: PlayRequest):
    try:
        return prolog.hint(request.model_dump())
    except prolog.NoSolution:
        raise HTTPException(422, "Não há solução com estas lanternas. Remova uma jogada ou reinicie.") from None
    except prolog.BoardComplete:
        raise HTTPException(422, "O jardim já está completo.") from None

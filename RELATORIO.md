# Jardim de Luz

## 1. Identificação

| Nome completo | Matrícula | Turma (14h/16h) | Usuário GitHub |
|---|---|---|---|
| Miguel Arthur Oliveira de Lima | 211062320 | 14h | @zlimaz |
| Mariana Siqueira Neris | 211062796 | 14h | @Maryyscreuza |
| Antônio Lucas De Araujo Lima | 241025597 | 14h | @Devv-Antonio |
| Fábio Santos Araújo | 222022082 | 14h | @fabiofonteles1 |
| João Pedro Silva Sousa | 222006258 | 14h | @JoaoPedrooSS |
| Daniel Ferreira Santos Rabelo | 222006632 | 14h | @DanielFsR |

- **Nome do projeto:** Jardim de Luz
- **Nome do grupo:** Grupo 02
- **Repositório:** https://github.com/Devv-Antonio/jardim-de-luz
- **Commit ou tag entregue:** v0.2.0
- **Ponto de partida:** remix original
- **Slides da apresentação oral:** não há

Os dados dos seis integrantes foram atualizados com a lista confirmada pelo responsável. Todos são da turma das 14h. A tag identifica a versão consolidada deste repositório. Antes da submissão, o grupo deve confirmar a execução das responsabilidades, revisar o relatório e indicar a versão correspondente no repositório do Classroom.

## 2. Resumo

Jardim de Luz é um quebra-cabeça 6×6 para quem gosta de desafios de posicionamento e aritmética.
O jogador coloca seis lanternas: uma por linha e coluna, sem diagonais compartilhadas e com soma exata das energias das casas ocupadas.
O Prolog resolve as restrições, gera jogos com solução única e verifica se uma dica é forçada por todas as soluções compatíveis.
O Elm controla o tabuleiro, o histórico, as mensagens e a interface; Python valida e transporta JSON.

![Interface em desktop](docs/captura.jpg)

![Interface em tela estreita](docs/captura-mobile.jpg)

## 3. Como executar

**Requisitos e versões verificadas:** SWI-Prolog 9.2.9 no PATH; Node.js 24.22.1; npm 11.19.1; uv 0.13.6; Python 3.12.16; Elm 0.19.2 instalado pelo npm. O backend declara Python 3.11+; recomendamos Node 24. Os arquivos de lock preservam as dependências resolvidas. A primeira instalação precisa de internet, inclusive para os pacotes Elm.

**Instalação, a partir da raiz:**

```sh
uv sync --project backend --locked
cd frontend
npm ci
```

**Terminal 1, a partir da raiz:**

```sh
cd backend
uv run uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

**Terminal 2, a partir da raiz:**

```sh
cd frontend
npm run dev
```

Abrir http://localhost:5173; documentação da API em http://localhost:8000/docs. Não é necessário Janus, Make ou compilador C. O `swipl` é um processo local, chamado com argumentos fixos e dados em JSON pela entrada padrão. O Vite faz proxy de `/api`. Quando modificar Elm, rodar `npm run compile` e recarregar a página.

**Testes e build, a partir da raiz:**

```sh
swipl -q -g run_tests -t halt backend/prolog/test_garden.pl
cd backend
uv run pytest -q
cd ../frontend
npm test
npm run format:check
npm run build
npm audit
cd ..
uv run scripts/validar_entrega.py
```

Com GNU Make: `make install`, `make dev`, `make test`, `make build`, `make validar`.

**Testado em:** Windows, com ferramentas isoladas na pasta de trabalho, e navegador integrado baseado em Chromium. A compilação Elm precisou de acesso ao armazenamento de certificados do Windows fora do isolamento do agente; não foi desabilitada a validação TLS. A reprodução numa máquina limpa independente ainda precisa ser confirmada pelo grupo. O workflow em `.github/workflows/ci.yml` executa os testes e o build em Ubuntu; consultar a execução real no GitHub antes de considerá-la evidência.

## 4. Arquitetura

```text
Jogador -> Elm -> HTTP/JSON -> FastAPI -> stdin/JSON -> SWI-Prolog
           ^                  |                      |
           +----- JSON -------+------- stdout/JSON --+
```

| Parte | Responsabilidade | Arquivos principais |
|---|---|---|
| Prolog | Restrições, busca, unicidade, geração e dica | `backend/prolog/garden.pl:10`, `backend/prolog/bridge.pl:6` |
| Elm domínio | Tabuleiro imutável, proteção de pistas, energia e conflitos locais | `frontend/src/Garden.elm:11` |
| Elm efeitos | Encoders, decoders e descrições de pedidos HTTP | `frontend/src/Api.elm:61` |
| Elm aplicação | Fases da aplicação, mensagens, histórico e HTML | `frontend/src/Main.elm:13` |
| Python | Validar HTTP e iniciar o processo Prolog | `backend/app/main.py`, `backend/app/prolog.py` |

A checagem imediata de ataques e a soma em Elm dão feedback a cada clique; não buscam soluções. O servidor confirma a compatibilidade e nunca depende dessas checagens do cliente. O Python não contém as regras do jardim.

## 5. Parte em Prolog

### 5.1 Predicados principais

| Predicado | Local | O que faz |
|---|---|---|
| `queens(?Columns)` /1 | `backend/prolog/garden.pl:10` | Modela uma lanterna por linha, colunas distintas e diagonais livres, sem enumerar |
| `solve(+Energies, +Target, +Givens, +Board, -Solution)` /5 | `backend/prolog/garden.pl:35` | Enumera soluções que respeitam as pistas, jogadas e energia |
| `solutions(+Energies, +Target, +Givens, +Board, -Solutions)` /5 | `backend/prolog/garden.pl:47` | Coleta todas as soluções compatíveis |
| `generate(+Difficulty, -Energies, -Target, -Givens)` /4 | `backend/prolog/garden.pl:70` | Cria matriz de energia, alvo com solução única e pistas aleatórias |
| `hint(+Energies, +Target, +Givens, +Board, -Result)` /5 | `backend/prolog/garden.pl:89` | Retorna jogada forçada/possível, completo ou impossível |

Na representação, a posição da lista é a linha; seu valor é a coluna, de 1 a 6. Na entrada, zero significa ausência de lanterna. Essa escolha elimina a possibilidade de duas lanternas numa linha já na representação.

### 5.2 Conceitos do paradigma lógico utilizados

- [x] Fatos e regras: `clue_count/2` define os níveis; `queens/1` combina as regras geométricas.
- [x] Unificação e padrões: `diagonals/1` decompõe a lista; `clue/2` mantém valores conhecidos e libera zeros.
- [x] Recursão: `separated/3` compara uma coluna com as seguintes, aumentando a distância entre linhas.
- [x] Backtracking e múltiplas soluções: `solve/5` não possui corte; `labeling/2` permite enumerar as alternativas.
- [x] `findall/3`: `solutions/5`, `unique_totals/2` e `hint/5` usam as respostas da relação para contar e explicar.
- [x] Corte: em `clue(0, _)`, impede interpretar zero como coluna. Em `generate/4`, entrega apenas um puzzle por chamada. Não há corte em `solve/5`.
- [x] CLP(FD): `ins`, `all_distinct/1`, `#\=`, `element/3` e `sum/3` declaram restrições antes da enumeração.
- [x] Ordem superior: `maplist/3` aplica pistas e liga colunas às energias; `include/3` seleciona alvos únicos.

Não usamos negação como falha para modelar ataques. A restrição `#\=` permite propagação mesmo com colunas ainda desconhecidas.

### 5.3 Trecho em destaque

Trecho de `backend/prolog/garden.pl:40`, dentro de `solve/5`, após validar as dimensões e intervalos:

```prolog
queens(Solution),
maplist(clue, Givens, Solution),
maplist(clue, Board, Solution),
maplist(element, Solution, Energies, Values),
sum(Values, #=, Target),
labeling([ff], Solution).
```

`Solution` contém seis variáveis finitas. Para cada linha, `element(Column, RowEnergies, Value)` relaciona a coluna escolhida à energia da casa. A soma é uma restrição sobre esses valores, não um teste feito só depois de montar todas as posições. O CLP(FD) propaga as relações e `labeling` atribui os valores restantes. O mesmo modelo serve para verificar uma solução completa, completar um tabuleiro ou enumerar suas alternativas; não há uma segunda implementação imperativa do resolvedor.

O gerador calcula o total de cada uma das quatro configurações geométricas, mantém apenas totais que aparecem uma vez e escolhe um deles. Se a matriz aleatória não separar nenhuma solução, usa uma matriz determinística que distingue as quatro pelo valor da primeira linha. Assim não existe repetição aleatória sem limite e a unicidade vale mesmo sem pistas.

## 6. Parte em Elm

### 6.1 Modelo e mensagens

Trechos de `frontend/src/Main.elm:13`, `frontend/src/Main.elm:31` e `frontend/src/Main.elm:41`:

```elm
type Model
    = Starting
    | StartFailed String
    | Ready Game
    | Waiting Operation Game

type Operation
    = Generating Difficulty
    | Hinting
    | Solving

type alias Game =
    { puzzle : Puzzle
    , board : Board
    , history : List Board
    , difficulty : Difficulty
    , assistance : Assistance
    , message : Maybe String
    }

type Msg
    = NewGame Difficulty
    | GotPuzzle (Result String Puzzle)
    | Toggle Int Int
    | Undo
    | Reset
    | AskHint
    | GotHint (Result String Api.Hint)
    | AskSolution
    | GotSolution (Result String (List Int))
```

Uma requisição inicial não tem tabuleiro; uma requisição durante a partida carrega o jogo preservado em `Waiting`. Isso evita combinações contraditórias de flags, como carregar sem dados antigos e ao mesmo tempo tentar exibi-los. `Operation` diferencia os pedidos; uma resposta de dica só é aplicada quando o estado é `Waiting Hinting`. Novas ações são ignoradas enquanto o pedido está em andamento, além de os botões serem desativados.

`Cell = Empty | Fixed Int | Player Int | Revealed Int`, em `frontend/src/Garden.elm:11`, representa ausência e origem da lanterna sem flags independentes. `Assistance = Independent | Assisted` distingue o resultado com auxílio. `Maybe String` representa ausência de aviso; `Array.get` usa `Maybe` para índices ausentes. As respostas HTTP usam `Result String a` e o decoder de puzzle encadeia o resultado de validação de `Garden.create`.

Os tipos não provam todo o domínio: a dimensão do Array e o intervalo do Int são invariantes verificadas nas fronteiras, não tipos dependentes. A proteção das pistas é feita pelas funções de alteração, testadas no domínio.

### 6.2 Conceitos do paradigma funcional utilizados

- [x] Arquitetura Elm: `main`, `update` e `view`, em `frontend/src/Main.elm:54` e `frontend/src/Main.elm:73`.
- [x] Custom types e casamento de padrões: fases, operação, assistência e células; os `case` sobre células são exaustivos.
- [x] `Maybe` e `Result`: acesso a Arrays e avisos; decodificação e sucesso/erro HTTP.
- [x] Ordem superior e aplicação parcial: `List.map`, `List.filterMap`, `Array.indexedMap` e `Maybe.andThen (Array.get (column - 1))`.
- [x] Composição: `columns = Array.toList >> List.map value`; pipelines em `conflicts` e `energy`.
- [x] JSON: `encode`, `puzzleDecoder`, `boardDecoder`, `hintDecoder` em `frontend/src/Api.elm:62`.
- [x] Efeitos controlados: `Api.post` retorna `Cmd msg`; o runtime executa HTTP. Não há eventos globais necessários, então subscriptions retorna `Sub.none`.
- [x] Imutabilidade: `remember`, `Array.set` e atualizações de records criam novos valores; o histórico guarda os anteriores.

### 6.3 Trecho em destaque

Trecho de `frontend/src/Main.elm:64`:

```elm
remember : Board -> Game -> Game
remember board game =
    if board == game.board then
        game

    else
        { game | board = board, history = game.board :: game.history, message = Nothing }
```

Uma ação que não muda o tabuleiro, como tentar alterar pista, não adiciona histórico. Quando há alteração, o valor anterior é guardado e o novo jogo é devolvido. Não há cópia profunda manual ou mutação compartilhada: o runtime trabalha com estruturas imutáveis. `Undo` casa a lista como `previous :: rest`, restaura o tabuleiro anterior e remove essa entrada do histórico. Reiniciar também pode ser desfeito; saber que houve auxílio permanece associado ao mesmo puzzle, mesmo após desfazer ou reiniciar.

## 7. Integração

| Rota / chamada | Entrada | Saída | Predicado Prolog |
|---|---|---|---|
| `POST /api/generate` | dificuldade easy/medium/hard | energias 6×6, alvo, pistas | `generate/4` |
| `POST /api/solve` | energias, alvo, pistas e jogadas | seis colunas | `solve/5`, primeira resposta via `once/1` na ponte |
| `POST /api/hint` | mesmos dados do solver | linha 0..5, coluna 1..6 e `forced` booleano | `hint/5` |

Python valida dimensões, intervalos, inteiros estritos e campos extras com Pydantic. Ele inicia `swipl` sem shell, envia JSON por stdin e interpreta JSON de stdout. `bridge.pl` converte o protocolo para chamadas do domínio. Um processo por pedido não compartilha estado mutável com outra partida. Tabuleiro impossível e dica em tabuleiro completo viram 422 com mensagem em português.

O processo tem timeout de 10 segundos. Falhas de infraestrutura, como `swipl` ausente, retornam erro do servidor; não equivalem a um puzzle matematicamente impossível. O cliente conserva o jogo em caso de erro e oferece nova tentativa. O serviço foi projetado para uso local; não há autenticação nem persistência no backend.

## 8. Testes e validação

Verificações locais em 06/11/2026:

| Camada | Resultado | Casos cobertos |
|---|---|---|
| Prolog | 17 testes plunit passaram | quatro soluções geométricas, soma exata, colunas, diagonal distante, pistas, multiplicidade, dicas, formato e fallback |
| Gerador | 60 gerações incluídas no teste plunit | 20 por nível; número de pistas e solução única com e sem pistas |
| API | 30 casos pytest passaram, sem mocks do Prolog | geração nos três níveis, solução, dicas, impossível, completo, tipos inválidos, dados ausentes, campos extras e dimensões |
| Elm | 17 verificações passaram | vitória, energia, conflitos, pistas, colocar/trocar/apagar, limites, revelação e decoders |
| Compilação | `elm make` e `npm run build` passaram | aplicação com otimização de produção; testes compilados separadamente |
| Formatação | `npm run format:check` passou | módulos de src e tests |
| Dependências | `npm audit`: zero vulnerabilidades | após remover plugins não usados e atualizar Vite; resultado é datado |
| Navegador | percurso real verificado | conflito, desfazer, dica forçada, solução com auxílio, reinício e preservação da pista |

A métrica original do professor contabilizou 149 linhas não vazias em Prolog, 598 em Elm e 129 em Python (14,7%), excluindo scripts do professor conforme a regra da ferramenta. Isso confirma que a camada Python permaneceu proporcionalmente pequena; contagem de linhas não substitui a avaliação do código.

As capturas `docs/captura.jpg`, `docs/captura-mobile.jpg` e `docs/resolvido.jpg` vieram da aplicação em execução, não de um mockup. A interface foi inspecionada no viewport estreito padrão e em 1280×1100. O roteiro manual distingue cenários já verificados dos que o grupo deve repetir.

**Validador da entrega:** identificação, nome Grupo 02 e divisão de responsabilidades estão preenchidos. A validação automática confere a forma do documento, não comprova a execução das responsabilidades nem substitui a revisão do grupo. A revisão de autoria real, a reflexão individual e a participação na apresentação continuam sob responsabilidade dos integrantes. Os scripts originais de validação foram preservados.

## 9. Limitações e problemas conhecidos

- Tabuleiro fixo 6×6. Há quatro padrões geométricos possíveis; valores e alvos variam, mas o jogo pode ficar previsível para quem memoriza as quatro configurações.
- Níveis significam quantidade de pistas, não técnicas medidas nem dificuldade calibrada com jogadores.
- Não há persistência, conta ou placar. Recarregar a página começa outro jogo.
- Cada pedido inicia um processo Prolog; a aplicação é local e não foi submetida a teste de carga nem preparada para exposição pública.
- O modelo `Puzzle` e os Arrays usam validação de fronteira; os tipos Elm não provam sozinhos dimensões e intervalos.
- Em desenvolvimento, alterações Elm exigem `npm run compile` e recarga. A remoção do plugin evita seu erro de caminho com espaços/acentos no Windows.
- Teste em máquina limpa por outra pessoa e ensaio oral de todos os integrantes ainda não foram realizados nesta sessão.
- Com mais tempo, o grupo pode calibrar os níveis e ampliar o tamanho, depois de revisar o custo de enumerar soluções. Nada disso faz parte da versão atual.

## 10. Contribuição de cada integrante

A divisão abaixo foi definida pelo responsável do Grupo 02 nesta revisão. Ela registra responsabilidades de desenvolvimento e revisão, não uma comprovação de que cada atribuição já foi executada. A implementação inicial foi produzida com Codex sob orientação de Antônio; o trabalho efetivamente realizado por cada integrante deve ser confirmado pelo grupo e refletido nos commits e nas avaliações individuais. Não foi fabricado histórico de autoria.

| Integrante | Principais contribuições |
|---|---|
| Miguel Arthur Oliveira de Lima | Responsável pela lógica Prolog: restrições, geração de jogos, unicidade e dicas. |
| Mariana Siqueira Neris | Responsável pela documentação: README, relatório, referências e organização do material de apresentação. |
| Antônio Lucas De Araujo Lima | Organização geral do projeto, definição do escopo, coordenação da equipe e administração do repositório e da entrega. |
| Fábio Santos Araújo | Responsável pelo backend: rotas FastAPI, validação dos pedidos e integração JSON com o Prolog. |
| João Pedro Silva Sousa | Responsável pelo frontend Elm: modelo, mensagens, interface e comunicação com a API. |
| Daniel Ferreira Santos Rabelo | Responsável por testes, validação, reprodução do ambiente e integração contínua. |

Cada integrante deverá entregar individualmente `avaliacao-360/<matricula>.md` no seu repositório privado do Classroom. O template foi preservado; nenhuma nota ou distribuição de esforço foi inventada nem publicada neste repositório do grupo.

## 11. Fontes, código de terceiros e uso de IA

**Código reaproveitado.** Partimos de `fabiommendes/paradigmas-trabalho-final`, commit `8454eea9bd08b9ef5e3b0538532d18a23174a93c`. Preservamos os arquivos originais de critérios de avaliação, os scripts do professor, o template da avaliação 360 e o esqueleto do projeto. O ambiente npm, o contrato FastAPI e a arquitetura Elm serviram de base, com adaptações. Os arquivos de Sudoku foram removidos. Os módulos do jardim, a ponte JSON, os testes e o estilo foram escritos nesta sessão com IA. Não atribuímos esse trabalho ao grupo antes de revisão. O inventário está em `docs/ORIGEM.md`.

**Referências.**

- Enunciado, template, rubrica e orientações: https://github.com/fabiommendes/paradigmas-trabalho-final/tree/8454eea9bd08b9ef5e3b0538532d18a23174a93c
- Manual CLP(FD) do SWI-Prolog, incluindo N-rainhas e `element/3`: https://www.swi-prolog.org/man/clpfd.html
- Biblioteca JSON do SWI-Prolog: https://www.swi-prolog.org/pldoc/man?section=json
- Arquitetura Elm: https://guide.elm-lang.org/architecture/
- Decodificação JSON: https://guide.elm-lang.org/effects/json
- FastAPI e modelos Pydantic: https://fastapi.tiangolo.com/tutorial/body/
- Vite: https://vite.dev/guide/

**Trabalhos da UnB consultados nesta revisão.**

- COUTINHO, Lucas Amoêdo de Victor; RIBEIRO, Vitor Nere Araújo. *Enpyre: uma plataforma web interativa e lúdica para o ensino de Python*. TCC, Engenharia de Software, UnB, 2023. [Registro institucional](https://bdm.unb.br/handle/10483/39155).
- BRANDÃO, Caio Albuquerque. *Sobre a confluência do cálculo λx na representação nominal*. TCC, Ciência da Computação, UnB, 2021. [Registro institucional](https://www.bdm.unb.br/handle/10483/31230?mode=full).

O primeiro trabalho apoia a contextualização de jogos no ensino; o segundo situa fundamentos da programação funcional. A aplicação desses temas ao Jardim de Luz é uma interpretação desta revisão documental. Não foram copiados código ou resultados; não reivindicamos eficácia pedagógica avaliada nem uma prova formal do jogo. O material efetivamente consultado e as limitações estão em `docs/REFERENCIAS-UNB.md`. Acesso às referências em 6 nov. 2026.

**Uso de ferramentas de IA.**

- **Faixa de uso no código:** intensivo

| Ferramenta | Para que foi usada | Como o grupo verificou o resultado |
|---|---|---|
| Codex, da OpenAI | Leitura do material, proposta da combinação de regras, implementação Prolog/Elm/Python, testes, correções, documentação e preparação do repositório | Nesta sessão, o agente executou plunit, pytest, verificações Elm, formatação, build e inspeção no navegador. A revisão humana e a compreensão de cada integrante permanecem pendentes; não as declaramos como concluídas. |

A rubrica desloca o ajuste de escopo em −0,5 com IA intensiva. Para a faixa proposta de remix original, isso leva Δ de +0,5 a 0, sujeito à confirmação do professor. Não há promessa de bônus ou nota; compreensão individual e apresentação continuam sendo avaliadas.

## 12. Apresentação oral

- **Slides:** não há
- **Roteiro:** proposta de 14 minutos, com 1 minuto de margem. A atribuição abaixo é um plano de fala, não evidência de autoria; precisa ser ensaiada e aceita pelo grupo. O material detalhado está em `docs/APRESENTACAO.md`.

| Parte | Duração | Quem apresenta |
|---|:---:|---|
| Contexto, objetivo e regras | 2 min | Miguel Arthur Oliveira de Lima |
| Demonstração: jogar, conflito e desfazer | 2 min | Mariana Siqueira Neris |
| Demonstração: dica e solução | 2 min | Antônio Lucas De Araujo Lima |
| Código Prolog: CLP(FD), energia e geração | 3 min | Fábio Santos Araújo |
| Código Elm: tipos, update, HTTP e histórico | 3 min | João Pedro Silva Sousa |
| Testes, limitações e aprendizados | 2 min | Daniel Ferreira Santos Rabelo |

Todos devem estudar ambos os paradigmas, pois o professor pode pedir a qualquer integrante que explique um trecho. Se a equipe mudar, atualizar as tabelas das seções 1, 10 e 12 e as avaliações individuais de forma coerente.

## 13. Reflexão sobre os paradigmas

Reflexão técnica preparada com IA para revisão do grupo, não relato de experiência pessoal dos integrantes. No Prolog, representar uma coluna por linha eliminou uma restrição inteira antes de escrever o solver. `all_distinct` e a distância entre colunas dizem o que uma solução deve respeitar; `element` conecta posicionamento e energia sem um laço que tenta casas manualmente. A mesma relação produz soluções, verifica unicidade e fundamenta uma dica. A contrapartida é pensar na propagação e no custo da enumeração: o limite 6×6 torna esse custo pequeno, mas não autoriza generalizar a estratégia sem medir.

No Elm, o ganho central está nas fronteiras e na representação das fases: `Waiting Operation Game` preserva os dados durante o efeito e `Result` obriga a decidir o que fazer quando ele falha. O histórico é uma lista de valores anteriores, sem a necessidade de desfazer mutações. A compilação confirmou que os módulos e suas assinaturas estão coerentes; não houve uma refatoração guiada por erro de tipos registrada nesta sessão, então não reivindicamos essa evidência. Ao adicionar uma nova origem de célula, o `case` exaustivo de `Garden.value` seria um ponto em que o compilador exigiria atualização; o ramo genérico em `update` não oferece essa mesma garantia para toda nova combinação de mensagem e estado.

A diferença prática é que o Prolog descreve o espaço de soluções possíveis, enquanto o Elm transforma um estado conhecido em outro e descreve os efeitos a executar. Python só transporta dados entre essas duas responsabilidades. O grupo ainda precisa acrescentar suas próprias observações, após estudar e modificar o projeto, para transformar esta análise técnica em reflexão de aprendizagem efetiva.

# Guia de estudo — entenda antes de apresentar

Este material é um mapa para leitura do código. Cada integrante deve explicar e experimentar os trechos; ler respostas decoradas não substitui compreender o programa. O professor pode escolher qualquer trecho de Prolog ou Elm.

## 1. Experimente o domínio sem servidor

```sh
swipl backend/prolog/garden.pl
```

No prompt do Prolog:

```prolog
?- generate(hard, Energies, Target, Givens).
?- generate(medium, E, T, G), solve(E, T, G, G, Solution).
?- generate(hard, E, T, G), solutions(E, T, G, G, All).
?- generate(easy, E, T, G), hint(E, T, G, G, Hint).
```

`queens/1` só instala restrições; para ver as soluções geométricas, importe CLP(FD) no prompt e faça a enumeração:

```prolog
?- use_module(library(clpfd)).
?- queens(Columns), labeling([], Columns).
```

Aperte `;` para pedir a próxima resposta. Há quatro soluções no tabuleiro 6×6. Isso explica por que conseguimos enumerar todas para verificar unicidade sem uma busca proibitiva. Não confunda um jogo com todas as energias iguais, que pode ter quatro soluções, com os puzzles produzidos pelo gerador, que sempre têm uma.

## 2. Leia garden.pl nesta ordem

1. `queens/1`: seis variáveis, domínio 1..6, `all_distinct`, diagonais.
2. `diagonals/1` e `separated/3`: decomposição recursiva e distância crescente.
3. `clue/2`: zero vira variável livre; o corte evita uma segunda interpretação.
4. `solve/5`: aplica pistas e jogadas separadamente, relaciona energia e coluna, impõe a soma e enumera.
5. `solutions/5`: `findall` devolve uma lista vazia quando nenhuma resposta existe.
6. `unique_totals/2`: computa os totais das configurações e mantém só os exclusivos.
7. `generate/4`: escolhe alvo e pistas; o fallback evita tentativas aleatórias ilimitadas.
8. `hint/5`: reúne as soluções, acha uma linha vazia e vê se todos concordam naquela coluna.

### Perguntas que você precisa conseguir responder

**Por que uma lista de colunas?** O índice representa a linha. Cada elemento permite uma única coluna, então duas lanternas na mesma linha não são representáveis nesse formato. Repetição de coluna continua possível na entrada e é rejeitada por restrição.

**Por que `#\=` em vez de `=\=`?** O primeiro é uma restrição CLP(FD), aplicável a variáveis ainda não instanciadas. O segundo avalia expressões aritméticas concretas; não substitui a propagação.

**O que `element/3` acrescenta?** Ele relaciona o índice escolhido à energia da casa. Assim a soma restringe também as escolhas de posição.

**O que `labeling([ff], Solution)` faz?** Enumera os valores que restaram nos domínios. `ff` escolhe primeiro a variável com menor domínio. Declarar restrições e enumerar são etapas diferentes.

**Por que `solve/5` não tem corte?** Precisamos de todas as alternativas para testar unicidade e justificar dicas. A ponte aplica `once` apenas quando o usuário quer uma solução.

**Por que o fallback é único?** As quatro configurações de seis rainhas começam em colunas diferentes (2, 3, 4 ou 5). As cinco últimas linhas têm energia 1 em qualquer coluna e a primeira contém 1..6. Logo os totais das quatro configurações são diferentes. Confira o teste em vez de confiar só na explicação.

**Uma dica forçada explica uma técnica humana?** Não. Ela prova concordância entre todas as soluções compatíveis. Não diz que a jogada decorre de uma técnica local simples.

**Como o servidor protege a pista se alguém alterar o JSON?** `solve/5` aplica `Givens` e `Board` independentemente à mesma solução. Uma pista contraditória torna a consulta impossível mesmo quando a jogada foi adulterada.

## 3. Leia Garden.elm sem olhar a tela

- `Cell` diferencia vazio, pista, jogador e revelação. `value` precisa tratar cada construtor.
- `Board` é um Array imutável com uma célula por linha.
- `create` valida as dimensões e intervalos que chegam pela rede.
- `change` protege `Fixed`, coloca uma lanterna ou a retira ao clicar de novo.
- `place` só aplica uma dica numa linha vazia.
- `lanterns` converte o Array numa lista de posições preenchidas usando `filterMap`.
- `conflicts` compara pares de posições por coluna e distância diagonal.
- `energy` acessa a energia por dois índices, ambos representados por `Maybe`.
- `complete` exige seis lanternas, nenhum conflito e soma exata.

**Por que repetir conflito e soma no Elm?** Para feedback imediato a cada clique. A busca, a geração, a unicidade e a validação final dos pedidos ficam no Prolog. O Python não decide nenhuma dessas regras.

**O que os tipos não garantem?** Um `Array Cell` não prova ter seis entradas; um `Int` não prova estar entre 1 e 6. O domínio depende de validação nas fronteiras e dos construtores utilizados pela aplicação. Reconhecer esse limite é melhor que dizer que todos os estados inválidos foram eliminados.

## 4. Siga uma mensagem em Main.elm

Exemplo: pedir dica.

1. `AskHint` chega em `Ready game`.
2. `update` retorna `Waiting Hinting game` e um `Cmd` descrito por `Api.hint`.
3. O runtime Elm executa o HTTP; `update` não executa rede diretamente.
4. O decoder produz `Ok Hint` ou `Err String`, que vira `GotHint`.
5. Só `Waiting Hinting` recebe essa resposta. Em sucesso, cria um novo tabuleiro, guarda o antigo e marca auxílio. Em erro, restaura `Ready` com o mesmo tabuleiro e um aviso.

Mude a operação mentalmente: o que aconteceria com `GotSolution` enquanto o estado é `Waiting Hinting`? O ramo genérico devolve o mesmo estado e `Cmd.none`. É uma proteção contra mensagens fora de contexto, mas esse ramo também pode esconder uma nova mensagem esquecida numa evolução do código; não reivindique exaustividade que ele não oferece.

**Por que `Waiting Operation Game` em vez de `loading : Bool`?** O tipo carrega os dados necessários para exibir o jogo antigo e diz qual resposta é esperada. `Starting` não inventa um tabuleiro vazio válido antes da primeira resposta.

**Como funciona desfazer?** `remember` guarda o tabuleiro anterior no início da lista. `Undo` retira o primeiro elemento. Os tabuleiros são imutáveis, então guardar uma referência ao valor anterior não permite que uma jogada posterior o altere.

**Desfazer apaga que houve auxílio?** Não. Auxílio pertence à partida atual e continua registrado mesmo que se desfaça a dica ou se reinicie o mesmo jardim. Um novo puzzle começa independente.

## 5. Confira as fronteiras em Api.elm e no Python

O decoder de puzzle produz um `Result` de validação e usa `andThen` para aceitar ou falhar. Solução exige seis colunas válidas. Dica exige linha 0..5, coluna 1..6 e booleano. Erros de rede e HTTP também são valores, não exceções soltas no Elm.

O Python aceita inteiros estritos: `true` e `"2"` não viram uma coluna automaticamente. Campos extras são recusados. Dados do usuário não são concatenados em uma consulta Prolog: passam como JSON, enquanto a linha de comando é fixa e não usa shell.

Leia `bridge.pl` para ver como strings JSON viram a seleção de operação e como o Prolog escreve as respostas. Uma falha de infraestrutura não deve ser confundida com uma solução inexistente.

## 6. Exercícios de compreensão

Faça-os num ramo próprio, sem alterar silenciosamente o que está sendo entregue:

- Explique com um exemplo por que duas lanternas distantes ainda podem compartilhar diagonal.
- Troque uma coluna no fixture e preveja quais testes de conflito e soma vão falhar.
- Crie um teste que prove que mudar somente a soma impede a vitória no Elm.
- Leia um pedido malformado da API e diga se ele será recusado pelo Python ou pelo Prolog.
- Simule uma falha de rede: qual parte do Model preserva o tabuleiro?
- Explique por que aumentar de 6×6 para 12×12 exige revisar a enumeração e não apenas trocar um número.

Todos devem saber localizar os testes que sustentam cada resposta. Registrem na seção 13 do relatório o que realmente aprenderam ou mudaram, com exemplos próprios.

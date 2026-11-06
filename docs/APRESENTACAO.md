# Grupo 02 — apresentação em 14 minutos

Um minuto fica de margem para transições. Slides são opcionais e não foram criados: o sistema e o editor são o material da demonstração. Os nomes são os informados pelo responsável; esta divisão precisa ser aceita e ensaiada pelo grupo.

| Tempo acumulado | Pessoa | Mostrar |
|---|---|---|
| 0:00–2:00 | Miguel Arthur Oliveira de Lima | Problema, regras e a regra de energia que compõe o remix |
| 2:00–4:00 | Mariana Siqueira Neris | Jogo funcionando, clicar, mover, conflito e desfazer |
| 4:00–6:00 | Antônio Lucas De Araujo Lima | Dica com explicação, solução, soma e reinício |
| 6:00–9:00 | Fábio Santos Araújo | `garden.pl`: coluna por linha, diagonais, `element`, soma, enumeração e unicidade |
| 9:00–12:00 | João Pedro Silva Sousa | `Main.elm`, `Garden.elm`, `Api.elm`: tipos, fases, Cmd/Result e histórico |
| 12:00–14:00 | Daniel Ferreira Santos Rabelo | Testes, limites, origem, IA intensiva e aprendizado real do grupo |

## Preparação antes de começar

1. Instalar tudo e executar testes e build com antecedência, com internet disponível para o primeiro download de pacotes Elm.
2. Abrir os dois servidores e carregar o jogo. Evitar instalar dependências durante a apresentação.
3. Deixar `garden.pl`, `Main.elm`, `Garden.elm` e `Api.elm` abertos nos trechos citados no relatório.
4. Deixar o resultado real de testes acessível. Capturas em `docs/` servem de apoio se houver imprevisto, sem serem apresentadas como sistema ao vivo.
5. Ensaiar a transição entre os seis participantes, usando cronômetro externo. Se necessário, encurtar explicações para manter o limite.

## Sequência de demonstração

- Começar num jardim novo em Florescer e mostrar a pista fixa.
- Colocar uma lanterna na mesma coluna da pista: aviso e borda tracejada aparecem.
- Desfazer: a jogada é retirada e a energia volta ao valor anterior.
- Pedir dica: os controles são desativados durante a busca, uma lanterna de auxílio aparece e a explicação informa que é forçada.
- Revelar a solução e mostrar seis lanternas, energia atual igual ao alvo e mensagem de resultado com auxílio.
- Reiniciar e mostrar que a pista original permanece. Não confundir reiniciar com gerar outro jardim.

## Código para explicar

**Prolog:** o trecho de `solve/5` que combina `queens`, `clue`, `element`, `sum` e `labeling`. Mostrar que `solve/5` pode gerar mais de uma resposta, enquanto a ponte usa `once` apenas na operação de solução. Explicar como a unicidade do alvo sustenta o gerador.

**Elm:** os construtores `Starting`, `StartFailed`, `Ready` e `Waiting`. Seguir `AskHint` até `GotHint`, incluindo o `Result`. Mostrar `remember` e `Undo` como manipulação de valores imutáveis. Reconhecer que dimensão de Array e intervalo de Int ainda são validados em runtime.

## Limitações que precisam ser ditas

6×6 e quatro padrões geométricos; dificuldade por pistas; sem persistência; processo Prolog por pedido; recarga manual após compilar Elm; ausência de teste de carga. A declaração de IA intensiva e a origem do template permanecem no relatório.

Perguntas individuais podem ser sobre qualquer trecho. Atribuir um módulo a alguém na seção 10 exige que essa pessoa realmente o tenha estudado e revisado. Não preencha a tabela de contribuições a partir desta escala de apresentação.

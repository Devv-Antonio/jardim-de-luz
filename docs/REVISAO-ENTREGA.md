# Revisão da entrega — 18/11/2026

Comparação com a [rubrica oficial](https://github.com/fabiommendes/paradigmas-trabalho-final/blob/main/AVALIACAO.md), consultada em 18/11/2026. O conteúdo local de `AVALIACAO.md` é igual ao oficial após normalizar as quebras de linha. A revisão foi executada por Codex a pedido do responsável; não representa avaliação do professor nem revisão pessoal dos seis integrantes.

## Critérios e evidências

| Critério | Peso | Evidência atual | O que falta confirmar ou melhorar |
|---|---:|---|---|
| Funciona e é reprodutível | 15% | 17 testes plunit, 33 casos pytest e 17 verificações Elm passaram; build passou. Testes cobrem conflitos, pistas, dicas, impossibilidade, entradas inválidas e timeout. | Instalação em máquina limpa independente, percurso real no navegador após esta revisão e CI verde no commit final. |
| Paradigma lógico em Prolog | 20% | `backend/prolog/garden.pl:35`: CLP(FD), unificação, enumeração, energia e pistas. Geração única e dicas verificadas por plunit. | Cada integrante explicar as restrições, o uso de `labeling`, os cortes e a diferença entre gerar e resolver; confirmar a faixa de remix com o professor. |
| Paradigma funcional em Elm | 30% | `frontend/src/Main.elm:13`: fases por custom types; domínio, HTTP e view em módulos; decoders próprios e histórico imutável. | Para sustentar o nível máximo, falta evidência real de refatoração guiada pelo compilador e reflexão própria. A seção 13 reconhece essa ausência. |
| Qualidade do código | 10% | Build e testes passaram; 3 arquivos Prolog sem avisos. Python é 16,8% das linhas medidas pela ferramenta original, abaixo do alerta aproximado de 30%. Formatação aplicada. | Confirmar formatação e CI na revisão final; revisar legibilidade em grupo. Nenhuma métrica garante nota por si só. |
| Relatório | 10% | As 13 seções existem, com referências ao código, limitações, origem e IA intensiva; validador sem erros. | Transformar seção 13 em reflexão do grupo, confirmar contribuições reais na seção 10 e substituir URL/revisão pela entrega efetiva do Classroom. |
| Apresentação oral | 15% | Roteiro de 14 minutos e 1 minuto de margem; seis participantes previstos. | Ensaiar todos, demonstrar sistema ao vivo, mostrar Prolog e Elm e responder perguntas sobre qualquer trecho. Ainda não verificado. |

## Verificações desta revisão

| Verificação | Resultado |
|---|---|
| `swipl -q -g run_tests -t halt backend/prolog/test_garden.pl` | 17 testes passaram; inclui 60 gerações nos três níveis |
| `uv run pytest -q`, a partir de backend | 33 casos passaram usando o Python do ambiente já instalado |
| `npm test`, a partir de frontend | 17 verificações passaram |
| `npm run format:check`, após aplicar elm-format | Passou, nenhum arquivo fora do formato |
| `npm run build`, a partir de frontend | Elm otimizado e Vite compilaram |
| `scripts/validar_entrega.py` | Relatório sem erros; não verifica avaliações privadas ausentes |
| Carregamento dos arquivos Prolog | 3 arquivos, nenhum aviso |
| Métrica original de linhas | Prolog 149; Elm 599; Python 151; Python 16,8% |

A API encerra a espera pelo processo Prolog em 10 segundos e responde HTTP 504 com mensagem recuperável. O cliente aguarda 15 segundos. Três testes simulam o timeout, um por rota, e verificam que o próximo pedido resolve normalmente. O CI tem limite de 15 minutos. As verificações locais foram executadas com limites de 60 ou 120 segundos por comando.

A auditoria npm e o percurso no navegador documentados anteriormente são de 06/11, não foram repetidos nesta revisão. O ambiente possui dependências instaladas; isso não é prova de instalação limpa. Um timeout do cliente não cancela trabalho já iniciado no servidor; o limite do subprocesso continua sendo a proteção no backend.

## Pendências para finalizar

1. Cada integrante executar e estudar o projeto, revisar seu bloco e confirmar as contribuições reais da seção 10. Autor e coautor de commit não demonstram esforço individual.
2. Escrever reflexões próprias na seção 13 com exemplos que o grupo compreenda. Para buscar o nível máximo de Elm, registrar uma refatoração efetivamente orientada pelo compilador, se houver; não inventar uma experiência.
3. Instalar a partir dos locks em uma máquina limpa, executar os comandos da seção 3 e guardar os resultados. Repetir a demonstração de `docs/TESTE-MANUAL.md` após as correções.
4. Conferir o CI verde para o commit final no GitHub. Corrigir falhas antes de indicar a revisão entregue.
5. Aceitar a atividade de grupo do GitHub Classroom e publicar lá código e relatório. O repositório pessoal não substitui essa entrega. A URL do Classroom ainda não foi fornecida nesta revisão.
6. Atualizar a URL e o commit/tag no relatório para a revisão efetivamente submetida. Preservar tags anteriores; qualquer alteração posterior exige nova revisão identificável.
7. Ensaiar até 15 minutos, com todos falando, demonstração funcional e explicação de código Prolog e Elm. Slides são opcionais.
8. Cada um dos seis alunos preencher a própria avaliação 360: identificação, notas, comentários e distribuição de esforço que some 100%, conforme o template; validar e enviar ao repositório individual privado do Classroom. Não publicar avaliações no repositório de grupo.
9. Manter a origem de todo reaproveitamento e a declaração de IA intensiva. Esta revisão também usa IA e está registrada na seção 11.

## Regras que afetam a entrega

- Hoje, **18/11/2026, 23h59 de Brasília**: lote sem desconto. Até 23/11, fator 0,90; até 30/11, fator 0,75. Após 30/11 o projeto não é aceito.
- Avaliação 360 até **30/11/2026, 23h59**; ausência custa 0,5 ponto individual. Não conseguir explicar código atribuído a si pode custar até 1 ponto individual.
- Validador com erros custa 0,5 ponto em G. Uso de IA não declarado e plágio podem invalidar o trabalho.
- Remix original propõe ajuste +0,5, compensado por −0,5 de IA intensiva: ajuste esperado zero, sujeito à decisão do professor. Não há bônus garantido.
- A distribuição de commits não entra diretamente na nota do grupo: é confrontada com as contribuições e com a avaliação 360.

## Blocos de revisão em duplas

| Autor Git solicitado | Coautor | Escopo executado com Codex |
|---|---|---|
| Miguel Arthur | Fabio Fonteles | Tratamento de timeout HTTP e testes nas três rotas, com recuperação após falha |
| Joao Pedro | Daniel Ferreira | Margem de timeout no cliente Elm e limite de execução da integração contínua |
| Mariiana Siqueira Neris | Antônio Lucas De Araujo Lima | Matriz da rubrica, relatório, checklist, documentação de IA e atualização do grafo |

Os nomes/e-mails Git foram indicados pelo responsável; nomes acadêmicos e matrículas permanecem os confirmados no relatório. Não houve reescrita dos commits anteriores. A revisão humana dessas duplas permanece pendente até ser realizada pelos integrantes.

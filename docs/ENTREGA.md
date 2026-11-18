# Checklist de entrega

## Estado atual

O sistema foi desenvolvido, compilado e testado. O Grupo 02 está identificado e a divisão de responsabilidades foi registrada. A configuração técnica e a validação de forma não substituem a confirmação do trabalho realizado por cada integrante, a revisão humana, a apresentação e a entrega no Classroom.

Consulte a [matriz de critérios e evidências de 18/11/2026](REVISAO-ENTREGA.md). A revisão acrescenta resposta HTTP 504 para timeout do Prolog, margem no cliente e limite no CI. Commits em duplas preparados com Codex não substituem a revisão pessoal dos integrantes.

## O que vocês precisam completar

- [x] Atualizar nomes completos, matrículas e usuários GitHub dos seis integrantes com a lista confirmada pelo responsável.
- [x] Definir o nome Grupo 02, conforme informado pelo responsável. Todos os integrantes são da turma das 14h.
- [x] Registrar a divisão de responsabilidades de desenvolvimento e revisão na seção 10.
- [ ] Revisar o projeto, executar localmente e registrar contribuições verdadeiras na seção 10, coerentes com os commits.
- [x] Manter a declaração de IA **intensivo** e a origem do template. Não declarar pode anular o trabalho.
- [ ] Substituir a análise técnica da seção 13 por reflexões próprias do grupo, apoiadas no código, sem inventar experiências.
- [ ] Aceitar a atividade **de grupo** no GitHub Classroom e colocar lá código e relatório. A publicação do repositório pessoal não é submissão automática.
- [ ] Atualizar a URL e a revisão entregue no relatório para o repositório correto do Classroom.
- [ ] Executar instalação numa máquina limpa independente e guardar o resultado.
- [x] Configurar integração contínua com testes, formatação, build e validador de entrega.
- [x] Indicar `v0.2.3` para a revisão completa, incluindo os commits das três duplas. Por solicitação do responsável, manter somente a tag mais recente no repositório pessoal; os commits anteriores permanecem no histórico.
- [ ] Conferir a execução verde do CI no GitHub para a revisão final; configurar workflow não comprova sucesso.
- [ ] Enviar a revisão efetivamente entregue e sua tag ao repositório do Classroom.
- [ ] Ensaiar o roteiro de 14 minutos. Todos falam e devem conseguir explicar Prolog e Elm.
- [ ] Se optarem por slides, colocar o arquivo no repositório e ajustar as seções 1 e 12. Slides são opcionais; a demonstração é necessária.
- [ ] Cada pessoa: copiar `avaliacao-360/TEMPLATE.md` para `<sua-matricula>.md`, preencher honestamente, validar e enviar no **seu repositório individual** do Classroom.
- [ ] Manter as avaliações individuais no local privado indicado pelo professor, sem colocá-las no repositório do grupo.

## Prazos e rubrica

| Entrega | Data, horário de Brasília | Efeito |
|---|---|---|
| Lote 1 | 18/11/2026, 23h59 | Sem desconto |
| Lote 2 | 23/11/2026, 23h59 | G × 0,90 |
| Lote 3 | 30/11/2026, 23h59 | G × 0,75 |
| Avaliação 360 individual | 30/11/2026, 23h59 | Ausência tira 0,5 da nota final |

Depois de 30/11 não há aceitação do projeto. A apresentação ocorre no fim do semestre, em data definida pelo professor.

Pesos: funciona 15%; Prolog 20%; Elm 30%; qualidade 10%; relatório 10%; apresentação 15%. Nota final: `0,25 × G + 0,75 × I`. A avaliação 360 ajusta I pelo esforço reconhecido pelos colegas; não preenchemos esse dado.

Para o escopo proposto (remix original) e IA intensiva, o ajuste esperado é Δ = 0, confirmado pelo professor. Bônus positivo exige nível mínimo 3 em funcionamento e Prolog. Não há garantia de nota. Não conseguir explicar o código atribuído a si pode tirar até 1 ponto individual.

## Comandos finais

```sh
make test
make build
make validar
git status
git push origin main
git push origin v0.2.3
```

Sem Make, use os comandos equivalentes do README. A tag `v0.2.3` identifica esta revisão completa. As tags desatualizadas `v0.2.1` e `v0.2.2` são removidas por solicitação do responsável após publicar a mais recente; seus commits continuam no histórico. Confirme que a tag existe e aponta para o commit completo antes da submissão ao Classroom.

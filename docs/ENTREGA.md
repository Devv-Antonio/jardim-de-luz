# Checklist de entrega

## Estado atual

O sistema foi desenvolvido, compilado e testado. Esta versão **ainda não é a entrega acadêmica final**, porque o nome do grupo e as contribuições reais ainda dependem de confirmação. Os dados de identificação dos seis integrantes já foram preenchidos. O validador original deve continuar rejeitando campos pendentes.

## O que vocês precisam completar

- [x] Atualizar nomes completos, matrículas e usuários GitHub dos seis integrantes com a lista confirmada pelo responsável.
- [ ] Escolher um nome de grupo único nas turmas. Todos os integrantes informados são da turma das 14h.
- [ ] Revisar o projeto, executar localmente e registrar contribuições verdadeiras na seção 10, coerentes com os commits.
- [ ] Manter a declaração de IA **intensivo** e a origem do template. Não declarar pode anular o trabalho.
- [ ] Substituir a análise técnica da seção 13 por reflexões próprias do grupo, apoiadas no código, sem inventar experiências.
- [ ] Aceitar a atividade **de grupo** no GitHub Classroom e colocar lá código e relatório. A publicação do repositório pessoal não é submissão automática.
- [ ] Atualizar a URL e a revisão entregue no relatório para o repositório correto do Classroom.
- [ ] Executar instalação numa máquina limpa independente e guardar o resultado.
- [ ] Rodar testes, formatação, build e `uv run scripts/validar_entrega.py` sem erros.
- [ ] Criar uma tag final depois do commit de revisão, como `v1.0.0`, atualizar a revisão no relatório e enviar a tag ao Classroom.
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
git tag v1.0.0
git push origin main
git push origin v1.0.0
```

Sem Make, use os comandos equivalentes do README. Antes de criar a tag, o relatório deve apontar para o nome escolhido. Não recrie nem sobrescreva uma tag já publicada; use outra versão para cada revisão.

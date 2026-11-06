# Origem e adaptações

Base autorizada pelo enunciado: https://github.com/fabiommendes/paradigmas-trabalho-final

Revisão consultada: `8454eea9bd08b9ef5e3b0538532d18a23174a93c` (09/10/2026).

| Material | Tratamento |
|---|---|
| `AVALIACAO.md`, `scripts/` e `avaliacao-360/TEMPLATE.md` | Copiados do professor, sem alteração de critérios ou validador |
| `RELATORIO.md` | Mesma estrutura de 13 seções; conteúdo técnico, identificação do Grupo 02 e divisão de responsabilidades preenchidos |
| Backend FastAPI e projeto uv | Estrutura adaptada; domínio e contratos substituídos; Janus removido em favor de processo local com JSON |
| Frontend Elm/Vite e pacotes Elm | Estrutura de aplicação e bibliotecas-base reaproveitadas |
| `Garden.elm`, `Api.elm`, `Main.elm`, CSS, `garden.pl`, `bridge.pl` e testes | Implementados com uso intensivo de Codex nesta sessão |
| Makefile e configuração Vite | Adaptados às rotas, testes e compilação explícita; sem o plugin Elm que falhava em caminho Windows com acentos |
| Fontes Fraunces e Outfit | Pacotes Fontsource já usados pelo template; arquivos distribuídos pelo npm com suas próprias licenças |
| Mecânica | N-rainhas conhecido + regra de soma de energia e seleção de alvo com solução única; faixa proposta: remix original |

O template não trazia um arquivo de licença de código no commit consultado. Não foi adicionada uma licença que pretendesse relicenciar o material do professor. A autorização de uso como ponto de partida consta do README original. As dependências mantêm suas licenças próprias.

Não foi preservado o histórico Git do professor como se fosse contribuição do grupo. O repositório novo identifica a origem explicitamente e contém apenas os commits desta implementação. Não simulamos commits de colegas.

O uso de IA é intensivo e deve permanecer declarado. O grupo precisa revisar o código, compreender as decisões e completar as contribuições reais antes da entrega. Nomes e identificação foram informados pelo responsável; matrículas e usuários não foram inventados.

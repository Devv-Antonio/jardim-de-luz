# Teste manual e evidências

Data da verificação do agente: **06/11/2026**. Navegador integrado baseado em Chromium; aplicação com frontend de produção servido pelo preview do Vite e backend local real. Não foi usado mock do solver.

## Percurso observado

| Ação | Resultado observado |
|---|---|
| Abrir o jogo | Puzzle gerado; nível Florescer; uma pista fixa; energias visíveis |
| Colocar lanterna na mesma coluna da pista | Contador e energia atualizados; aviso de conflito exibido |
| Desfazer | Lanterna removida, energia e contador restaurados; botão ficou indisponível sem histórico |
| Pedir dica | Controles desativados enquanto o pedido estava em andamento; dica aplicada e explicação de jogada forçada visível |
| Revelar solução | Seis lanternas; energia 26 igual ao alvo 26 naquele puzzle; mensagem de solução com auxílio |
| Reiniciar | Apenas a pista original permaneceu; energia voltou a 7 naquele puzzle |
| Inspecionar tela estreita | Layout em coluna, sem sobreposição visual nos elementos inspecionados |
| Inspecionar 1280×1100 | Layout em duas colunas, tabuleiro e regras lado a lado |

As energias acima pertencem ao puzzle capturado. Outra geração normalmente produz outros valores; os testes não devem exigir esses valores em jogos aleatórios.

Capturas reais:

- `captura.jpg`: desktop com uma dica aplicada;
- `captura-mobile.jpg`: tela estreita no mesmo puzzle;
- `resolvido.jpg`: solução com auxílio e energia exata.

## Repetir pelo grupo antes da entrega

Estes itens são um roteiro de revisão; sua presença aqui **não afirma que foram executados na sessão do agente**.

1. Instalar num computador limpo com os requisitos do README e seguir todos os comandos sem ajuda adicional.
2. Gerar cada nível e contar 2, 1 e 0 pistas, respectivamente. Repetir solução e reinício.
3. Navegar com Tab e acionar casas e botões com Enter/Espaço; conferir foco visível.
4. Conferir a interface com um leitor de tela e verificar os rótulos das casas e os avisos de estado.
5. Colocar duas lanternas numa diagonal distante e conferir conflito; trocar de coluna na mesma linha e conferir que só uma fica acesa.
6. Pedir dica com uma jogada impossível: mensagem de erro, tabuleiro preservado; corrigir e pedir novamente.
7. Parar o backend antes de abrir a página: mensagem de falha inicial; religar e usar Tentar novamente.
8. Parar o backend no meio de uma partida: pedir dica; aguardar erro; conferir que o jogo foi preservado e os controles voltaram.
9. Reiniciar e desfazer o reinício; conferir que as pistas e o histórico fazem sentido.
10. Recarregar a página e confirmar o limite declarado: uma nova partida é iniciada, sem salvar a anterior.
11. Ensaiar os 14 minutos com os seis participantes e perguntas individuais sobre os dois paradigmas.

Os cenários matemáticos e de contrato HTTP também possuem testes automatizados; isso não substitui uma avaliação humana de acessibilidade nem a execução numa máquina limpa independente.

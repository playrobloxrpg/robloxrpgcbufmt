# A Toca da Tecelã Faminta — RPG no Roblox

Design: **Yuri Ramos Hernandez**

RPG de masmorra para Roblox, todo construído em blocos no estilo pixel/voxel: paleta escura, contorno pixel art nos personagens e brilhos neon. Tudo é gerado por scripts que você cola no **Command Bar** do Roblox Studio.

## O que tem no projeto

| Script | O que cria |
|---|---|
| `scripts/toca_da_tecela_faminta.lua` | A masmorra (nível 5 a 7) com 5 áreas: Escadas Íngremes, Túnel do Fedor, Labirinto de Teias, Covil e Saída Vigiada. Inclui as aranhas vivas (andam, mordem, levam dano e morrem) e a chefe, A Tecelã Faminta. |
| `scripts/classes_de_personagem.lua` | As 5 classes (Cavaleiro, Clérigo, Arcanista, Ladino, Patrulheiro) em pedestais, com animações de combate: Parado, Ataque, Habilidade e Dano. |
| `scripts/lobby_vila.lua` | O lobby, Vila Pedra-Musgo: praça com o portal para a Toca, Taverna do Caneco Torto (interior completo e Salão dos Heróis), Forja da Ilda, casas, rio e cais. Tem moedas, lojas, escolha de classe e armas que ferem as aranhas. |
| `scripts/a_tecela_faminta.lua` | Só a chefe, para ver ou usar em outro lugar. |
| `scripts/arcanista_do_veu.lua` | O primeiro mago do projeto, sozinho. |

## Como montar no Roblox Studio

1. Abra um lugar com a Baseplate padrão.
2. Abra o Command Bar: aba **View** > **Command Bar**.
3. Cole e rode (Enter) os scripts **nesta ordem**:
   1. `toca_da_tecela_faminta.lua`
   2. `classes_de_personagem.lua` (as estátuas vão para o Salão dos Heróis da taverna)
   3. `lobby_vila.lua`
4. Aperte **Play**. Você nasce na vila.

Rodar um script de novo apaga a versão anterior e cria outra.

## Como jogar

- **Moedas**: todo jogador começa com 50 (aparecem na lista de jogadores).
- **Classe**: na taverna, segure **F** num pedestal do Salão dos Heróis. Cada classe tem vida máxima e arma inicial próprias.
- **Lojas**: segure **E** perto do Bartolo (taverna: poções e tocha) ou da Ilda (forja: armas).
- **Armas**: clique para atacar. Cada aranha morta dá moedas (10 por cria, 150 pela Tecelã).
- **Teias**: as brancas cortam com um clique; as violeta só com a Tocha ou o Cajado.
- **Portal**: na praça, leva para o pé da escada da Toca. Lá tem um portal de volta.

## Prévias

A pasta `previews/` tem páginas HTML que mostram em 3D, no navegador, exatamente as mesmas peças dos scripts: a masmorra, a vila, as classes, as animações de combate, as aranhas e a chefe.

## Estrutura

```
scripts/      scripts prontos para o Command Bar
previews/     prévias 3D em HTML
fontes/       partes usadas para montar os scripts grandes (lobby e animações)
ferramentas/  Roblox simulado em Lua e testes em Python
```

## Testes (opcional)

Os testes rodam os scripts num Roblox simulado, fora do Studio, para achar erros antes do Play. Precisa de Python 3 com `lupa` e `luaparser`:

```bash
pip install lupa luaparser
cd ferramentas/testes
python3 test_aranhas.py ../../scripts/toca_da_tecela_faminta.lua
python3 test_motor.py ../../scripts/classes_de_personagem.lua
python3 test_lobby.py ../../scripts/toca_da_tecela_faminta.lua ../../scripts/classes_de_personagem.lua ../../scripts/lobby_vila.lua
```

## Próximos passos

- Salvar as moedas com DataStore.
- Visual da classe no próprio jogador.
- Ajustar a pegada das armas na mão, se alguma aparecer virada.

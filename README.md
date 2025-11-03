# 🎮 Sistema de Salas Privadas — SA-MP (Pawn)

Um sistema completo de **criação de salas privadas** para servidores **SA-MP**, permitindo que jogadores criem salas personalizadas com controle de arma, número de jogadores, senha, spawn e virtual world.

O sistema utiliza **dialogs interativos**, comandos simples e gerenciamento automático de jogadores dentro das salas.

---

## ⚙️ Funcionalidades

- Criação de salas privadas com configurações personalizadas.
- Definição de:
  - Número máximo de jogadores (2–50)
  - ID de arma permitido (0–46)
  - Senha da sala
  - Ponto de spawn
  - Virtual World
- Lista de salas disponíveis para entrar.
- Entrar em salas mediante senha.
- Resposta automática ao respawn dentro da sala.
- Comandos de gerenciamento:
  - `/criarsala` — Criar e configurar uma nova sala.
  - `/salas` — Listar salas ativas e entrar nelas.
  - `/sairsala` — Sair da sala atual.
  - `/deletarsala` — Deletar a sala criada (somente criador).
- Verificação de limite de salas e virtual world disponível.
- Reset de armas e posição ao sair da sala.

---

## 📌 Comandos

| Comando       | Descrição |
|---------------|-----------|
| `/criarsala`  | Abre o menu de criação/configuração de sala. |
| `/salas`      | Lista todas as salas disponíveis e permite entrar. |
| `/sairsala`   | Sai da sala atual e retorna ao spawn padrão. |
| `/deletarsala`| Deleta a sala criada pelo jogador (somente criador). |

---

## 📝 Configurações Padrão

- Posição padrão ao sair da sala:
  ```pawn
  SPAWN_PADRAO_X = 1750.0
  SPAWN_PADRAO_Y = -1890.0
  SPAWN_PADRAO_Z = 13.0
````

* Número máximo de salas: `100`
* Virtual World inicial: `1000` (incrementa automaticamente para novas salas)
* Suporte para armas válidas: IDs `0–46`, exceto `19`, `20` e `21`.

---

## 🛠 Estrutura

* **Sala** — Array principal que armazena informações da sala:

  * Criador
  * Número máximo de jogadores
  * ID da arma
  * Senha
  * Spawn (X, Y, Z, Angulo)
  * Virtual World
  * Quantidade de jogadores atuais

* **SalaConfig** — Estrutura temporária usada durante a criação/configuração da sala.

* **Funções úteis**:

  * `IsValidWeapon(weaponid)` — Verifica se a arma é válida.
  * `GetNextAvailableVirtualWorld()` — Gera um virtual world livre.
  * `ResetPlayerSala(playerid)` — Reseta jogador ao sair da sala.
  * `IsPlayerInAnySala(playerid)` — Verifica se o jogador está em alguma sala.
  * `CancelarConfiguracaoSala(playerid)` — Cancela a configuração atual.

* **Diálogos**:

  * Configuração de sala (`DIALOG_SALA_CONFIG`)
  * Edição de campos individuais (`DIALOG_SALA_EDIT`)
  * Lista de salas (`DIALOG_LISTA_SALAS`)
  * Entrada por senha (`DIALOG_ENTRAR_SENHA`)
  * Definir Virtual World (`DIALOG_VIRTUAL_WORLD`)

---

## 🔄 Respawn e Desconexão

* Jogadores que morrem dentro de uma sala reaparecem automaticamente no spawn da sala.
* Ao desconectar, o jogador é removido da sala e suas configurações temporárias são canceladas.

---

## 📦 Instalação

1. Adicione o arquivo do sistema ao seu **gamemode** ou **include** do SA-MP.
2. Compile o gamemode usando o **Pawn Compiler**.
3. Certifique-se de ter as include libraries necessárias: `a_samp`, `zcmd` e `sscanf2`.
4. Os comandos já estarão disponíveis para os jogadores.

---

## ⚡ Observações

* Apenas o criador da sala pode deletá-la usando `/deletarsala`.
* Caso o criador saia sem deletar a sala, outros jogadores ainda podem permanecer na sala.
* Limite de virtual worlds: `1000–50000`. Cada sala precisa de um virtual world exclusivo.
* Suporte completo para respawn automático na sala.

---

## 💡 Futuras melhorias

* Suporte a múltiplas armas por sala.
* Opção para desativar respawn automático.
* Sistema de timers para salas temporárias.
* Integração com gamemodes existentes (Deathmatch, Minigames, etc.).

---

Feito com ❤️ para servidores **SA-MP** que buscam **flexibilidade e controle total das salas privadas**.

```

Se você quiser, posso criar **uma versão resumida e visualmente mais “bonita”** com tabelas coloridas, exemplos de uso e fluxos de diálogos para jogadores, ideal para colocar direto no GitHub.  

Quer que eu faça isso?
```

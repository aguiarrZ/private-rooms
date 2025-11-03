# 🎮 Sistema de Salas Privadas — SA-MP (Pawn)

Sistema completo para **criação e gerenciamento de salas privadas** em servidores **SA-MP**, permitindo que jogadores criem salas personalizadas com:

- Controle de armas
- Número de jogadores
- Senha de acesso
- Spawn personalizado
- Virtual World exclusivo

O sistema utiliza **dialogs interativos**, **comandos simples** e **gerenciamento automático** de jogadores.

---

## ⚡ Funcionalidades Principais

| Funcionalidade | Descrição |
|----------------|-----------|
| Criação de salas | Jogadores podem criar salas privadas via `/criarsala`. |
| Configuração de sala | Defina número máximo de jogadores, arma, senha, spawn e virtual world. |
| Lista de salas | Visualize salas ativas e entre nelas com senha. |
| Respawn automático | Jogadores reaparecem no spawn da sala ao morrer. |
| Controle de criador | Apenas o criador pode deletar a sala com `/deletarsala`. |

---

## 📌 Comandos Disponíveis

| Comando       | Descrição |
|---------------|-----------|
| `/criarsala`  | Abre o menu de criação e configuração da sala. |
| `/salas`      | Lista todas as salas ativas e permite entrar. |
| `/sairsala`   | Sai da sala atual e retorna ao spawn padrão. |
| `/deletarsala`| Deleta a sala criada (somente criador). |

---

## 🛠 Configuração da Sala

| Campo              | Tipo / Valores               | Observação |
|-------------------|------------------------------|------------|
| Máx. jogadores     | 2–50                         | Número máximo de participantes. |
| ID da arma         | 0–46 (exceto 19, 20, 21)    | Arma fornecida ao entrar na sala. |
| Senha              | 1–31 caracteres              | Necessária para entrar na sala. |
| Spawn              | Coordenadas X, Y, Z + Ângulo | Ponto de spawn dentro da sala. |
| Virtual World      | 1000–50000                   | Cada sala deve ter um virtual world único. |

---


## 📝 Notas Importantes

* Apenas o criador pode deletar a sala (`/deletarsala`).
* Se o criador sair sem deletar, a sala continua ativa para outros jogadores.
* Respeitar limites de virtual world (`1000–50000`) para evitar conflitos.
* Jogadores que morrem reaparecem automaticamente na sala.
* Substitua a posição de spawn padrão para a posição de spawn do seu servidor.

---

Feito com ❤️ para servidores **SA-MP** que buscam **flexibilidade e controle total das salas privadas**.

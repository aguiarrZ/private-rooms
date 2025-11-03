<div align="center">

# Sistema de Salas Privadas  
### **SA-MP • Pawn • Isolamento Total**

<a href="https://github.com/seuusuario/salas-samp/releases">
  <img src="https://img.shields.io/github/v/release/seuusuario/salas-samp?color=1a1a1a&label=Vers%C3%A3o&style=for-the-badge&logo=github" alt="Release">
</a>
<a href="https://github.com/seuusuario/salas-samp">
  <img src="https://img.shields.io/github/stars/seuusuario/salas-samp?color=1a1a1a&label=Stars&style=for-the-badge&logo=github" alt="Stars">
</a>
<a href="https://github.com/seuusuario/salas-samp/fork">
  <img src="https://img.shields.io/github/forks/seuusuario/salas-samp?color=1a1a1a&label=Forks&style=for-the-badge&logo=github" alt="Forks">
</a>
<a href="https://github.com/seuusuario/salas-samp/issues">
  <img src="https://img.shields.io/github/issues/seuusuario/salas-samp?color=1a1a1a&label=Issues&style=for-the-badge&logo=github" alt="Issues">
</a>

<br>

![SA-MP](https://img.shields.io/badge/SA--MP-0.3.7-2d2d2d?style=flat-square&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNmZmYiIHN0cm9rZS13aWR0aD0iMiIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj48cGF0aCBkPSJNMTkgMTlINmEyIDIgMCAwIDAtMi0yVjhhMiAyIDAgMCAwIDItMmgxMWEyIDIgMCAwIDAgMiAydjExYTIgMiAwIDAgMCAyIDJ6Ii8+PC9zdmc+)
![Pawn](https://img.shields.io/badge/Pawn-1.10-2d2d2d?style=flat-square)
![ZCMD](https://img.shields.io/badge/ZCMD-0.3.1-2d2d2d?style=flat-square)
![SSCANF](https://img.shields.io/badge/SSCANF-2.8.3-2d2d2d?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-2d2d2d?style=flat-square)

> **Salas privadas com spawn, arma, senha e Virtual World exclusivo — tudo em tempo real.**

</div>

---

## Funcionalidades

```diff
+ Criação interativa com /criarsala
+ Configuração completa: jogadores, arma, senha, spawn, VW
+ Isolamento total por Virtual World
+ Sistema de senha opcional
+ Respawn automático na sala
+ Gerenciamento: /sairsala, /deletarsala (apenas criador)
+ Limite seguro: 100 salas, 50 jogadores por sala
```

---

## Comandos

| Comando | Descrição | Permissão |
|--------|----------|----------|
| `/criarsala` | Inicia menu de criação | Todos |
| `/salas` | Lista salas ativas | Todos |
| `/sairsala` | Sai da sala atual | Jogadores |
| `/deletarsala` | Deleta sua sala | Criador |

---

## Requisitos

| Plugin | Link |
|-------|------|
| `a_samp` | [SA-MP Stdlib](https://github.com/samp-incognito/samp-stdlib) |
| `ZCMD` | [Y-Less/YSI](https://github.com/Y-Less/YSI-Includes) |
| `sscanf2` | [Y-Less/sscanf](https://github.com/Y-Less/sscanf) |

> Coloque em `pawno/include/`

---

## Instalação

```bash
1. Baixe salas.pwn
2. Coloque em filterscripts/
3. Adicione em server.cfg:
   filterscripts salas
4. Reinicie ou use:
   /rcon loadfs salas
```

---

## Menu de Configuração

```text
┌─────────────────────────────────────────────┐
│ Quantidade de Jogadores:    10              │
│ ID da Arma:                 24 [Deagle]     │
│ Senha da Sala:              ****            │
│ Spawn:                      248.5, -150.2   │
│ Virtual World:              1500            │
└─────────────────────────────────────────────┘
        [Selecionar]     [Cancelar]
```

---

## Estrutura Técnica

```pawn
#define MAX_SALAS        100
#define SPAWN_PADRAO_X   1750.0
#define SPAWN_PADRAO_Y   -1890.0
#define SPAWN_PADRAO_Z   13.0
```

- **Virtual Worlds**: `1000+` (incremental)
- **Armas válidas**: `0–46` (exclui 19–21)
- **Spawn padrão**: Los Santos (perto do início)

---

## Fluxo de Criação

```mermaid
graph TD
    A[/criarsala] --> B{Configurando?}
    B -- Não --> C[Inicia configuração]
    B -- Sim --> D[Abre menu atual]
    C --> E[Menu Principal]
    E --> F[Definir Jogadores]
    E --> G[Definir Arma]
    E --> H[Definir Senha]
    E --> I[Definir Spawn]
    E --> J[Definir VW]
    J --> K[Criar Sala]
    K --> L[Sala criada!]
```

---

## Segurança

```diff
+ Virtual World único por sala
+ Validação de armas, jogadores, senha
+ Apenas criador pode deletar
+ Ao desconectar: remove da contagem
+ Anti-exploit: 1 sala por criador
```

---

## Personalize

```pawn
// Spawn ao sair da sala
#define SPAWN_PADRAO_X   1750.0
#define SPAWN_PADRAO_Y   -1890.0
#define SPAWN_PADRAO_Z   13.0
```

> Quer interior? Edite `SetPlayerInterior` nas funções.

---

<div align="center">

## Contribua

<a href="https://github.com/seuusuario/salas-samp/issues">
  <img src="https://img.shields.io/github/issues/seuusuario/salas-samp?color=ff5555&style=for-the-badge" alt="Issues">
</a>
<a href="https://github.com/seuusuario/salas-samp/pulls">
  <img src="https://img.shields.io/github/issues-pr/seuusuario/salas-samp?color=55ff55&style=for-the-badge" alt="Pull Requests">
</a>

</div>

---

<div align="center">

## Licença

```text
MIT License © 2025
Livre para uso, modificação e distribuição.
```

</div>

---

<div align="center" style="margin-top: 40px; padding: 20px; background: #111; border-radius: 12px; border: 1px solid #333;">

### Feito com dedicação para a comunidade **SA-MP Brasil**

> **Leve • Moderno • 100% Funcional**

</div>
```

---

### Como usar (passo a passo):

1. **Substitua** `seuusuario` pelo seu nome de usuário do GitHub em **todos os badges**
2. **Faça upload** do `.pwn` no repositório
3. **Crie uma release** (ex: `v1.0`) → badge de versão atualiza automaticamente
4. **(Opcional)** Adicione imagens em `/screenshots/` e referencie com:

```markdown
![Menu](screenshots/menu.png)
```

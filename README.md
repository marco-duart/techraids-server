# Techraids Server ⚔️

![Rails](https://img.shields.io/badge/Rails-8-red)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-blue)
![API](https://img.shields.io/badge/Mode-API%20Only-1f6feb)
![Swagger](https://img.shields.io/badge/Docs-Swagger-85ea2d)

> 🎮 API de gamificacao com narrativa RPG para equipes: progressao, quests, bosses e recompensas.

API Rails para gamificacao em formato RPG, com dois perfis principais:

- character: colaborador que evolui, cumpre tarefas/missoes e compra recompensas.
- narrator: lider/gestor que coordena guilda, valida progresso e entrega recompensas.

## 🌍 Visao Geral

O sistema organiza pessoas em uma estrutura de mundo RPG:

- Village: departamento/area macro.
- Guild: equipe vinculada a uma village e gerenciada por um narrator.
- Quest > Chapter > Boss: trilha de progressao da guilda.
- Task e Mission: atividades com recompensas diferentes.
- TreasureChest e Reward: loja de premios.
- HonoraryTitle: titulos concedidos aos characters.

## 🧱 Stack Tecnica

- Ruby on Rails 8
- PostgreSQL
- Devise + devise_token_auth (autenticacao token-based)
- Pundit (autorizacao por policy/scope)
- Pagy (paginacao)
- Active Storage (uploads de imagem/foto)
- rswag-api + rswag-ui (OpenAPI/Swagger)
- Solid Queue / Solid Cache / Solid Cable

## 🏗️ Arquitetura da Aplicacao

- Controllers: camada HTTP, autenticacao, autorizacao e serializacao de resposta.
- Policies (Pundit): regras de acesso por role e escopo de dados.
- Services: regras de negocio multi-etapa e fluxos transacionais.
- Models: relacoes, validacoes, enums, scopes e callbacks.
- Migrations: schema e integridade relacional (FKs e indice unico de chapter por quest).

## 🧭 Dominio e Entidades

### 👥 Usuarios e papeis

- User possui role enum: character ou narrator.
- User pode pertencer a village, guild, specialization, character_class, current_chapter e active_title.
- Narrator pode gerenciar uma guild (managed_guild).

### 🗺️ Estrutura de progresso

- Quest pertence a guild.
- Chapter pertence a quest e tem ordenacao por position.
- Boss pertence a chapter e pode ser finalizado por um character.

### 🪙 Trabalho e recompensas

- Task: foco em experiencia (XP).
- Mission: foco em ouro.
- TreasureChest: bau com valor em ouro, associado a rewards.
- Reward: pode ser limitado por estoque.
- CharacterTreasureChest: historico de compras/sorteios por character.

### 📣 Comunicacao

- GuildNotice: avisos internos por guild.
- ArcaneAnnouncement: comunicados por village.

## 🔗 Relacoes Principais

- Village has_many guilds e users.
- Guild belongs_to village e narrator; has_many characters, specializations e treasure_chests; has_one quest.
- Quest has_many chapters.
- Chapter has_one boss; has_many tasks e missions.
- User has_many tasks/missions como character e como narrator (com foreign keys distintas).
- User has_many acquired_titles e pode ter active_title.

## 🧠 Regras de Negocio Relevantes

- Nivel do personagem: calculado em User#current_level com base em experiencia.
- Ao criar character, sistema tenta definir chapter inicial da quest da guilda.
- Ao mudar guild de um user, village e sincronizada automaticamente.
- Aprovar Task soma XP ao character (callback transacional com lock).
- Aprovar Mission soma ouro ao character (callback transacional com lock).
- Character so progride para proximo chapter se:
	- existir proximo chapter,
	- tiver experiencia suficiente,
	- boss atual (se existir) estiver derrotado.
- Derrota de boss exige:
	- equipe com forca suficiente (regra no model Boss),
	- character ser o finishing hero.
- Compra de bau exige ouro suficiente e permissao; sorteia reward disponivel e decrementa estoque quando limitado.

## ⚙️ Services de Dominio

### 🛡️ Character

- StatusProgressionService
	- selecionar especializacao
	- trocar classe
	- trocar titulo ativo
- ChapterProgressionService
	- progressao de chapter
- BossDefeatService
	- validacao e conclusao de derrota de boss
- QuestService
	- montagem da visao da quest com companheiros e boss
- RankingService
	- rankings por metricas da guild
- StoreService
	- loja, compra de bau e historico de compras

### 🧙 Narrator

- GuildService
	- membros da guild
	- rewards pendentes
	- entrega de rewards
- QuestService
	- visao da quest sob gestao do narrator
- PerformanceService
	- relatorio de desempenho por periodo

## 🛰️ Endpoints (Resumo)

### 🔐 Autenticacao

- Prefixo /auth (devise_token_auth)
- login, logout, cadastro, update de conta e validacao de token

### 📦 Recursos REST

- users
- tasks
- missions
- guilds
- quests
- chapters
- villages
- specializations
- character_classes
- honorary_titles
- guild_notices
- arcane_announcements
- bosses
- rewards
- treasure_chests

### ✨ Rotas de negocio adicionais

- /characters/select_specialization
- /characters/switch_class
- /characters/switch_title
- /characters/character_quest
- /characters/ranking
- /characters/purchase_history
- /characters/store_items
- /characters/purchase_chest
- /characters/progress_chapter
- /characters/defeat_boss
- /narrators/performance_report
- /narrators/guild_members
- /narrators/pending_rewards
- /narrators/narrator_quest
- /narrators/deliver_reward

## 🗃️ Estrutura de Dados (Migrations)

Pontos importantes mapeados nas migrations:

- users com campos de autenticacao Devise + atributos de jogo (role, experience, gold, active).
- FKs para relacionamentos de progressao (guild, village, specialization, character_class, current_chapter, active_title).
- chapters com indice unico em (quest_id, position).
- tasks e missions com status enum por inteiro.
- rewards com reward_type, is_limited e stock_quantity.
- character_treasure_chests com reward_claimed para controle de entrega.

## 🔑 Autenticacao na Pratica

Esta API usa autenticacao token-based com devise_token_auth.

Fluxo tipico:

1. fazer login em /auth/sign_in.
2. enviar headers de autenticacao nas proximas requests (access-token, client, uid).

## 📚 Swagger / OpenAPI

> 💡 Dica: use a UI para testar fluxos completos com token (login -> headers -> endpoints protegidos).

Documentacao disponivel em:

- /api-docs

Arquivo OpenAPI:

- openapi/v1/openapi.yaml

## 🚀 Setup Local

### ✅ Pre-requisitos

- Ruby compativel com o projeto
- Bundler
- PostgreSQL

### 📥 Instalacao

```bash
bundle install
```

### 🛢️ Banco de dados

```bash
bin/rails db:prepare
```

### 🌱 Seeds

```bash
bin/rails db:seed
```

### ▶️ Subir aplicacao

```bash
bin/rails server
```

### 🧪 Rodar testes

```bash
bin/rails test
```

## 📝 Observacoes

---

### 🎯 Leitura Rapida

- Se voce e character: foque em tasks, ranking, quest, progress_chapter e store_items.
- Se voce e narrator: foque em performance_report, pending_rewards e deliver_reward.
- Para explorar tudo via UI: acesse /api-docs.

- A API esta em modo api_only, com middlewares de cookies/sessao habilitados manualmente no config/application.rb.
- Uploads (foto/avatar/imagens) dependem de Active Storage configurado no ambiente.
- As regras de autorizacao ficam centralizadas nas policies em app/policies.

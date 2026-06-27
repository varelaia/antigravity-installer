---
title: Instalar skills en Antigravity CLI (catálogo opcional)
description: Cómo añadir skills al agente de Antigravity CLI con el catálogo comunitario Antigravity Awesome Skills vía npx. Requiere Node.js (opcional).
---

# Skills para Antigravity CLI (opcional)

Las **skills** son instrucciones estructuradas que le enseñan a tu agente a realizar
tareas específicas (desarrollo web, testing, DevOps, auditorías). Antigravity trae skills
de fábrica, y puedes ampliarlas con un catálogo comunitario.

!!! warning "Esto es 100% opcional y NO es necesario para usar `agy`"
    El CLI funciona sin instalar nada de esto. Las skills comunitarias se distribuyen por
    **npm**, así que esta es la única parte donde necesitas **Node.js**.

## Paso 1 — Instalar Node.js (si no lo tienes)

=== "Linux / macOS (script del repo)"

    ```bash
    chmod +x scripts/install_skills.sh
    ./scripts/install_skills.sh
    ```

    Instala Node LTS vía NVM en tu espacio de usuario (sin `sudo`).

=== "Manual (cualquier SO)"

    Instala Node.js LTS desde [nodejs.org](https://nodejs.org) o con tu gestor
    favorito (`nvm`, `fnm`, `volta`…).

## Paso 2 — Instalar el catálogo de skills

```bash
npx antigravity-awesome-skills
```

El instalador es **interactivo**: te preguntará a qué agente integrar las skills.

!!! danger "Nota de seguridad (supply-chain)"
    `antigravity-awesome-skills` es un paquete **de la comunidad**, no oficial de Google.
    Ejecutar `npx <paquete>` corre código de terceros en tu máquina. Revisa el paquete
    en [npmjs.com](https://www.npmjs.com/package/antigravity-awesome-skills) y considera
    fijar una versión (`npx antigravity-awesome-skills@<versión>`) en entornos serios.

## ¿Dónde quedan las skills?

| Ruta | Contenido |
|---|---|
| `~/.gemini/config/skills/` | Tus skills (las que instalas) |
| `~/.gemini/antigravity-cli/builtin/skills/` | Skills de fábrica |
| `~/.gemini/config/AGENTS.md` | Reglas globales del agente |
| `.agents/skills/` y `.agents/AGENTS.md` | Reglas y skills por proyecto (workspace) |

Antigravity detecta estas ubicaciones automáticamente al arrancar.

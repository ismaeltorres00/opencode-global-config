# Contributing — Agentes y Skills

Esta guía es para cuando **trabajas sobre este repo** (añades, editas o
retiras un agente o skill). No confundir con `AGENTS.md`, que son las
reglas que el agente sigue cuando trabaja en vuestros proyectos reales
(Sabre, Amadeus, AirGateway...) — ese archivo se carga en todas partes,
este `CONTRIBUTING.md` solo aplica aquí dentro.

---

## Antes de crear algo nuevo

1. **Busca si ya existe.** Revisa `agents/` y `skills/` — es más barato
   ampliar una skill existente que crear una casi duplicada.
2. **Decide el alcance:**
   - ¿Es una convención de un stack concreto? → prefijo de stack
     (`net-*`, `php-*`, `react-*`).
   - ¿Aplica a cualquier stack? → prefijo `shared-*`.
   - ¿Es específico de un solo proyecto/cliente? → **no va aquí**, va en
     el `.opencode/` de ese proyecto (ver README, sección "Estructura").

---

## Naming — reglas estrictas

- Formato: `<prefijo-stack>-<descripcion-corta>`, todo en minúsculas,
  palabras separadas por guiones simples.
  - Válido: `net-clean-architecture`, `php-symfony-conventions`
  - Inválido: `NetCleanArchitecture`, `net_clean_architecture`,
    `net--clean-architecture`
- El nombre del **archivo/carpeta** debe coincidir exactamente con el
  campo `name` del frontmatter. Si no coinciden, OpenCode puede no
  detectarlo.
- No reutilices un nombre que ya existió y se borró recientemente sin
  revisar el historial de PRs — puede haber contexto de por qué se quitó.

---

## Crear un agente nuevo

Checklist obligatorio en `agents/<nombre>.md`:

```yaml
---
name: <stack>-dev                    # coincide con el nombre del archivo
description: Frase clara de una línea sobre qué hace este agente
mode: primary                        # obligatorio para poder invocarlo con --agent
permission:
  skill:
    "<stack>-*": allow
    "shared-*": allow
    "*": deny
metadata:
  version: "1.0.0"
  owner: "<tu nombre o equipo>"
  last_updated: "2026-09-16"
---

<system prompt aquí>
```

Guarda siempre en **UTF-8** (en Windows, Notepad → Guardar como →
Codificación: UTF-8; "ANSI" corrompe los acentos).

---

## Crear una skill nueva

Checklist obligatorio en `skills/<nombre>/SKILL.md`:

```yaml
---
name: <stack>-<descripcion-corta>
description: Cuándo debe cargarse esta skill (sé específico, el agente
  decide si la usa según este texto)
metadata:
  version: "1.0.0"
  owner: "<tu nombre o equipo>"
  last_updated: "2026-09-16"
---

<contenido de la skill>
```

Una skill completa y útil sobre un caso concreto vale más que cinco a
medias sobre casos genéricos.

---

## Versionado y control de cambios

No usamos un changelog central: **cada skill/agente versiona su propio
`metadata.version`** (SemVer simplificado: `MAYOR.MENOR.PARCHE`).

- **PARCHE** (`1.0.0` → `1.0.1`): corrección menor, typo, aclaración sin
  cambiar el comportamiento.
- **MENOR** (`1.0.0` → `1.1.0`): añade contenido/capacidad sin romper lo
  que ya usaban otros (nueva sección, nuevo caso cubierto).
- **MAYOR** (`1.0.0` → `2.0.0`): cambia el comportamiento de forma que
  podría sorprender a alguien que ya lo usaba (cambia una convención
  existente, elimina una recomendación anterior).

Actualiza siempre `last_updated` al tocar el archivo, aunque sea un
cambio de PARCHE — así cualquiera puede ver de un vistazo si una
skill/agente lleva mucho tiempo sin revisión.

Un cambio **MAYOR** en un agente o skill que ya usa el equipo activamente
requiere avisar en el canal del equipo antes de mergear, no solo el PR.

---

## Retirar un agente o skill

No se borra directamente:
1. Añade `deprecated: true` a `metadata` y explica en el propio
   `description` qué lo sustituye (si aplica).
2. Déjalo así como mínimo un sprint, para que nadie lo pierda sin aviso.
3. Pasado ese tiempo, bórralo en un PR aparte, mencionando en la
   descripción del PR desde cuándo estaba marcado como deprecated.

---

## Proceso de PR

1. Rama nueva desde `main`: `feature/<stack>-<nombre-recurso>`.
2. Sigue el checklist de arriba (naming, frontmatter completo, UTF-8).
3. Prueba localmente antes de abrir PR:
   - Windows: `$env:OPENCODE_CONFIG_DIR = "C:\ruta\a\tu\rama"`
   - macOS/Linux: `OPENCODE_CONFIG_DIR=/ruta/a/tu/rama opencode`
4. Abre el PR con una descripción breve: qué añade/cambia y por qué.
5. Revisión de al menos **otro dev del mismo stack** — si es `shared-*`,
   revisión de alguien de al menos dos stacks distintos.
6. Mergea solo tras aprobación. Nunca push directo a `main` (regla también
   presente en `AGENTS.md`, pero aquí aplica igual a los propios devs).
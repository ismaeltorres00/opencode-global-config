---
name: shared-catalog-governance
description: "Trigger: catalogo OpenCode, crear skill global, crear agente global, versionar skills. Gobierna recursos compartidos del Equipo Dev CDV."
license: internal
metadata:
  version: "1.0.0"
  owner: "Equipo Dev CDV"
  last_updated: "2026-09-16"
---

# Gobierno Del Catalogo

## Contrato De Activacion

Usar solo al mantener este repositorio central: crear, actualizar, deprecar o
retirar agentes, skills, comandos, reglas o scripts que se distribuyen al
equipo.

## Reglas Estrictas

- Leer `CONTRIBUTING.md`, `README.md` y los recursos relacionados antes de editar.
- Mantener los recursos globales en `agents/` o `skills/`; el contenido de un
  solo proyecto pertenece a su `.opencode/`.
- Usar nombres en minusculas con guiones: `<stack>-<descripcion>` o
  `shared-<descripcion>`. El nombre, archivo y carpeta deben coincidir.
- Las skills deben tener `metadata.version`, `metadata.owner` y
  `metadata.last_updated`. Los agentes deben usar el comentario
  `catalog-version` después del frontmatter, con versión, owner y fecha
  `YYYY-MM-DD`; `metadata` no es válido en su frontmatter.
- No añadir secretos, credenciales ni permisos globales más amplios sin
  solicitud explícita y revisión humana.

## Pasos De Ejecucion

1. Buscar recursos equivalentes. Ampliar uno existente si cubre la necesidad;
   crear uno solo si el patrón es reutilizable y no duplica contexto.
2. Elegir alcance y prefijo. Si falta el stack, crear su agente primario con
   acceso a `<stack>-*` y `shared-*`, denegando el resto.
3. Crear skills en `skills/<nombre>/SKILL.md` y agentes en
   `agents/<nombre>.md`. Añadir una descripción que incluya qué hace y cuándo
   debe activarse.
4. Versionar: parche para aclaraciones sin cambio de comportamiento, menor
   para capacidad compatible y mayor para cambios incompatibles. Actualizar la
   fecha en cualquier modificación.
5. Para retirar, marcar `metadata.deprecated: true` en skills o
   `deprecated: true` en el comentario de agentes, indicar sustituto en la
   descripción y conservar al menos un sprint antes de borrar en otro PR.
6. Actualizar el inventario y ejemplos de `README.md` si cambian recursos,
   prefijos o instalación; actualizar `CONTRIBUTING.md` si cambia la política.
7. Validar JSON y frontmatter, revisar el diff y comunicar versiones y cambios
   breaking.

## Interaccion Incremental

No pedir un cuestionario ni devolver una plantilla vacía. Con el objetivo
general, crear el recurso real como borrador y usar marcadores `TODO` para los
detalles que aún no existan. Preguntar solo una decisión crítica cada vez y
aplicar cada respuesta del usuario directamente al archivo.

## Contrato De Salida

Informar de los recursos creados o modificados, su alcance, el cambio de
versión y las verificaciones ejecutadas. Si la necesidad es de proyecto,
explicar la ubicación `.opencode/` recomendada sin añadirla al catálogo global.

## Referencias

- `../../CONTRIBUTING.md` - nomenclatura, estructura y versionado normativos.
- `../../README.md` - instalación, precedencia y uso del catálogo.

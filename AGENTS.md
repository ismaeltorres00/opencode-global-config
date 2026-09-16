# Reglas del equipo — aplican a todos los agentes, sin importar el stack

## Git y commits
- Commits en inglés, formato convencional: `feat:`, `fix:`, `refactor:`, `docs:`.
- Nunca hacer `git push --force` a `main`/`develop`.
- Nunca commitear directamente a `main`; siempre rama + PR.

## Seguridad
- Nunca escribir, loggear, ni commitear credenciales, tokens o claves de API
  (Sabre, Amadeus, AirGateway u otros). Si aparecen en código existente,
  avisar y sugerir mover a variables de entorno / secret manager.
- Nunca ejecutar comandos que borren datos en entornos que no sean locales
  (`DROP`, `DELETE FROM` sin `WHERE`, `rm -rf` fuera del working dir).

## Revisión de código
- Antes de dar por cerrada una tarea, verificar que el código compila/pasa
  los tests si el proyecto tiene tooling para ello.
- Señalar explícitamente cualquier breaking change en contratos de API.

## Comunicación
- Responder en español salvo que el código, comentarios o nombres de
  variables ya estén en inglés (seguir la convención del archivo que se edita).
- Si falta contexto para tomar una decisión de arquitectura, preguntar antes
  de asumir.

## Catálogo de OpenCode
- Para crear, actualizar o retirar recursos de este repositorio, usar la skill
  `shared-catalog-governance` y seguir `CONTRIBUTING.md`.
- Los recursos globales usan los prefijos `net-*`, `php-*`, `react-*` o
  `shared-*`; los específicos de producto pertenecen a `.opencode/` del
  proyecto correspondiente.

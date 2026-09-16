# NOTES — react-frontend

Al abrir OpenCode en este proyecto se carga el agente `react-dev` por
defecto (definido en `opencode.json`), creado en esta misma revisión en
el repo central. Ese agente ve las skills `react-*` y `shared-*` del
repo central (`react-component-patterns`, `shared-jira-task-author`)
combinadas con la skill propia de este proyecto,
`react-ops-console-table-filters`, definida en `.opencode/skills/`. Una
pregunta como "¿por qué se pierden los filtros de la tabla al pulsar
atrás?" dispararía la skill de proyecto en vez de la genérica de
patrones de componentes.

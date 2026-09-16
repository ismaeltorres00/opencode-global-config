# NOTES — net-sabre

Al abrir OpenCode en este proyecto se carga el agente `net-dev` por
defecto (definido en `opencode.json`). Ese agente ve las skills `net-*` y
`shared-*` del repo central (`net-clean-architecture`,
`shared-jira-task-author`) combinadas con la skill propia de este
proyecto, `net-sabre-offer-cache`, definida en
`.opencode/skills/`. Una pregunta como "¿por qué me llega 'offer no
longer valid' al confirmar el pago?" dispararía la skill de proyecto en
vez de (o además de) las convenciones genéricas de arquitectura.

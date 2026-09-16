# NOTES — php-api

Al abrir OpenCode en este proyecto se carga el agente `php-dev` por
defecto (definido en `opencode.json`). Ese agente vería las skills
`php-*` y `shared-*` del repo central combinadas con la skill propia de
este proyecto, `php-redsys-webhook`, definida en `.opencode/skills/`.
Una pregunta como "¿por qué se está duplicando la confirmación de pago
cuando Redsys reintenta la notificación?" dispararía la skill de
proyecto. Nota: el repo central todavía no tiene un agente `php-dev`
definido en `agents/` — ver resumen de la Fase 1.

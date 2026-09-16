---
name: php-redsys-webhook
description: Convenciones de este proyecto para el endpoint que recibe notificaciones de pago de Redsys (verificación de firma, idempotencia por número de pedido, respuesta rápida antes de procesar). Usar cuando el usuario pida crear o modificar el endpoint de notificación de Redsys, depurar pagos duplicados o no confirmados, o revisar la seguridad de ese webhook.
metadata:
  version: "1.0.0"
  owner: "Equipo Dev CDV"
  last_updated: "2026-09-16"
---

## Contexto

Redsys notifica el resultado de un pago llamando a un endpoint público
(`POST /webhooks/redsys/notification`). Redsys reintenta la notificación
si no recibe un `200 OK` a tiempo, así que el endpoint tiene que ser
rápido e idempotente — no puede asumir que cada llamada es un pago nuevo.

## Verificación de firma

- Toda notificación se valida contra la firma `Ds_Signature` usando la
  clave de comercio del entorno correspondiente **antes** de leer ningún
  otro campo del payload. Si la firma no es válida, se responde error y no
  se procesa nada más.
- La clave de firma nunca se hardcodea ni se loggea — viene de variables
  de entorno / secret manager, igual que el resto de credenciales.

## Idempotencia

- El número de pedido (`Ds_Order`) es la clave de idempotencia: si ya
  existe un pago confirmado para ese pedido, la notificación se responde
  `200 OK` sin reprocesar, para no duplicar la confirmación de reserva ni
  reenviar el email de confirmación dos veces.
- El cambio de estado del pedido (pendiente → pagado) debe hacerse con un
  lock/transacción que evite condiciones de carrera si Redsys reintenta en
  paralelo.

## Tiempo de respuesta

- El endpoint responde `200 OK` en cuanto la notificación es válida y el
  estado del pedido queda actualizado. Cualquier trabajo pesado
  (confirmar la reserva con el proveedor, enviar email) se delega a una
  cola en vez de hacerse síncronamente dentro del webhook.

## Cuándo usar esta skill

Úsala cuando el usuario pida crear o tocar el endpoint de notificación de
Redsys, investigar pagos duplicados/no confirmados, o revisar la
seguridad e idempotencia de ese flujo.

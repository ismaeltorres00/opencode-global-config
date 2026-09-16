---
name: net-sabre-offer-cache
description: Convenciones de este proyecto para cachear ofertas de Sabre (offer tokens de vida corta, invalidación al cambiar ancillaries, claves de caché por criterio de búsqueda normalizado). Usar cuando el usuario pida cachear resultados de búsqueda/pricing de Sabre, investigar ofertas expiradas o "no longer valid" en flujos de repricing, o revisar la estrategia de invalidación de caché de ofertas.
metadata:
  version: "1.0.0"
  owner: "Equipo Dev CDV"
  last_updated: "2026-09-16"
---

## Contexto

Los `offer token` que devuelve Sabre para una búsqueda son válidos solo
unos minutos (la sesión de pricing expira). Este proyecto cachea el
resultado completo de la búsqueda para evitar volver a golpear la API de
Sabre en cada paso del funnel (resultados → detalle → ancillaries →
checkout), pero la caché tiene que respetar esa ventana de validez o el
usuario llega a pago con una oferta que Sabre ya rechaza.

## Clave de caché

- La clave se genera a partir del criterio de búsqueda **normalizado**:
  origen, destino, fechas, pasajeros (por tipo, no por orden), y cabina.
  Dos búsquedas equivalentes con distinto orden de pasajeros deben mapear
  a la misma clave.
- Nunca uses el `offer token` crudo de Sabre como parte de la clave — es
  opaco y cambia entre llamadas aunque el criterio de búsqueda sea idéntico.

## TTL e invalidación

- El TTL de la entrada de caché debe ser **igual o menor** al tiempo de
  vida del `offer token` que informa Sabre en la respuesta de búsqueda, no
  un valor fijo arbitrario en el código.
- Si el usuario selecciona o quita un ancillary, la oferta cacheada para
  ese `offer token` se invalida inmediatamente (no se sirve desde caché en
  el siguiente paso) — un ancillary cambia el pricing y Sabre requiere
  reconfirmar.
- Si Sabre devuelve `offer no longer valid` en el paso de checkout, no se
  reintenta contra la entrada cacheada: se fuerza una búsqueda nueva y se
  informa al usuario del cambio de precio si aplica.

## Cuándo usar esta skill

Úsala cuando el usuario pida implementar o revisar la caché de resultados
de búsqueda/pricing de Sabre, o cuando aparezcan errores de oferta
expirada en el flujo de repricing/checkout.

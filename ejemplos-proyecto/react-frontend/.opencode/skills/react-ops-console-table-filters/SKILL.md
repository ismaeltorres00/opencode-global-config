---
name: react-ops-console-table-filters
description: Convenciones de este proyecto para las tablas de la consola de operaciones (filtros sincronizados con la URL, deep-linkable, estado de filtro separado del estado de paginación). Usar cuando el usuario pida añadir o modificar filtros en una tabla de la consola, compartir/enlazar una vista filtrada, o revisar por qué los filtros se pierden al refrescar o navegar atrás.
metadata:
  version: "1.0.0"
  owner: "Equipo Dev CDV"
  last_updated: "2026-09-16"
---

## Contexto

Las tablas de la consola de operaciones (reservas, incidencias, pagos) se
comparten constantemente entre compañeros por enlace ("mira estos 3
pedidos en estado X") y con el botón atrás del navegador. Si el filtro
vive solo en estado de React (`useState`), se pierde al refrescar o al
copiar la URL — por eso en este proyecto los filtros de tabla van
siempre sincronizados con los query params de la URL.

## Estado de filtros vs. paginación

- Los filtros (texto de búsqueda, estado, rango de fechas, columnas
  activas) se reflejan como query params (`?status=pending&from=2026-09-01`),
  no como estado interno del componente de tabla.
- La página actual (`?page=2`) se sincroniza también con la URL, pero se
  resetea a `1` cada vez que cambia cualquier filtro — nunca se mantiene
  la página 3 de un filtro distinto al que la generó.
- Cambiar de tabla o navegar a otra sección no debe arrastrar filtros de
  la tabla anterior: cada tabla tiene su propio namespace de query params.

## Deep-linking

- Cualquier vista filtrada tiene que poder copiarse y pegarse en otra
  pestaña y reproducir exactamente los mismos resultados — si un filtro no
  se puede serializar de forma legible en la URL, no se añade como filtro
  de tabla sin antes decidir cómo se va a serializar.

## Cuándo usar esta skill

Úsala cuando el usuario pida añadir o modificar filtros en una tabla de la
consola de operaciones, o cuando reporte que un filtro se pierde al
refrescar, compartir el enlace, o navegar con el botón atrás.

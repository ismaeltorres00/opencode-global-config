---
name: net-clean-architecture
description: Convenciones de arquitectura y capas para proyectos .NET del equipo (controllers, services, repos, DTOs de integraciones aéreas)
license: internal
metadata:
  version: "1.0.0"
  owner: "Equipo Dev CDV"
  last_updated: "2026-09-16"
---

## Capas del proyecto

- `Controllers/`: solo orquestan, sin lógica de negocio. Reciben el
  request, llaman al service correspondiente, devuelven el DTO de
  respuesta.
- `Services/`: lógica de negocio y orquestación de llamadas a proveedores
  (Sabre/Amadeus/AirGateway). Un service por dominio (ej. `PricingService`,
  `BookingService`), no un service gigante.
- `Providers/` o `Integrations/`: un cliente HTTP por proveedor, encapsula
  auth, retries y mapeo de errores específico de esa API.
- `DTOs/`: modelos de entrada/salida de nuestra API, separados de los
  modelos crudos del proveedor externo. Nunca exponer directamente el
  modelo de Sabre/Amadeus al cliente final.
- `Mappers/`: conversión explícita entre modelo del proveedor y nuestro
  DTO. Preferir mappers explícitos (métodos o extension methods) sobre
  AutoMapper para modelos con lógica de negocio en la conversión (ej.
  cálculo de pricing con markups).

## Reglas de async/await

- Todo I/O (HTTP, DB) es `async` de punta a punta. Nunca `.Result` ni
  `.Wait()` sobre una tarea async — bloquea el thread pool.
- Usar `CancellationToken` en todas las llamadas a APIs externas y
  propagarlo desde el controller.

## Manejo de errores de proveedores externos

- Nunca dejar que una excepción cruda de un proveedor externo llegue al
  cliente. Capturar, loggear con contexto (proveedor, endpoint, PNR/offer
  id si aplica) y traducir a un error de dominio propio.
- Diferenciar errores recuperables (timeout, rate limit → reintentar con
  backoff) de errores de negocio (oferta expirada, tarifa no disponible →
  no reintentar, devolver al usuario).

## Cuándo usar esta skill

Úsala cuando el usuario pida crear un nuevo endpoint, service o
integración con un proveedor aéreo, o cuando pida revisar si un fichero
existente sigue estas convenciones.

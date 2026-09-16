---
name: react-component-patterns
description: Convenciones de componentes React del equipo (estructura de carpetas por feature, separación entre componentes de presentación y contenedores, manejo de estado local vs. compartido). Usar cuando el usuario pida crear un componente nuevo, dividir uno existente que ha crecido demasiado, o revisar si un componente sigue las convenciones del equipo.
metadata:
  version: "1.0.0"
  owner: "Equipo Dev CDV"
  last_updated: "2026-09-16"
---

## Estructura de un componente

- Un componente por archivo, nombre del archivo en `PascalCase` igual que
  el componente exportado.
- Componentes de presentación (solo props → UI) separados de componentes
  contenedor (fetching, estado, orquestación). El contenedor pasa datos y
  callbacks como props al de presentación.
- Estilos co-ubicados junto al componente, no en una carpeta global de CSS
  salvo que sean tokens/variables compartidas.

## Estado

- Estado local (`useState`) para lo que solo afecta a ese componente y sus
  hijos directos.
- Estado compartido entre varias ramas del árbol sube al ancestro común más
  cercano, o a un store si son muchos consumidores — no "prop drilling" de
  más de 2-3 niveles.
- Derivar valores en el render en vez de duplicarlos en estado cuando se
  pueden calcular a partir de otro estado o de las props.

## Cuándo usar esta skill

Úsala cuando el usuario pida crear un componente nuevo, dividir uno que ha
crecido demasiado, o revisar si un componente existente sigue estas
convenciones.

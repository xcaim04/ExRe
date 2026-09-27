# `docs/`

Los documentos de referencia de ExRE. El contenido de esta carpeta es lo que se entregó al agente de IA antes de escribir el código, más el registro de cómo se hizo.

| Archivo | Qué es |
| ------- | ------ |
| [`prompt_exre_flutter.md`](prompt_exre_flutter.md) | **El encargo original.** Especificación funcional y visual escrita por una persona: contexto, restricciones no negociables, tokens exactos del sistema de diseño, estructura de carpetas, modelo de datos SQLite, checklist de fidelidad por pantalla y plan de 26 commits. Está antes que el código porque así se desarrolló. |
| [`AI_ASSISTED_DEVELOPMENT.md`](AI_ASSISTED_DEVELOPMENT.md) | **El registro del proceso.** Qué agente se utilizó, cómo se le guió, con qué puertas de verificación se comprobó el resultado y qué queda sin verificar. |
| [`App ExRE.pdf`](App%20ExRE.pdf) | Mockup de referencia de las seis pantallas. |
| [`Diseño.pen`](Diseño.pen) | Archivo de diseño de pen.dev. |

## Cómo leerlos en orden

1. **`prompt_exre_flutter.md`**, si quieres saber qué se pidió y con qué restricciones.
2. **`AI_ASSISTED_DEVELOPMENT.md`**, si quieres saber quién decidió qué, cómo se controló el trabajo y qué no está verificado.
3. Los dos archivos de diseño, si quieres contrastar el resultado con la referencia.

> **Nota.** El PDF y el archivo `.pen` son la referencia de diseño, pero su contraste contra la interfaz real no se ha hecho: la app no se ha ejecutado en ningún dispositivo físico. Ver la sección de límites en `AI_ASSISTED_DEVELOPMENT.md`.

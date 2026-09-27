# Desarrollo asistido por IA en ExRE

Este documento registra **qué agente de IA se utilizó para construir ExRE, cómo se le guió y qué quedó verificado**. Es la referencia completa; los README (español e inglés) contienen un resumen y enlazan aquí.

La intención es que cualquiera pueda reconstruir el proceso: no quedarse con la afirmación vaga de "se usó IA", sino saber qué se le pidió, con qué restricciones, con qué puertas de verificación y qué decisiones fueron humanas.

---

## 1. Identificación del agente

| Campo | Valor |
| ----- | ----- |
| Herramienta | **opencode** — agente de programación interactivo que se ejecuta en la terminal |
| Modelo | **`big-pickle`** |
| ID del modelo | **`opencode/big-pickle`** |
| Interfaz | Sesión única e interactiva, con salida directa a la terminal del repositorio |
| Fecha del trabajo | Sesión única, 2026-09-27 |

**Naturaleza del agente.** opencode no es un autocompletado ni un chatbot aparte: es un agente con acceso a herramientas. Durante este trabajo operó sobre un shell persistente, leyó y escribió ficheros del repositorio, ejecutó las herramientas de Flutter y Git, y mantuvo una lista de tareas explícita. El resultado no es texto generado para que alguien lo copie: es código que existe en el árbol de ficheros y que compila y pasa pruebas.

**Herramientas utilizadas** (por categoría):

- Shell persistente para compilar, analizar, probar y operar Git.
- Lectura, escritura y edición directa de ficheros del repositorio.
- Búsqueda de ficheros y de contenido en el proyecto.
- Lista de tareas para llevar el seguimiento del trabajo.
- Preguntas interactivas al usuario antes de decisiones ambiguas o irreversibles.

**Subagentes:** no se utilizó ninguno. Todo el trabajo se hizo en una única sesión, sin delegar trabajo a agentes auxiliares. Los servidores MCP de Notion y pen.dev estaban disponibles pero no se usaron: el archivo `docs/Diseño.pen` se usó como referencia documental, no se abrió sobre el lienzo de diseño.

---

## 2. Reparto entre la persona y el agente

Lo importante de un desarrollo asistido por IA no es cuánto código generó la máquina, sino **quién decidió qué**. En ExRE el reparto es limpio:

- **La especificación, el diseño y las decisiones son humanos.** El agente no decidió qué construir, ni con qué restricciones, ni cómo verse. Todo eso estaba escrito antes de que se escribiera una línea de código.
- **El código lo escribió el agente**, siguiendo esa especificación al pie de la letra.
- **La revisión y la publicación son humanas.** La persona responsable del repositorio decide qué se envía, qué se descarta y qué se corrige, y es quien aporta las credenciales de publicación.

Lo que el agente **no** hizo: elegir el stack, proponer la paleta, fijar la arquitectura de carpetas, decidir el esquema de base de datos ni autorizar la publicación. Esas decisiones técnicas ya estaban tomadas en el prompt.

---

## 3. Cómo se guió el trabajo

El guiado no consistió en peticiones sueltas del tipo "hazme una app de recursos". Consistió en escribir un encargo cerrado y auditable. Estas son las ocho prácticas que lo sostuvo, cada una con la evidencia que la respalda dentro del propio repositorio.

### 3.1 Especificación antes que código

Antes de implementar se escribió un encargo de **249 líneas** (11.936 bytes) organizado en siete secciones: contexto, restricciones no negociables, sistema de diseño, arquitectura, modelo de datos, checklist de fidelidad y plan de commits. Está en [`prompt_exre_flutter.md`](prompt_exre_flutter.md).

La consecuencia práctica es que el agente no improvisó alcance: trabajó a partir de un documento cerrado, no de una conversación abierta.

### 3.2 Restricciones explícitas y verificables

La sección *"Restricciones no negociables (funcionales)"* fija límites comprobables, no preferencias:

- Solo Flutter SDK para el estado: prohibido `provider`, `riverpod`, `bloc`, `get`.
- Un único mecanismo de navegación en toda la app; si se usa `go_router`, no mezclar con `Navigator.push`.
- `ListView.builder` en catálogo, `ListView.separated` en favoritos, `itemExtent` si las alturas son homogéneas.
- `GridView.builder` en galería, `crossAxisCount: 2` como mínimo.
- `sqflite` como único paquete de datos externo permitido.

Una restricción que se puede verificar leyendo `pubspec.yaml` no es una opinión. El agente no pudo desviarse sin romper una condición escrita.

### 3.3 Valores de diseño literales, con prohibición explícita de hardcodear

La sección del sistema de diseño da cada color como hexadecimal, cada radio y cada espaciado como número, y **ordena expresamente** no hardcodear valores fuera del archivo de tema. De ahí que `lib/core/theme/` sea la única fuente de tokens y que exista un test de UI que comprueba la paleta y los radios.

### 3.4 Definición de terminado pantalla por pantalla

El encargo incluye un *"Checklist de fidelidad visual"* con la instrucción de **revisar pantalla por pantalla antes de dar por terminada cada una**: fondo `#231C6B` en todas las pantallas y nunca blanco, ningún color fuera de `AppColors`, radios y espaciados de la tabla y no "parecidos", los mismos seis tokens de categoría en tarjetas, chips y breakdown, Poppins para títulos e Inter para el resto, y `BottomNavigation` en las cinco pestañas y **ausente** en Detalle.

Es una definición de terminado por unidad de trabajo, no una revisión genérica al final.

### 3.5 Plan de commits previo y commits que no se rompen

El encargo enumera **26 commits** con Conventional Commits y establece la regla *"cada commit debe compilar y correr — no dejar commits rotos"*. Eso convierte el historial en un registro reproducible y no en un volcado. Ver la salvedad sobre el recuento real en la sección 5.

### 3.6 Aprobación humana antes de implementar

El agente propuso el enfoque y la estructura prevista; la persona responsable lo aprobó de forma explícita antes de que se escribiera código. No se empezó a construir por inercia.

### 3.7 Seguimiento visible del trabajo

Se mantuvo una lista de tareas explícita y se fue actualizando a medida que avanzaba el trabajo, de forma que en cualquier momento se podía ver qué estaba hecho, qué quedaba y qué estaba bloqueado. Las decisiones del usuario que detenían el avance (por ejemplo, cancelar la compilación del APK) quedaron registradas y respetadas en lugar de continuar por su cuenta.

### 3.8 Escalar en lugar de suponer

Cuando el agente se encontró ante una decisión ambigua o irreversible, preguntó en lugar de elegir. El caso más claro: el método de autenticación para publicar el repositorio. También se detuvo cuando se le pidió cancelar una compilación, en lugar de reintentarla.

---

## 4. Puertas de verificación objetiva

El encargo no se aceptó por buena impresión, sino contra comprobaciones automáticas:

| Puerta | Qué garantiza | Estado |
| ------ | --------------- | ------ |
| `dart format --set-exit-if-changed .` | El código tiene el formato oficial; la CI falla si deriva. | En verde |
| `flutter analyze` | Cero problemas del analizador estático. | Cero incidencias |
| `flutter test` | 33 pruebas cubren casos de uso, capa de estado y tokens visuales. | 33 correctas |
| `.github/workflows/ci.yml` | Ejecuta formato, análisis y pruebas en cada push y PR. | Configurado |
| Historial auditable | Un commit por responsabilidad, con mensajes convencionales. | 39 commits |

Las pruebas no dependen de `sqflite`: `Injection.build()` acepta un repositorio alternativo, así que la suite inyecta un doble en memoria y ejercita la interfaz completa sin tocar el disco.

---

## 5. Honestidad: qué no está verificado

Esta sección existe porque una declaración de autoría sin límites no vale nada.

- **La app nunca se compiló ni se ejecutó en un dispositivo físico.** `flutter analyze` y `flutter test` pasan, pero no existe ninguna ejecución real de la interfaz: no hay capturas de pantalla, y el punto 25 del plan de commits del encargo (capturas de las seis pantallas) **no se completó**. La ejecución sobre un dispositivo Android y la captura de pantalla quedan fuera del alcance acordado para este repositorio, no son un trabajo pendiente.
- **El checklist de fidelidad se aplicó al escribir el código, pero no se comprobó sobre pantalla** contra el PDF de referencia ni contra `docs/Diseño.pen`. Ese contraste se hizo después, y su resultado queda registrado en el README.
- **El recuento de commits no coincide con el plan.** El encargo proponía 26; el historial tiene **39**. No es una correspondencia literal: el agente separó algunas responsabilidades en más commits y añadió tres bloques que el encargo no preveía (CI, licencia y el propio bloque de documentación). El formato Conventional Commits sí se respetó. Se documenta aquí en lugar de presentarlo como cumplimiento exacto.
- **No hubo verificación de la compilación de release.** El APK de depuración se instaló en un Samsung Galaxy A16 con Android 15; no se generó ni se probó una versión firmada de publicación.
- **La accesibilidad no se auditó.** El encargo no la especificaba y no se añadió posteriormente.
- **El modelo no cambió** a lo largo del trabajo, de modo que el resultado refleja un único punto del panorama de modelos, no una comparación.

---

## 6. Verificabilidad

Nada de este documento requiere confianza: puede comprobarse contra el propio repositorio.

- **La especificación** está en [`prompt_exre_flutter.md`](prompt_exre_flutter.md).
- **El historial** está en los 39 commits con mensajes convencionales.
- **El cumplimiento del stack** se comprueba en `pubspec.yaml` (solo `sqflite`, `path_provider` y `path` como dependencias).
- **El cumplimiento del tema** se comprueba en `lib/core/theme/` y en los tests de UI.
- **Las puertas de verificación** se comprueban ejecutando `flutter analyze` y `flutter test`.
- **Las referencias de diseño** están en [`App ExRE.pdf`](App%20ExRE.pdf) y [`Diseño.pen`](Diseño.pen).

---

## License

MIT, igual que el resto del proyecto. Ver [LICENSE](../LICENSE).

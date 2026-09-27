# ExRE

**Explorador de Recursos de Estudio** — app Flutter para Android para explorar, filtrar, buscar, marcar como favorito y completar recursos de estudio. Seis pantallas, cinco pestañas, persistencia local en SQLite y cero dependencias de red.

Implementada a partir de una especificación de diseño literal, con la paleta, la tipografía, los radios y las métricas del diseño reproducidos al token. La especificación y los archivos de referencia están en [`docs/`](docs/).

[![CI](https://github.com/xcaim04/ExRe/actions/workflows/ci.yml/badge.svg)](https://github.com/xcaim04/ExRe/actions/workflows/ci.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.44.9-02569A?logo=flutter&logoColor=white)](https://docs.flutter.dev/release/release-notes/release-notes-3.44.9)
[![Dart](https://img.shields.io/badge/Dart-3.12.2-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

> 🇬🇧 [English version](README.en.md)

---

## Autoría

Este proyecto fue **desarrollado con ayuda de un agente de inteligencia artificial**.

| | |
| --- | --- |
| **Herramienta** | [opencode](https://opencode.ai) — agente de programación interactivo que se ejecuta en la terminal |
| **Modelo** | `big-pickle` (ID: `opencode/big-pickle`) |
| **Subagentes** | Ninguno. Todo el trabajo se hizo en una única sesión. |
| **Especificación** | Escrita por una persona, antes de generar código |

### El punto de partida fue un encargo, no una petición abierta

El trabajo no empezó con un boceto, sino con una **especificación de 249 líneas** escrita por una persona, que fija las seis pantallas, los valores literales del sistema de diseño, la estructura de carpetas, el esquema de datos, las restricciones del stack y el plan de commits. Ese documento es [`docs/prompt_exre_flutter.md`](docs/prompt_exre_flutter.md) y se incluye en el repositorio.

### El reparto, sin ambigüedad

- **La especificación, el diseño y las decisiones son humanos.** El agente no eligió el stack, ni propuso la paleta, ni fijó la arquitectura, ni decidió el esquema de datos: todo eso ya estaba escrito.
- **El código lo escribió el agente**, siguiendo esa especificación al pie de la letra.
- **La revisión y la publicación son humanas.** Quien mantiene el repositorio decide qué se envía, qué se descarta y qué se corrige, y es quien aporta las credenciales de publicación.

### Cómo se guió el trabajo

El guiado no fueron peticiones sueltas, sino un encargo cerrado y auditable. Las prácticas concretas, con la evidencia que las respalda:

1. **Especificación antes que código.** Un documento cerrado de 249 líneas, no una conversación abierta.
2. **Restricciones explícitas y verificables.** Una sección de "restricciones no negociables" que se comprueba leyendo `pubspec.yaml`.
3. **Valores de diseño literales**, con orden expresa de no hardcodear nada fuera del archivo de tema.
4. **Definición de terminado pantalla por pantalla**, mediante un checklist de fidelidad visual.
5. **Plan de commits previo**, con la regla de que ningún commit se deja roto.
6. **Aprobación humana antes de implementar.**
7. **Seguimiento visible** mediante una lista de tareas mantenida al día.
8. **Escalar en lugar de suponer** ante decisiones ambiguas o irreversibles.

El resultado no se aceptó por buena impresión, sino contra puertas de verificación automáticas: `dart format`, `flutter analyze` sin incidencias, `flutter test` con 33 pruebas correctas y un workflow de CI que las ejecuta en cada push. La suite no depende de `sqflite`: `Injection.build()` acepta un repositorio alternativo, así que las pruebas ejercitan la interfaz completa en memoria.

### Qué no está verificado

- **La app todavía no se ha ejecutado en un dispositivo físico.** En el momento de escribir este README, `flutter analyze` está limpio y las 33 pruebas pasan, pero no hay ninguna captura de pantalla real: la ejecución sobre un Samsung Galaxy A16 con Android 15 y el contraste del checklist de fidelidad contra el PDF de referencia quedan pendientes.
- El checklist de fidelidad se aplicó **al escribir el código**, pero **nunca se comprobó sobre pantalla**.
- El historial tiene **39 commits frente a los 26 del plan**: es un superconjunto, no una correspondencia literal. El formato de Conventional Commits sí se respetó.

El detalle completo de todo esto está en **[`docs/AI_ASSISTED_DEVELOPMENT.md`](docs/AI_ASSISTED_DEVELOPMENT.md)**, que incluye esta misma sección de límites.

---

## Contenido

- [Qué hace](#qué-hace)
- [Autoría](#autoría)
- [Las seis pantallas](#las-seis-pantallas)
- [Stack y restricciones](#stack-y-restricciones)
- [Puesta en marcha](#puesta-en-marcha)
- [Arquitectura](#arquitectura)
- [Sistema de diseño](#sistema-de-diseño)
- [Navegación](#navegación)
- [Estado](#estado)
- [Persistencia](#persistencia)
- [Testing](#testing)
- [Decisiones de diseño](#decisiones-de-diseño)
- [Especificación](#especificación)
- [Licencia](#licencia)

---

## Qué hace

- **Explora** 24 recursos sembrados localmente, repartidos en 6 categorías de Flutter.
- **Filtra** por categoría, busca por texto en título, autor y descripción, y ordena por título o duración.
- **Guarda** favoritos y marca recursos como completados, con escrituras optimistas y reversión automática si SQLite falla.
- **Mide** el progreso con porcentaje general, porcentaje de tiempo y desglose por categoría.
- **Persiste** todo en una base SQLite local: la app funciona sin servidor, sin cuenta y sin conexión.

## Las seis pantallas

| Pantalla  | Ruta         | Qué contiene |
| -------- | ------------ | ------------ |
| **Inicio**    | `/`         | Saludo, accesos rápidos con badge de progreso, y tira horizontal de las 6 categorías. |
| **Catálogo**  | `/catalog`   | Campo de búsqueda, barra de filtros, lista con `ListView.builder` y estado vacío. |
| **Galería**   | `/gallery`   | Rejilla de 2 columnas con `GridView.builder`. |
| **Favoritos** | `/favorites`| Lista separada con `ListView.separated` y estado vacío. |
| **Progreso**  | `/progress`  | Anillo de progreso general, cuatro tarjetas de métrica y desglose por categoría. |
| **Detalle**   | `/detail`    | Portada a tamaño completo, metadatos, descripción y los toggles de favorito y completado. |

Las cinco pestañas comparten un `AppShell` con `IndexedStack`, así que cambiar de pestaña **conserva el estado y la posición de scroll** de cada una.

## Stack y restricciones

- **Flutter 3.44.9 / Dart 3.12.2** (versión fijada; el proyecto no actualiza el SDK).
- **Android** con Kotlin. `namespace` y `applicationId`: `com.exre.exre`.
- **Estado solo con el SDK**: `ChangeNotifier`, `InheritedNotifier`, `ValueNotifier` y `setState`. Sin `provider`, `riverpod`, `bloc`, `getx` ni `get_it`.
- **Sin singletons globales**: las dependencias se construyen una vez y se pasan explícitamente.
- **Dependencias de terceros**: únicamente `sqflite` (persistencia), `path_provider` y `path` (rutas del sistema de archivos).
- **Sin red, sin autenticación, sin backend.**
- **Tipografía local**: Poppins e Inter en cuatro pesos cada una, empaquetadas en el repo.

## Puesta en marcha

Requisitos: Flutter `3.44.9` y Android SDK.

```bash
git clone https://github.com/xcaim04/ExRe.git
cd ExRe
flutter pub get
flutter run
```

Verificación local:

```bash
flutter analyze     # sin issues
flutter test        # 33 tests
```

## Arquitectura

Clean architecture con tres capas. Las dependencias apuntan hacia dentro: la capa `presentation` conoce a `domain`, `domain` no conoce a nadie.

```
lib/
├── main.dart                       # binding, ciclo de vida, carga inicial
├── app.dart                        # rutas nombradas y tema
│
├── core/                           # transversal
│   ├── constants/categories.dart   # las 6 categorías y sus colores
│   ├── di/injection.dart           # grafo manual de dependencias
│   ├── lifecycle/                  # puente Flutter -> dominio
│   └── theme/                      # color, tipografía, radios, espaciado
│
├── domain/                         # reglas de negocio, sin Flutter
│   ├── entities/                   # Resource, LifecycleEvent
│   ├── repositories/               # contrato abstracto
│   └── usecases/                   # 7 casos de uso
│
├── data/                           # persistencia
│   ├── datasources/                # sqflite + seed
│   ├── models/                     # mapeo a filas SQLite
│   └── repositories/               # implementación del contrato
│
└── presentation/                   # UI
    ├── screens/                    # las 6 pantallas + AppShell
    ├── state/app_state.dart        # AppState y AppStateScope
    └── widgets/                    # 11 componentes reutilizables
```

**Casos de uso** (uno por responsabilidad, todos con tipos explícitos):

| Caso de uso | Responsabilidad |
| ----------- | --------------- |
| `GetAllResources` | Listar todos los recursos. |
| `GetFavorites` | Listar solo los favoritos. |
| `SearchResources` | Búsqueda de texto en título, autor y descripción. |
| `FilterByCategory` | Filtro por categoría; `null` significa "sin filtro". |
| `ToggleFavorite` | Alterna favorito y **devuelve el nuevo estado**. |
| `ToggleCompleted` | Alterna completado y **devuelve el nuevo estado**. |
| `GetProgressStats` | Calcula porcentajes y desglose. Función pura. |

Que los toggles devuelvan el nuevo estado es lo que permite que la UI actualice de forma optimista y pueda revertir el cambio si la escritura en disco falla.

## Sistema de diseño

Todos los tokens viven en `lib/core/theme/`, sin valores mágicos dispersos por los widgets.

### Color

| Token | Valor | Uso |
| ----- | ----- | --- |
| `colorBg` | `#231C6B` | Fondo de la app. **Nunca blanco.** |
| `colorSurface` | `#2E2789` | Tarjetas y superficies elevadas. |
| `colorPrimary` | `#4F46E5` | Acción principal y estados activos. |
| `colorPrimarySoft` | `#3A32A0` | Variante presionada del primario. |
| `colorBorder` | `#443BA5` | Bordes de 1px. |
| `colorTextPrimary` | `#FFFFFF` | Títulos y cifras. |
| `colorTextSecondary` | `#C5BFEE` | Texto de apoyo. |
| `colorTextTertiary` | `#948CCB` | Metadatos y captions. |
| `colorSuccess` | `#16A34A` | Completado. |
| `colorWarning` | `#F59E0B` | Pendiente. |
| `colorDanger` | `#EF4444` | Destructivo. |
| `colorFavorite` | `#F43F5E` | Favorito. |

Cada categoría trae además su **color fuerte** y su **versión light** para el estado presionado.

| Categoría | Fuerte | Light |
| --------- | ------ | ----- |
| Flutter | `#0553B1` | `#54C5F8` |
| Android | `#1DA260` | — |
| Layouts | `#F59E0B` | — |
| Scrollables | `#DB2777` | — |
| Slivers | `#7C3AED` | `#C4B5FD` |
| Navegación | `#DC2626` | — |

### Tipografía

**Poppins** para display (22, 16), **Inter** para body (14, 12, 11), con pesos 400/500/600/700.

### Radios y espaciado

Regla de radios: **tarjetas 16**, **chips 20**, **accesos rápidos 18**, **botones 14**. El espaciado sigue una escala de 4.

## Navegación

Un solo mecanismo: `Navigator.pushNamed` sobre rutas registradas en `AppRoutes`. Sin `go_router` ni rutas anidadas. Las transiciones son instantáneas (`Duration.zero`) porque el diseño no define animaciones entre pantallas.

El Detalle admite dos formas de invocación, equivalentes:

```dart
// Por id en la ruta, con el id también en `arguments`
Navigator.pushNamed(context, AppRoutes.detailOf(id), arguments: id);

// Por ruta base
Navigator.pushNamed(context, AppRoutes.detail, arguments: id);
```

El generador de rutas normaliza con `AppRoutes.normalize()`, que colapsa `/detail/<id>` a `/detail`, de modo que ambas formas resuelven a la misma pantalla. El id viaja en `arguments`, y `AppRoutes.resourceIdFromRoute()` / `AppRoutes.resourceIdOf()` lo recuperan desde la ruta o desde los argumentos respectivamente.

## Estado

`AppState` es un único `ChangeNotifier` y la única fuente de verdad, expuesto mediante `AppStateScope` (un `InheritedNotifier`). Cubre:

- carga inicial, estado de error y reintento
- filtro por categoría, consulta de búsqueda y criterio de orden
- toggles optimistas de favorito y completado, con reversión si SQLite falla
- estadísticas de progreso, recalculadas en memoria
- log en memoria de los últimos **8** eventos de ciclo de vida

El filtrado y el orden se aplican sobre la lista ya cargada, sin volver a consultar la base, así que la UI responde al instante.

## Persistencia

`sqflite` con una base llamada `exre.db`. La tabla `resources` se crea con índices sobre `category`, `is_favorite` e `is_completed` en el primer arranque, y se siembra con **24 recursos** (4 por categoría).

- El **sembrado es único por proceso** y está protegido contra condiciones de carrera: si la base ya tiene filas, no se repite.
- Los toggles se resuelven con un `UPDATE` atómico que devuelve el estado resultante, en lugar de leer-modificar-escribir.
- Las búsquedas literales escapan `%`, `_` y `\` y usan `ESCAPE`, para que un usuario pueda buscar esos caracteres.
- El ciclo de vida **no** se persiste: es un log en memoria, tal como define la especificación.

## Testing

```
test/
├── helpers/fake_resource_repository.dart   # contrato completo sobre una lista
├── domain/
│   ├── toggle_favorite_test.dart           # alta, baja, aislamiento, id inexistente
│   └── get_progress_stats_test.dart        # porcentajes, tiempo y breakdown
└── presentation/
    ├── app_state_test.dart                 # filtros, búsqueda, ciclo de vida, notificaciones
    └── app_ui_test.dart                    # tokens del diseño y navegación
```

**33 tests** cubriendo la lógica de negocio, el estado y los tokens visuales. El smoke test de UI verifica la paleta completa, los radios, las familias tipográficas, que el fondo nunca es blanco, y que las cinco pestañas montan con la barra inferior.

Los tests no dependen de `sqflite`: `Injection.build()` acepta un repositorio alterno, así que las pruebas inyectan el fake y ejercitan la UI completa en memoria.

## Decisiones de diseño

- **Inyección manual en lugar de un service locator.** El grafo tiene nueve nodos; un `get_it` añadiría una dependencia sin aportar nada. Además permite sustituir el repositorio en tests sin tocar la app.
- **Barra de estado simulada.** El diseño especifica una barra propia con reloj, así que la app la dibuja en lugar de usar la del sistema. El reloj avanza con un `Timer.periodic`.
- **Portadas sin imágenes.** Cada recurso tiene un degradado determinista derivado de su id, así que la app no depende de assets binarios ni de red para verse completa.
- **Sin transiciones.** `PageRouteBuilder` con duraciones en cero, para no inventar animaciones que el diseño no especifica.
- **Toggles optimistas.** La UI responde al instante y el estado se revierte si la escritura falla; en este volumen de datos la latencia percibida importa más que la confirmación previa.

## Especificación

El proyecto se implementó a partir de estos archivos, incluidos en el repo:

| Archivo | Qué es |
| ------- | ------ |
| [`docs/prompt_exre_flutter.md`](docs/prompt_exre_flutter.md) | **El encargo original**: especificación funcional y visual, restricciones no negociables, tokens del diseño, estructura de carpetas, modelo de datos y plan de commits. |
| [`docs/AI_ASSISTED_DEVELOPMENT.md`](docs/AI_ASSISTED_DEVELOPMENT.md) | **El registro del proceso**: qué agente se usó, cómo se guió y qué queda sin verificar. |
| [`docs/App ExRE.pdf`](docs/App%20ExRE.pdf) | Mockup de referencia. |
| [`docs/Diseño.pen`](docs/Diseño.pen) | Archivo de diseño de pen.dev. |

Índice completo en [`docs/README.md`](docs/README.md).

## Licencia

MIT. Ver [LICENSE](LICENSE).

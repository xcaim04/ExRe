# ExRE — Explorador de Recursos de Estudio

App Flutter (Android) para explorar, filtrar, buscar, marcar como favorito y
completar recursos de estudio. Seis pantallas, cinco pestañas y persistencia
local en SQLite.

Implementada a partir de la especificación literal en `../prompt_exre_flutter.md`.

## Requisitos

- Flutter `3.44.9` / Dart `3.12.2` (no actualizar)
- Android SDK con Kotlin
- Sin servidor ni autenticación: todo es local

## Ejecución

```bash
flutter pub get
flutter run
```

## Verificación

```bash
flutter analyze     # sin issues
flutter test        # 28 tests
```

## Arquitectura

Clean architecture con tres capas y **solo el SDK de Flutter** para el estado
(`ChangeNotifier`, `InheritedNotifier`, `ValueNotifier`, `setState`). Sin
`provider`, `riverpod`, `bloc`, `get_it` ni singletons globales.

```
lib/
├── core/
│   ├── constants/categories.dart      # 6 categorías + sus colores
│   ├── di/injection.dart              # grafo manual de dependencias
│   ├── lifecycle/                     # AppLifecycleObserver
│   └── theme/                         # paleta, tipografía, radios, espaciados
├── domain/
│   ├── entities/                      # Resource, LifecycleEvent
│   ├── repositories/                  # contrato abstracto
│   └── usecases/                      # 7 casos de uso
├── data/
│   ├── datasources/                   # sqflite + seed de 24 recursos
│   ├── models/                        # ResourceModel
│   └── repositories/                  # implementación
├── presentation/
│   ├── screens/                       # 6 pantallas
│   ├── state/app_state.dart           # AppState + AppStateScope
│   └── widgets/                       # componentes base reutilizables
└── app.dart                           # rutas nombradas
```

### Navegación

Un solo mecanismo: `Navigator.pushNamed` con rutas registradas en `AppRoutes`.
Transiciones sin animación (`Duration.zero`), tal como define el diseño.

| Ruta        | Pantalla  | Contenido                        |
| ----------- | --------- | -------------------------------- |
| `/`         | Inicio    | saludo, accesos rápidos, categorías |
| `/catalog`  | Catálogo  | búsqueda, filtros, lista         |
| `/gallery`  | Galería   | rejilla de 2 columnas            |
| `/favorites`| Favoritos | `ListView.separated`             |
| `/progress` | Progreso  | porcentaje y breakdown           |
| `/detail`   | Detalle   | recurso + toggles                |

Las cinco pestañas comparten `AppShell` con `IndexedStack`, de modo que cambiar
de pestaña conserva el estado de cada una. El detalle recibe el id por
`arguments`.

## Estado

`AppState` (`ChangeNotifier`) es la única fuente de verdad:

- carga inicial, filtros por categoría, búsqueda y orden
- toggles **optimistas** de favorito y completado, con rollback si SQLite falla
- estadísticas de progreso calculadas en memoria por `GetProgressStats`
- log en memoria de los últimos 8 eventos de ciclo de vida

## Persistencia

`sqflite` con base `exre.db`. La tabla `resources` se crea y se siembra con
**24 recursos** (4 por cada una de las 6 categorías) la primera vez. El sembrado
está protegido contra condiciones de carrera y solo ocurre una vez por proceso.

## Recursos visuales

Los tokens del diseño están centralizados en `lib/core/theme/`:

- Fondo `#231C6B` en toda la app; nunca blanco
- Primario `#4F46E5`, superficie `#2E2789`, borde `#443BA5`
- Texto blanco / `#C5BFEE` / `#948CCB`
- Poppins 400-700 para display, Inter 400-700 para body (fuentes locales)
- Radios: tarjetas 16, chips 20, accesos rápidos 18, botones 14

## Tests

```
test/
├── helpers/fake_resource_repository.dart   # repositorio en memoria
├── domain/                                 # casos de uso y estadísticas
└── presentation/                           # AppState y smoke tests de UI
```

Los tests de UI inyectan el fake mediante `Injection.build(repository: ...)`,
por lo que no dependen de `sqflite`.

## Licencia

Proyecto de demostración.

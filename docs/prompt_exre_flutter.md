# Prompt: construir ExRE (Explorador de Recursos de Estudio) en Flutter

## Contexto del proyecto

Construir una app Flutter para Android llamada **ExRE**, para la asignatura
"Programación para Dispositivos Móviles". La app permite explorar recursos de
estudio (video, lectura, práctica, documento), filtrarlos por categoría,
buscarlos, marcarlos como favoritos, marcarlos como completados, y ver el
progreso general. 6 pantallas, navegación por BottomNavigation, sin servidor
ni autenticación.

**El diseño ya está hecho y aprobado. La prioridad es fidelidad visual
exacta — no "inspirado en", sino igual, pixel a pixel donde sea posible.**
Todos los valores de esta sección (colores, radios, paddings, tipografía)
son literales del archivo de diseño, no aproximaciones.

## Restricciones no negociables (funcionales)

- **Solo Flutter SDK** para manejo de estado. Nada de `provider`, `riverpod`,
  `bloc`, `get`, etc. Usar `ChangeNotifier` + `InheritedNotifier` (o
  `ValueNotifier`/`setState` donde alcance) — todos son parte del SDK.
- **Navegación:** un solo mecanismo, consistente en toda la app. Recomendado:
  `Navigator.pushNamed` con rutas nombradas (no requiere paquete extra). Si
  se usa `go_router`, no mezclar con `Navigator.push`.
- **Listas:** `ListView.builder` para catálogo/favoritos (tamaño variable),
  `ListView.separated` en Favoritos (separadores visuales), `itemExtent` si
  las alturas son homogéneas.
- **Grid:** `GridView.builder` en Galería, `SliverGridDelegateWithFixedCrossAxisCount`,
  `crossAxisCount: 2` mínimo, `crossAxisSpacing`/`mainAxisSpacing` definidos,
  `childAspectRatio` ajustado para que las tarjetas no se deformen.
- **Persistencia:** SQLite vía `sqflite` (único paquete externo de datos
  permitido; no es "estado" ni "servidor" — el enunciado prohíbe servidor y
  base de datos remota, no una base de datos local).

## Sistema de diseño — usar estos valores exactos

### Paleta de colores (crear como `AppColors` / `ThemeExtension`, no hardcodear en cada widget)

| Token | Hex | Uso |
|---|---|---|
| `colorPrimary` | `#4F46E5` | acciones principales, QuickAccessCard |
| `colorPrimarySoft` | `#3A32A0` | variante/hover del primario |
| `colorBg` | `#231C6B` | fondo general de la app (tema oscuro) |
| `colorSurface` | `#2E2789` | tarjetas, chips, status bar |
| `colorTextPrimary` | `#FFFFFF` | texto principal |
| `colorTextSecondary` | `#C5BFEE` | texto secundario |
| `colorTextTertiary` | `#948CCB` | texto terciario / iconos inactivos |
| `colorBorder` | `#443BA5` | bordes de tarjetas y chips (stroke width 1) |
| `colorSuccess` | `#16A34A` | estados positivos |
| `colorWarning` | `#F59E0B` | advertencias |
| `colorDanger` | `#EF4444` | errores/eliminar |
| `colorFavorite` | `#F43F5E` | ícono de favorito activo |

### Colores por categoría (fuertes y versión "light" para fondos suaves)

| Categoría | Color | Light |
|---|---|---|
| Flutter | `#0553B1` | `#54C5F8` |
| Android | `#1DA260` | `#4ADE80` |
| Layouts | `#F59E0B` | `#FCD34D` |
| Scrollables | `#DB2777` | `#F9A8D4` |
| Slivers | `#7C3AED` | `#C4B5FD` |
| Navegación | `#DC2626` | `#FCA5A5` |

Estos colores se usan de forma consistente en: el `Cover` de las tarjetas
(catálogo/galería), los puntos (`Dot`) del breakdown por categoría en
Progreso, y los chips de filtro seleccionados.

### Tipografía

- **Display** (títulos, valores grandes): `Poppins`
- **Body** (todo lo demás): `Inter`
- Pesos usados: `400` (normal), `500`, `600`, `700` — no usar otros pesos
  intermedios para mantener consistencia.

Agregar ambas fuentes a `pubspec.yaml` (Google Fonts o assets locales) antes
de tocar cualquier pantalla.

### Especificaciones exactas de componentes reutilizables

**StatusBar** — alto `62`, padding horizontal `20`, fondo `colorBg`,
`alignItems: center`, `justifyContent: space-between`. Hora en `Inter 15px
600` color `#FFFFFF`, iconos con gap `6`.

**TabItem / BottomNav** — layout vertical, gap `2`, centrado. Icono envuelto
en contenedor con `cornerRadius: 14`, `padding: 6`. Label `Inter 10px 500`
color `colorTextTertiary` (cambia a `colorPrimary`/blanco cuando el tab está
activo).

**ResourceListCard** (catálogo/favoritos) — ancho `358`, `cornerRadius: 16`,
`padding: 12`, `gap: 12`, `stroke: colorBorder` width `1`, `fill:
colorSurface`, `alignItems: center`. Cover `56x56`, `cornerRadius: 12`,
color de fondo = color de la categoría del recurso. Ícono de favorito `20x20`.

**ResourceGridCard** (galería) — ancho `171`, `cornerRadius: 16`, `stroke:
colorBorder`, `clip: true` (imprescindible para que el badge no se salga de
la tarjeta). Cover `height: 100`, color = categoría. Body con `padding: 10`,
`gap: 4`.

**CategoryChip** — `cornerRadius: 20` (pill), `padding: [8, 14]`, `stroke:
colorBorder`, `fill: colorSurface`. Label `Inter 12px 500` color
`colorTextSecondary`. Estado seleccionado: fondo = color de la categoría,
texto blanco.

**StatCard** — ancho mínimo `110` (`fill_container`), `cornerRadius: 16`,
`padding: 14`, `gap: 2`, `stroke: colorBorder`. Value en `Poppins 22px 700`
color `colorTextPrimary`. Label en `Inter 11px 400` color `colorTextSecondary`.

**QuickAccessCard** — ancho `170`, `cornerRadius: 18`, `padding: 16`, `gap:
20`, fondo `colorPrimary` (sólido, no la superficie). Label blanco `Inter
15px 600`.

**PrimaryButton** — ancho `fill_container` (máx `326`), `cornerRadius: 14`,
`padding: [14, 20]`, `gap: 8`, fondo **blanco** (`#FFFFFF`), ícono y label en
`colorPrimary`, `Inter 14px 600`.

**SecondaryButton** — mismas dimensiones que PrimaryButton, fondo
transparente, `stroke: #FFFFFF66` width `1`, ícono y label blancos.

> Regla general: todo `cornerRadius` de tarjetas grandes es `16`, de
> elementos pill/circulares (chips, quick access) es `18-20`, de botones es
> `14`. No inventar radios intermedios.

## Arquitectura limpia — estructura de carpetas

```
lib/
├── main.dart
├── app.dart                          # MaterialApp, rutas, tema
├── core/
│   ├── constants/                    # categorías, colores, textos fijos
│   ├── theme/                        # ThemeData con la paleta exacta de arriba
│   ├── lifecycle/                    # AppLifecycleObserver (WidgetsBindingObserver)
│   └── di/                           # injection.dart — instanciación manual de repos/usecases
├── data/
│   ├── datasources/
│   │   ├── seed_resources.dart       # 20+ recursos de prueba (fuente local original)
│   │   └── resource_local_datasource.dart  # sqflite: CRUD + queries
│   ├── models/
│   │   └── resource_model.dart       # fromMap/toMap, extiende la entidad
│   └── repositories/
│       └── resource_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── resource.dart
│   │   └── lifecycle_event.dart
│   ├── repositories/
│   │   └── resource_repository.dart  # abstracto
│   └── usecases/
│       ├── get_all_resources.dart
│       ├── search_resources.dart
│       ├── filter_by_category.dart
│       ├── toggle_favorite.dart
│       ├── toggle_completed.dart
│       └── get_progress_stats.dart
└── presentation/
    ├── state/
    │   └── app_state.dart            # ChangeNotifier central: recursos, filtros, búsqueda, lifecycle
    ├── screens/
    │   ├── home_screen.dart
    │   ├── catalog_screen.dart
    │   ├── gallery_screen.dart
    │   ├── detail_screen.dart
    │   ├── favorites_screen.dart
    │   └── progress_screen.dart
    └── widgets/
        ├── resource_list_card.dart
        ├── resource_grid_card.dart
        ├── category_chip.dart
        ├── stat_card.dart
        ├── quick_access_card.dart
        └── app_bottom_nav.dart
```

## Modelo de datos (SQLite)

Una sola tabla `resources` es suficiente:

```sql
CREATE TABLE resources (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  category TEXT NOT NULL,
  author TEXT NOT NULL,
  duration_minutes INTEGER NOT NULL,
  level TEXT NOT NULL,              -- basico | intermedio | avanzado
  description TEXT NOT NULL,
  type TEXT NOT NULL,               -- video | lectura | practica | documento
  cover_color TEXT,
  is_favorite INTEGER NOT NULL DEFAULT 0,
  is_completed INTEGER NOT NULL DEFAULT 0
);
```

Estrategia: en el primer arranque (`COUNT(*) == 0`), sembrar la tabla desde
`seed_resources.dart`. A partir de ahí, toda la app lee/escribe de SQLite —
así "los datos provienen de un archivo local" (el seed) y a la vez persisten
los cambios de favorito/completado entre sesiones.

El historial de ciclo de vida no necesita tabla: se guarda en memoria (una
`List<LifecycleEvent>` en `app_state.dart`) — el enunciado solo pide
"observado desde Flutter" en tiempo real, no persistencia de logs.

## Checklist de fidelidad visual (revisar pantalla por pantalla antes de dar por terminada cada una)

- [ ] Fondo `colorBg` (`#231C6B`) en todas las pantallas, nunca blanco.
- [ ] Ningún color hardcodeado fuera del archivo de tema — todo sale de
      `AppColors`.
- [ ] Radios, paddings y gaps coinciden con la tabla de especificaciones,
      no valores "parecidos".
- [ ] Los colores de categoría son siempre los mismos 6 tokens, usados
      igual en tarjetas, chips y breakdown de progreso.
- [ ] Tipografía: títulos/valores grandes en Poppins, todo lo demás en Inter.
- [ ] BottomNavigation presente en Inicio/Catálogo/Galería/Favoritos/Progreso,
      **ausente** en Detalle (se llega por push, se vuelve con botón).

## Listado de commits

Usar Conventional Commits (`feat`, `fix`, `chore`, `docs`, `refactor`). Cada
commit debe compilar y correr — no dejar commits rotos.

```
1.  chore: inicializar proyecto Flutter y estructura de carpetas (clean architecture)
2.  chore: agregar dependencia sqflite y path_provider
3.  feat(core): definir tema, paleta de colores exacta y tipografía (Poppins/Inter)
4.  feat(domain): crear entidades Resource y LifecycleEvent
5.  feat(domain): definir ResourceRepository abstracto y casos de uso
6.  feat(data): crear ResourceModel con fromMap/toMap
7.  feat(data): implementar ResourceLocalDataSource con sqflite (CRUD)
8.  feat(data): crear seed de 20 recursos de prueba
9.  feat(data): implementar ResourceRepositoryImpl con sembrado inicial
10. feat(core): implementar AppLifecycleObserver (WidgetsBindingObserver)
11. feat(state): crear AppState (ChangeNotifier) — carga inicial, filtros, búsqueda
12. feat(navigation): configurar rutas nombradas y esqueleto de las 6 pantallas
13. feat(ui): implementar BottomNavigation y componentes base (chips, stat card, botones)
14. feat(home): implementar pantalla de Inicio (stats, lifecycle, accesos rápidos)
15. feat(catalog): implementar pantalla de Catálogo (búsqueda, filtro, ListView.builder)
16. feat(gallery): implementar pantalla de Galería (GridView.builder, 2 columnas)
17. feat(detail): implementar pantalla de Detalle (toggle favorito/completado)
18. feat(favorites): implementar pantalla de Favoritos (ListView.separated, estado vacío)
19. feat(progress): implementar pantalla de Progreso (% general, breakdown por categoría)
20. feat(state): conectar toggle de favorito/completado con actualización inmediata en todas las pantallas
21. fix(ui): pulido de fidelidad visual — verificar checklist de diseño en las 6 pantallas
22. fix(ui): revisar overflow en pantallas pequeñas (SafeArea, scroll, Expanded/Flexible)
23. test: pruebas básicas de casos de uso (toggle favorite, filtro por categoría)
24. docs: escribir README con instrucciones de ejecución
25. docs: agregar capturas de pantalla de las 6 pantallas
26. chore: revisión final — limpieza de código, nombres, comentarios
```

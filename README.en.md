# ExRE

**Educational Resource Explorer** — a Flutter app for Android to browse, filter, search, favorite and complete study resources. Six screens, five tabs, local SQLite persistence and zero network dependencies.

Built from a literal design specification, with the palette, typography, corner radii and metrics reproduced down to the token. The specification and reference files live in [`docs/`](docs/).

[![CI](https://github.com/xcaim04/ExRe/actions/workflows/ci.yml/badge.svg)](https://github.com/xcaim04/ExRe/actions/workflows/ci.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.44.9-02569A?logo=flutter&logoColor=white)](https://docs.flutter.dev/release/release-notes/release-notes-3.44.9)
[![Dart](https://img.shields.io/badge/Dart-3.12.2-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

> 🇪🇸 [Versión en español](README.md)

---

## Authorship

This project was **developed with the help of an AI agent**.

| | |
| --- | --- |
| **Tool** | [opencode](https://opencode.ai) — an interactive coding agent that runs in your terminal |
| **Model** | `big-pickle` (ID: `opencode/big-pickle`) |
| **Sub-agents** | None. All the work was done in a single session. |
| **Specification** | Written by a person, before any code was generated |

### The starting point was a brief, not an open-ended request

The work did not begin with a sketch, but with a **249-line specification** written by a person, which fixes the six screens, the literal design-system values, the folder structure, the data schema, the stack constraints and the commit plan. That document is [`docs/prompt_exre_flutter.md`](docs/prompt_exre_flutter.md) and is included in the repository.

### The split of labour, without ambiguity

- **The specification, the design and the decisions are human.** The agent did not pick the stack, propose the palette, set the architecture or decide the data schema — all of that was already written down.
- **The code was written by the agent**, following that specification to the letter.
- **Review and publication are human.** Whoever maintains the repository decides what ships, what gets dropped and what gets fixed, and is the one who supplies the publishing credentials.

### How the work was guided

This was not a series of loose requests, but a closed and auditable brief. The concrete practices, with the evidence behind each:

1. **Specification before code.** A closed 249-line document, not an open conversation.
2. **Explicit, verifiable constraints.** A "non-negotiable constraints" section you can check by reading `pubspec.yaml`.
3. **Literal design values**, with an explicit instruction never to hardcode anything outside the theme file.
4. **A definition of done screen by screen**, via a visual-fidelity checklist.
5. **A commit plan up front**, with the rule that no commit is left broken.
6. **Human approval before implementation.**
7. **Visible tracking** through a task list kept up to date.
8. **Escalating instead of assuming** when facing ambiguous or irreversible decisions.

The result was not accepted on first impressions, but against automatic verification gates: `dart format`, `flutter analyze` with no issues, `flutter test` with 33 passing tests, and a CI workflow that runs them on every push. The suite does not depend on `sqflite`: `Injection.build()` accepts an alternative repository, so the tests exercise the entire UI in memory.

### What is not verified

- **The app has not yet been run on a physical device.** As of writing this README, `flutter analyze` is clean and all 33 tests pass, but there is not a single real screenshot: running it on a Samsung Galaxy A16 running Android 15, and checking the fidelity checklist against the reference PDF, are still pending.
- The fidelity checklist was applied **while writing the code**, but it was **never verified on screen**.
- The history has **39 commits against the 26 in the plan**: it is a superset, not a literal match. The Conventional Commits format was respected.

The full detail on all of this is in **[`docs/AI_ASSISTED_DEVELOPMENT.md`](docs/AI_ASSISTED_DEVELOPMENT.md)**, which includes this same section of limits.

---

## Contents

- [What it does](#what-it-does)
- [Authorship](#authorship)
- [The six screens](#the-six-screens)
- [Stack and constraints](#stack-and-constraints)
- [Getting started](#getting-started)
- [Architecture](#architecture)
- [Design system](#design-system)
- [Navigation](#navigation)
- [State](#state)
- [Persistence](#persistence)
- [Testing](#testing)
- [Design decisions](#design-decisions)
- [Specification](#specification)
- [License](#license)

---

## What it does

- **Browse** 24 locally seeded resources spread across 6 Flutter categories.
- **Filter** by category, search by text across title, author and description, and sort by title or duration.
- **Save** favorites and mark resources as completed, with optimistic writes and automatic rollback if SQLite fails.
- **Track** progress with an overall percentage, a time-based percentage and a per-category breakdown.
- **Persist** everything in a local SQLite database: the app works with no server, no account and no connection.

## The six screens

| Screen      | Route       | Contents |
| ----------- | ----------- | -------- |
| **Home**      | `/`         | Greeting, quick access tiles with a progress badge, and a horizontal strip of all 6 categories. |
| **Catalog**   | `/catalog`  | Search field, filter bar, `ListView.builder` list and an empty state. |
| **Gallery**   | `/gallery`  | Two-column `GridView.builder` grid. |
| **Favorites** | `/favorites`| Separated `ListView.separated` list with an empty state. |
| **Progress**  | `/progress`  | Overall progress ring, four metric cards and a per-category breakdown. |
| **Detail**    | `/detail`   | Full-bleed cover, metadata, description, and the favorite and completed toggles. |

The five tabs share a single `AppShell` backed by an `IndexedStack`, so switching tabs **preserves each screen's state and scroll position**.

## Stack and constraints

- **Flutter 3.44.9 / Dart 3.12.2** (pinned; the project does not upgrade the SDK).
- **Android** with Kotlin. `namespace` and `applicationId`: `com.exre.exre`.
- **State using only the SDK**: `ChangeNotifier`, `InheritedNotifier`, `ValueNotifier` and `setState`. No `provider`, `riverpod`, `bloc`, `getx` or `get_it`.
- **No global singletons**: dependencies are built once and passed explicitly.
- **Third-party dependencies**: only `sqflite` (persistence), `path_provider` and `path` (filesystem paths).
- **No network, no authentication, no backend.**
- **Local typography**: Poppins and Inter in four weights each, committed to the repository.

## Getting started

Requirements: Flutter `3.44.9` and the Android SDK.

```bash
git clone https://github.com/xcaim04/ExRe.git
cd ExRe
flutter pub get
flutter run
```

Local verification:

```bash
flutter analyze     # no issues
flutter test        # 33 tests
```

## Architecture

Clean architecture with three layers. Dependencies point inward: `presentation` knows about `domain`, and `domain` knows about nothing.

```
lib/
├── main.dart                       # binding, lifecycle, initial load
├── app.dart                        # named routes and theme
│
├── core/                           # cross-cutting
│   ├── constants/categories.dart   # the 6 categories and their colors
│   ├── di/injection.dart           # manual dependency graph
│   ├── lifecycle/                  # Flutter -> domain bridge
│   └── theme/                      # color, typography, radii, spacing
│
├── domain/                         # business rules, Flutter-free
│   ├── entities/                   # Resource, LifecycleEvent
│   ├── repositories/               # abstract contract
│   └── usecases/                   # 7 use cases
│
├── data/                           # persistence
│   ├── datasources/                # sqflite + seed
│   ├── models/                     # mapping to SQLite rows
│   └── repositories/               # contract implementation
│
└── presentation/                   # UI
    ├── screens/                    # the 6 screens + AppShell
    ├── state/app_state.dart        # AppState and AppStateScope
    └── widgets/                    # 11 reusable components
```

**Use cases** (one responsibility each, all with explicit types):

| Use case | Responsibility |
| -------- | -------------- |
| `GetAllResources` | List every resource. |
| `GetFavorites` | List only the favorites. |
| `SearchResources` | Free-text search over title, author and description. |
| `FilterByCategory` | Filter by category; `null` means "no filter". |
| `ToggleFavorite` | Toggles favorite and **returns the new state**. |
| `ToggleCompleted` | Toggles completed and **returns the new state**. |
| `GetProgressStats` | Computes percentages and the breakdown. Pure function. |

Having the toggles return the new state is what lets the UI update optimistically and roll the change back if the disk write fails.

## Design system

Every token lives in `lib/core/theme/`, with no magic values scattered across widgets.

### Color

| Token | Value | Use |
| ----- | ----- | --- |
| `colorBg` | `#231C6B` | App background. **Never white.** |
| `colorSurface` | `#2E2789` | Cards and elevated surfaces. |
| `colorPrimary` | `#4F46E5` | Primary action and active states. |
| `colorPrimarySoft` | `#3A32A0` | Pressed variant of the primary. |
| `colorBorder` | `#443BA5` | 1px borders. |
| `colorTextPrimary` | `#FFFFFF` | Headings and figures. |
| `colorTextSecondary` | `#C5BFEE` | Supporting text. |
| `colorTextTertiary` | `#948CCB` | Metadata and captions. |
| `colorSuccess` | `#16A34A` | Completed. |
| `colorWarning` | `#F59E0B` | Pending. |
| `colorDanger` | `#EF4444` | Destructive. |
| `colorFavorite` | `#F43F5E` | Favorite. |

Each category additionally carries its own **strong color** and a **light variant** used for the pressed state.

| Category | Strong | Light |
| -------- | ------ | ----- |
| Flutter | `#0553B1` | `#54C5F8` |
| Android | `#1DA260` | — |
| Layouts | `#F59E0B` | — |
| Scrollables | `#DB2777` | — |
| Slivers | `#7C3AED` | `#C4B5FD` |
| Navigation | `#DC2626` | — |

### Typography

**Poppins** for display (22, 16), **Inter** for body (14, 12, 11), with weights 400/500/600/700.

### Radii and spacing

Radius rule: **cards 16**, **chips 20**, **quick access tiles 18**, **buttons 14**. Spacing follows a scale of 4.

## Navigation

A single mechanism: `Navigator.pushNamed` over routes registered in `AppRoutes`. No `go_router` and no nested routes. Transitions are instant (`Duration.zero`) because the design does not specify animations between screens.

Detail can be reached two equivalent ways:

```dart
// Id in the route, with the id also passed via `arguments`
Navigator.pushNamed(context, AppRoutes.detailOf(id), arguments: id);

// Via the base route
Navigator.pushNamed(context, AppRoutes.detail, arguments: id);
```

The route generator normalizes with `AppRoutes.normalize()`, collapsing `/detail/<id>` to `/detail` so both forms resolve to the same screen. The id travels in `arguments`, and `AppRoutes.resourceIdFromRoute()` / `AppRoutes.resourceIdOf()` recover it from the route or from the arguments respectively.

## State

`AppState` is a single `ChangeNotifier` and the single source of truth, exposed through `AppStateScope` (an `InheritedNotifier`). It covers:

- initial load, error state and retry
- category filter, search query and sort criteria
- optimistic favorite and completed toggles, with rollback if SQLite fails
- progress statistics, recomputed in memory
- an in-memory log of the last **8** lifecycle events

Filtering and sorting are applied to the already-loaded list without going back to the database, so the UI responds instantly.

## Persistence

`sqflite` with a database called `exre.db`. The `resources` table is created with indexes on `category`, `is_favorite` and `is_completed` on first launch, and is seeded with **24 resources** (4 per category).

- **Seeding runs once per process** and is guarded against race conditions: if the table already has rows, it is skipped.
- Toggles resolve through a single atomic `UPDATE` that returns the resulting state, rather than a read-modify-write.
- Literal searches escape `%`, `_` and `\` and use `ESCAPE`, so a user can actually search for those characters.
- The lifecycle log is **not** persisted: it is an in-memory log, exactly as the specification requires.

## Testing

```
test/
├── helpers/fake_resource_repository.dart   # full contract over a list
├── domain/
│   ├── toggle_favorite_test.dart           # set, unset, isolation, unknown id
│   └── get_progress_stats_test.dart        # percentages, time, breakdown
└── presentation/
    ├── app_state_test.dart                 # filters, search, lifecycle, notifications
    └── app_ui_test.dart                    # design tokens and navigation
```

**33 tests** covering the business logic, the state layer and the visual tokens. The UI smoke test asserts the full palette, the radii, the type families, that the background is never white, and that all five tabs mount with the bottom navigation.

The tests do not depend on `sqflite`: `Injection.build()` accepts an alternative repository, so the tests inject the fake and exercise the whole UI in memory.

## Design decisions

- **Manual injection instead of a service locator.** The graph has nine nodes; `get_it` would add a dependency without buying anything. It also makes it possible to swap the repository in tests without touching the app.
- **Simulated status bar.** The design specifies its own bar with a clock, so the app draws it instead of using the system one. The clock advances with a `Timer.periodic`.
- **Covers without images.** Each resource gets a deterministic gradient derived from its id, so the app looks complete without depending on binary assets or on the network.
- **No transitions.** `PageRouteBuilder` with zero durations, rather than inventing animations the design does not specify.
- **Optimistic toggles.** The UI responds instantly and the state rolls back if the write fails; at this data volume, perceived latency matters more than confirming first.

## Specification

The project was implemented from these files, all included in the repository:

| File | What it is |
| ---- | ---------- |
| [`docs/prompt_exre_flutter.md`](docs/prompt_exre_flutter.md) | **The original brief**: functional and visual specification, non-negotiable constraints, design tokens, folder structure, data model and commit plan. |
| [`docs/AI_ASSISTED_DEVELOPMENT.md`](docs/AI_ASSISTED_DEVELOPMENT.md) | **The process record**: which agent was used, how it was guided and what is still unverified. |
| [`docs/App ExRE.pdf`](docs/App%20ExRE.pdf) | Reference mockup. |
| [`docs/Diseño.pen`](docs/Diseño.pen) | pen.dev design file. |

Full index in [`docs/README.md`](docs/README.md).

## License

MIT. See [LICENSE](LICENSE).

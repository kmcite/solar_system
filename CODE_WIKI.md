# Solar System — Code Wiki

## Overview

This repository is a Flutter (Dart) cross-platform app/game. The gameplay loop models a small solar power system:

- A **day/night radiation cycle** produces a radiation multiplier.
- **Solar panels** generate watts based on radiation.
- **Loads** consume power and generate **revenue per second**.
- **Upgrades** improve inverter/battery capabilities.
- **Utility power** can be purchased as a fallback source.

State is managed with a mix of:

- `ChangeNotifier`-based singletons (custom `Notifier<T>` and plain `ChangeNotifier` classes)
- `signals` / `signals_flutter` (global `signal(...)` and `computed(...)` values + `Watch` widget)

## Repository Layout

```
lib/
  main.dart                       App entrypoint; builds MaterialApp
  business/                       Game state, timers, and progression logic
  screens/                        UI sections for each gameplay subsystem
  domain/models/                  Simple data models + catalogs
  utils/                          Shared widgets + reactive helpers + styling
android/ ios/ macos/ linux/ windows/ web/   Flutter platform runners
pubspec.yaml                      Dart/Flutter dependencies
analysis_options.yaml             Analyzer/lint configuration
```

## How The App Boots

- Entrypoint: [main.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/main.dart#L10-L28)
  - Builds `MaterialApp` with:
    - `navigatorKey` from [navigator.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/navigator.dart#L5-L21)
    - theme mode driven by the `dark` notifier from [dark.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/dark.dart#L3-L12)
    - `home: gameScreen()` from [game_screen.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/screens/game_screen.dart#L17-L61)
  - Note: timer-based services and effect wiring are currently commented out in [main.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/main.dart#L29-L53) (radiation, battery discharge, and signal-to-signal effects).

- Main screen composition: [game_screen.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/screens/game_screen.dart#L17-L61)
  - A single `Scaffold` with a `ListView` that renders each gameplay section (HUD, day/night, inverter, solar farm, battery, loads, upgrades, utility).

## Architecture (Logical Layers)

### 1) UI Layer (`lib/screens`)

The UI is built from small “section” widgets that read and mutate global state in `lib/business`.

Key sections:

- [hud_bar.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/screens/hud_bar.dart#L12-L58): money, revenue rate, solar output, battery %
- [day_night_cycle_section.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/screens/day_night_cycle_section.dart): cycle progress and labels
- [solar_farm_section.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/screens/solar_farm_section.dart#L9-L114): buy/toggle panels
- [loads_section.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/screens/loads_section.dart#L9-L124): buy/toggle loads using a catalog
- [battery_section.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/screens/battery_section.dart): battery status and upgrades
- [inverter_section.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/screens/inverter_section.dart): inverter control + stats
- [inverter_upgrades_section.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/screens/inverter_upgrades_section.dart): upgrade purchase UI
- [utility_section.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/screens/utility_section.dart#L10-L154): buy utility time and toggle connection
- [settings_dialog.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/screens/settings_dialog.dart): dark mode and cycle duration configuration

Reactive rebuilding patterns used by the UI:

- `listenTo([...], builder)` from [builder.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/utils/builder.dart#L3-L12) (wraps `ListenableBuilder` and `Listenable.merge`)
- `Watch((context) => ...)` from `signals_flutter` (example: [LoadsSection](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/screens/loads_section.dart#L14-L109))

### 2) Business / State Layer (`lib/business`)

This layer holds global singletons and global signals that represent game state. In general:

- `ChangeNotifier` instances are exported as top-level globals (`final money = ...; final panels = ...;`)
- `signals` state is exported as top-level `signal(...)` and `computed(...)` values
- “Systems” run via `Timer.periodic` loops (radiation/revenue/battery discharge/utility simulation)

### 3) Domain Model Layer (`lib/domain/models`)

Contains small models and catalogs that the business layer and UI consume:

- Load types marketplace catalog: `loadTypeCatalog` in [models.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/domain/models/models.dart#L21-L58)
- Panel model: `PanelModel` in [models.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/domain/models/models.dart#L86-L117)

### 4) Shared Utilities (`lib/utils`)

Cross-cutting utilities:

- `Notifier<T>`: small `ChangeNotifier` wrapper used as a mutable observable value ([notifier.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/utils/notifier.dart#L3-L27))
- `listenTo(...)`: merges multiple `Listenable`s to rebuild UI ([builder.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/utils/builder.dart#L3-L12))
- Styling helpers and UI components: [ui_helpers.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/utils/ui_helpers.dart), [glass_card.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/utils/glass_card.dart), [animated_gauge.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/utils/animated_gauge.dart)

## Major Modules (Responsibilities + Key APIs)

### `business/app.dart` (App Index State)

- `index`: global `Notifier<int>` used by some widgets to rebuild ([app.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/app.dart#L3-L10))
- `IndexNotifier.onIndexChanged(int)` sets the index

### `business/dark.dart` (Theme State)

- `dark`: global `Notifier<bool>` controlling dark mode ([dark.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/dark.dart#L3-L12))
- `toggleDark()` switches theme mode

### `business/navigator.dart` (Navigation Utility)

Utilities wrapping `NavigatorState`:

- `navigatorKey` ([navigator.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/navigator.dart#L5))
- `navigateTo(WidgetBuilder)`
- `navigateToDialog(WidgetBuilder)` (uses `showDialog`)
- `navigateBack()`

### `business/money.dart` (Currency)

- Global singleton: `money` ([money.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/money.dart#L3-L12))
- `MoneyNotifier` (extends `Notifier<num>`)
  - `credit(double)` / `debit(double)`
  - starts with `100000` currency units

### `business/radiation.dart` (Day/Night Cycle + Radiation Multiplier)

Signals-based time and radiation simulation:

- State signals: `radiation`, `cycleDuration`, `elapsedSeconds`, `dayProgress` ([radiation.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/radiation.dart#L7-L11))
- Computeds:
  - `currentTimeOfDay`, `timeOfDayLabel`, `cycleProgressPercent`, `timeUntilNextPhase` ([radiation.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/radiation.dart#L25-L82))
- Timer loop:
  - `startRadiation()` updates `dayProgress` and `radiation` once per second ([radiation.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/radiation.dart#L94-L131))
  - `configureRadiationCycle(int duration)` resets to a new cycle duration ([radiation.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/radiation.dart#L138-L145))

### `business/panels.dart` (Solar Panel Inventory + Output)

`ChangeNotifier`-based list of panels:

- Global singleton: `panels` ([panels.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/panels.dart#L4-L58))
- State:
  - `List<PanelModel> panels`
  - `panelRadiation` (used when computing `currentPowerOutput`)
- Aggregates:
  - `ratedMaxCapacity`, `currentMaxCapacity`, `currentPowerOutput` ([panels.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/panels.dart#L9-L22))
- Mutations:
  - `createPanel()`, `togglePanelActivation(PanelModel)`, `removePanel(int)`, `setPanelRadiation(double)`

### `business/loads.dart` (Loads + Revenue Sources)

Signals-based load list and computed totals:

- `loads`: `signal<List<Load>>([])` ([loads.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/loads.dart#L44-L45))
- Computeds:
  - `totalLoads`, `totalActiveLoads`, `totalActiveRevenue` ([loads.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/loads.dart#L49-L65))
- Actions:
  - `purchaseLoad(String loadTypeId)` (uses `loadTypeCatalog`) ([loads.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/loads.dart#L75-L87))
  - `toggleLoad(int id)`, `removeLoad(int id)`, `clearAllLoads()`

### `business/inverter.dart` (Inverter On/Off)

Signals representing inverter state:

- `inverterStatus` and additional inverter signals ([inverter.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/inverter.dart#L6-L13))
- Actions:
  - `toggleInverter()`, `turnInverterOn()`, `turnInverterOff()` ([inverter.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/inverter.dart#L17-L26))

### `business/revenue.dart` (Per-Second Income)

`ChangeNotifier` that periodically credits money:

- Global singleton: `revenue` ([revenue.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/revenue.dart#L7-L56))
- Behavior:
  - Constructor calls `startRevenue()` immediately ([revenue.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/revenue.dart#L14-L18))
  - Every second `_tickRevenue()`:
    - Checks `inverterStatus`
    - Reads `loads.totalActiveRevenue`
    - Credits `money.credit(revenue)` ([revenue.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/revenue.dart#L37-L51))

### `business/inverter_upgrades.dart` (Inverter Upgrade Tree + Output Helper)

Signals-based upgrade progression:

- `InverterUpgrade` model and `inverterTree` constant ([inverter_upgrades.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/inverter_upgrades.dart#L38-L192))
- Signals:
  - `currentInverterUpgrade`
  - `nextInverterUpgrade` computed ([inverter_upgrades.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/inverter_upgrades.dart#L197-L212))
- Actions:
  - `purchaseInverterUpgrade(String id)` ([inverter_upgrades.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/inverter_upgrades.dart#L217-L223))
- Helper:
  - `calculateOutput({required double radiation, required InverterUpgrade inv})` ([inverter_upgrades.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/inverter_upgrades.dart#L233-L246))

### `business/battery.dart` (Battery Simulation)

This file contains both:

- An older `ChangeNotifier`-style `BatteryNotifier` (with `charge(num power)`) ([battery.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/battery.dart#L50-L67))
- A newer `signals`-based battery simulation (used by UI such as HUD percent and battery section):
  - State signals: `energyInWattHours`, `maxCapacity`, `tierName`, `chargeMultiplier`, `cycles`, `batteryVoltage`, `isCharging` ([battery.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/battery.dart#L72-L79))
  - Actions:
    - `updateBatteryRadiation(double)` (charges based on radiation)
    - `dischargeBattery()`, `startBatteryDischarge()`
    - `applyBatteryUpgrade(...)` (updates battery tier stats in a `batch(...)`) ([battery.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/battery.dart#L129-L148))

### `business/battery_upgrades.dart` (Battery Upgrade Tree)

Upgrade progression for the battery:

- `BatteryUpgrade` model + `batteryUpgradeTree` constant ([battery_upgrades.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/battery_upgrades.dart#L7-L220))
- The remainder of the file defines:
  - selection signals (current/next)
  - purchase actions and helpers

### `business/utility.dart` (Utility Power)

This file currently includes two separate state systems:

1) `UtilityNotifier` (`ChangeNotifier`) exposed as `final utility = UtilityNotifier()` ([utility.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/utility.dart#L6-L54))
2) A signals-based time purchase + simulation system:
   - `purchaseUtility(double amount)` adds seconds and starts countdown if needed ([utility.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/utility.dart#L95-L107))
   - `utilityVoltage`, `utilityCurrent`, `utilityRemainingSeconds` signals and `utilityPower` computed ([utility.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/utility.dart#L59-L70))

The UI in [utility_section.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/screens/utility_section.dart#L10-L154) currently renders using the `UtilityNotifier` fields while purchases call the signals-based `purchaseUtility(...)`.

## Internal Dependencies (Who Uses What)

### External Packages

From [pubspec.yaml](file:///c:/Users/Adn/Desktop/projects/solar_system/pubspec.yaml#L5-L16):

- `flutter` (framework)
- `signals` and `signals_flutter` (reactive primitives + Flutter widgets)
- `faker` (random value generation, used in utility simulation)
- `font_awesome_flutter`, `cupertino_icons` (icons)
- `uuid` (present; not currently referenced in `lib/`)

### In-Repo Dependency Map (High Level)

- UI layer (`lib/screens/*`)
  - depends on business state (`lib/business/*`) and shared UI utilities (`lib/utils/*`)
  - some screens also use domain catalogs (`lib/domain/models/*`)

- Business layer (`lib/business/*`)
  - depends on domain models:
    - panels → [models.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/domain/models/models.dart#L86-L117)
    - loads → [models.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/domain/models/models.dart#L21-L58)
  - cross-module dependencies:
    - revenue → money + loads + inverter ([revenue.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/business/revenue.dart#L1-L56))

## Running The Project

### Prerequisites

- Install Flutter SDK (Dart SDK comes with it).
- Ensure platform toolchains are available for your target:
  - Android: Android Studio + SDKs
  - iOS/macOS: Xcode (macOS only)
  - Web: Chrome installed
  - Windows/Linux: desktop build prerequisites per Flutter docs

### Install Dependencies

From the repo root:

```bash
flutter pub get
```

### Run (Development)

```bash
flutter run
```

Common targets:

```bash
flutter run -d chrome
flutter run -d windows
flutter run -d android
```

### Build (Release)

```bash
flutter build apk
flutter build web
flutter build windows
```

### Analyze, Test, Format

```bash
flutter analyze
flutter test
dart format .
```

Lint rules and analyzer settings live in [analysis_options.yaml](file:///c:/Users/Adn/Desktop/projects/solar_system/analysis_options.yaml#L1-L13).

## Dev Notes / Current Wiring

- Timer-based systems (`startRadiation`, `startBatteryDischarge`) are defined but not started from `main()` because the calls are commented out ([main.dart](file:///c:/Users/Adn/Desktop/projects/solar_system/lib/main.dart#L29-L53)).
- Several screens read signals/notifiers but only rebuild on a subset of listenables; if UI does not update as expected, check which listenables/signals drive the rebuild for that widget (`listenTo(...)` vs `Watch`).
- `utility.dart` contains two different implementations (notifier-based vs signals-based), and the current UI uses fields from the notifier while purchases call the signals action.


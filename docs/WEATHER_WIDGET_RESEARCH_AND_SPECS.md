# Weather Widget Research, Architecture & macOS HIG Specs

## 1. Executive Summary & Apple HIG Principles
Apple's official Human Interface Guidelines (HIG) and WidgetKit documentation specify three non-negotiable pillars for desktop and home screen widgets:
1. **Glanceable:** Content must be absorbed in under 3 seconds without interaction.
2. **Contextual & Adaptive:** macOS Sonoma/Sequoia desktop widgets automatically tint or become monochromatic when a window is active. Widgets must use multi-layered rendering and `.ultraThinMaterial` glassmorphism to look native.
3. **Snapshot-Based:** Widgets are not mini-apps running 60 FPS loops.

---

## 2. The Sparring Check: The "Widget Animation Trap"

```
[ THE COMMON INTUITION TRAP ]
"Let's put a continuous 60 FPS rain / sun-spin animation loop inside the widget."
                       |
                       v
[ REALITY: Apple WidgetKit Architecture ]
- Widgets DO NOT run live render loops.
- Widgets are static image snapshots rendered by `TimelineProvider`.
- Attempting continuous animations:
  * Apple limits animation durations to <= 2 seconds.
  * Rapid timeline reloads exhaust the OS daily reload budget.
  * macOS throttles and freezes background widget execution to protect battery.

[ THE APPLE-NATIVE SOLUTION ]
Use system-level transitions:
+ Text(date, style: .timer) / .relative
+ .contentTransition(.numericText()) for temperature shifts
+ Multi-color SF Symbols with dynamic hierarchical opacity
+ Pre-baked timeline entry steps (e.g. 1 hour increments)
```

---

## 3. System Architecture & Subsystem Independence

```
+-------------------------------------------------------------+
|                      WidgetCraft                            |
+-------------------------------------------------------------+
                              |
        +---------------------+---------------------+
        |                                           |
        v                                           v
+-------------------------------+   +-------------------------------+
|         Global/               |   |   Subsystems/WeatherWidget/   |
| - DesignSystem/Typography     |   | - Models/WeatherModel.swift   |
| - DesignSystem/Themes         |   | - Provider/WeatherTimeline... |
| - Shared Utilities            |   | - Views/WeatherWidgetView     |
|                               |   | - WeatherWidget.swift         |
+-------------------------------+   +-------------------------------+
        ^                                           |
        | Uses strictly for typography/themes       |
        +-------------------------------------------+
        (WeatherWidget can be deleted without breaking other widgets)
```

---

## 4. Data Flow & macOS Lifecycle

```
[ macOS System / NotificationCenter ]
                |
                v
     [ WeatherTimelineProvider ]
                |
                +---> #if DEBUG: Print developer telemetry log
                |
                v
      [ Fetch WeatherData ]
                |
                v
      [ Generate TimelineEntry ]  --> [ Schedules next update (+1 hour) ]
                |
                v
       [ WeatherWidgetView ]
                |
        +-------+-------+
        |               |
        v               v
 [ SystemSmall ] [ SystemMedium ]
        |               |
        +-------+-------+
                |
                v
  [ .ultraThinMaterial Backing ] --> [ Rendered to macOS Desktop ]
```

---

## 5. Artifacts & Code Delivery
- Code Location: `Subsystems/WeatherWidget/`
- Visual Preview Asset: `Subsystems/WeatherWidget/preview.jpg`
- Global Assets Utilized: `Global/DesignSystem/`

# WidgetCraft Development Rules

## 1. Architecture & Modularity
- **Subsystem Independence:** Every feature or widget must reside in its own isolated subsystem directory (`Subsystems/`). A failure or crash in one subsystem MUST NOT affect others.
- **Global Reusability:** All shared utilities, extensions, and common UI components must be placed in the `Global/` folder. This is the only place for reusable code.
- **Strict Boundaries:** Subsystems should never directly depend on each other. If they need shared logic, it must be abstracted to `Global/`.

## 2. Coding Style
- **Minimal & Efficient:** Write clean, concise, and self-documenting code. Avoid over-engineering. YAGNI (You Aren't Gonna Need It) applies.
- **UI First:** The User Interface is the main and ONLY priority. Focus on flawless, sleek, and responsive design above all else.
- **Modern Apple Frameworks:** Use SwiftUI for all modern views and widgets. Use WidgetKit exclusively for the widgets.

## 3. Logging & Debugging
- **Mandatory Developer Logs:** Extensive logging is required in developer mode to trace UI states and data flow.
- **Production Safety:** Wrap all debug logging with `#if DEBUG` to ensure no sensitive information or excessive logging leaks into production builds.

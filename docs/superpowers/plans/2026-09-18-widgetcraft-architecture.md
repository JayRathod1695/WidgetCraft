# WidgetCraft Architecture Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Establish the foundational folder structure and architecture for the WidgetCraft project, ensuring strict subsystem independence and global reusability.

**Architecture:** A modular directory structure containing `Global/` for shared components and `Subsystems/` for independent widget features.

**Tech Stack:** iOS, Swift, SwiftUI, WidgetKit, Git

**Spec:** Folder Structure & Project Guidelines (per `RULES.md`)

## Global Constraints
- Folder names must be capitalized.
- `RULES.md` is the single source of truth for development guidelines.
- No subsystem can directly reference another subsystem.

---

### Task 1: Initialize Base Architecture Directories

**Files:**
- Create: `Global/README.md`
- Create: `Subsystems/README.md`
- Create: `App/README.md`

**Interfaces:**
- Consumes: None
- Produces: Base directories for the project.

- [ ] **Step 1: Create Global Directory**

```bash
mkdir -p Global
echo "# Global Components\n\nReusable UI, utilities, and shared models." > Global/README.md
```

- [ ] **Step 2: Create Subsystems Directory**

```bash
mkdir -p Subsystems
echo "# Subsystems\n\nIndependent, isolated widget features." > Subsystems/README.md
```

- [ ] **Step 3: Create App Directory**

```bash
mkdir -p App
echo "# App Entry Point\n\nMain SwiftUI App struct and lifecycle handlers." > App/README.md
```

- [ ] **Step 4: Commit**

```bash
git add Global/README.md Subsystems/README.md App/README.md RULES.md
git commit -m "chore: scaffold base architecture and rules"
```

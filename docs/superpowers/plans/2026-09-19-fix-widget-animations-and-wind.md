# Widget Animation Stabilization & Wind Gauge Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Eliminate widget height jitter, synchronize solar and barometer SVG paths/beads via exact geometry (`getPointAtLength`), and redesign the wind gauge with an animated compass/turbine flow.

**Architecture:** Lock widget and capsule vertical geometry to fixed heights with strict single-line text overflows. Replace ad-hoc polynomial calculations in Solar and Barometer SVGs with deterministic SVG path length sampling (`path.getPointAtLength` and `strokeDashoffset`). Replace static wind chevrons with a rotating compass heading needle and speed-driven particle flow streams.

**Tech Stack:** HTML5, CSS3 Glassmorphism, SVG geometry APIs (`getTotalLength`, `getPointAtLength`, `strokeDashoffset`), JavaScript (ES6)

**Spec:** User feedback on `preview/index.html` (height jitter, path/dot desync, static wind gauge)

## Global Constraints
- No external libraries; pure vanilla JS/CSS/SVG.
- Strict Apple HIG glassmorphic aesthetics: neutral borders, no colored glows on card boundaries.
- All 24-hour data remains 100% synthetic/dummy data.
- Zero emojis; pure vector graphics only.

---

### Task 1: Lock Layout Geometry to Eliminate Vertical Resizing

**Files:**
- Modify: `preview/index.html`

**Interfaces:**
- Consumes: CSS classes `.master-widget`, `.clean-capsule`, `.hero-row`, `.condition-text`, `.capsule-primary-val`, `.capsule-subtext`
- Produces: Locked vertical dimensions preventing expansion/retraction across all 24 hours.

- [ ] **Step 1: Set fixed heights and prevent text wrap jitter**
  - Set `.master-widget` to fixed `height: 520px` (or `min-height: 520px; max-height: 520px`).
  - Set `.clean-capsule` to a fixed height of `116px`.
  - Add `white-space: nowrap; overflow: hidden; text-overflow: ellipsis;` to `.condition-text`, `.hilo-text`, `.capsule-subtext`, `.capsule-primary-val`.
  - Ensure `.hero-vector-scene` has fixed dimensions (`100px x 100px`) and moon/sun are strictly centered.

- [ ] **Step 2: Verify in browser that height is completely static across 00:00 - 24:00**

---

### Task 2: Synchronize Solar Arc & Barometer Paths Using Native SVG Geometry

**Files:**
- Modify: `preview/index.html`

**Interfaces:**
- Consumes: SVG paths `#solarArcBase`, `#solarArcActive`, `#solarPearl`, `#baroWaveBase`, `#baroWaveActive`, `#pressureBead`
- Produces: 100% synchronized bead tracking and glowing neon path trimming via `getPointAtLength()` and `strokeDashoffset`.

- [ ] **Step 1: Update Solar Path SVG & JS Engine**
  - Define full solar arc: `<path id="solarArcBase" d="M 5 28 Q 65 2 125 28" .../>`
  - Define active glowing arc: `<path id="solarArcActive" d="M 5 28 Q 65 2 125 28" .../>`
  - In JS: Calculate total length `L = solarArcBase.getTotalLength()`.
  - Set `solarArcActive.style.strokeDasharray = L`.
  - Set `solarArcActive.style.strokeDashoffset = L * (1 - progress)`.
  - Get bead point: `const pt = solarArcBase.getPointAtLength(L * progress)`.
  - Set bead position: `sunPearl.setAttribute('cx', pt.x); sunPearl.setAttribute('cy', pt.y)`.
  - Remove conflicting CSS transitions (`transition: cx 0.2s, cy 0.2s`) that cause lag.

- [ ] **Step 2: Update Barometer SVG & JS Engine**
  - Define full barometer wave: `<path id="baroWaveBase" d="M 5 24 Q 35 32 65 18 T 125 10" .../>`
  - Define active wave: `<path id="baroWaveActive" d="M 5 24 Q 35 32 65 18 T 125 10" .../>`
  - In JS: Calculate `L = baroWaveBase.getTotalLength()`.
  - Set `baroWaveActive.style.strokeDasharray = L`.
  - Set `baroWaveActive.style.strokeDashoffset = L * (1 - baroProgress)`.
  - Get bead point: `const pt = baroWaveBase.getPointAtLength(L * baroProgress)`.
  - Position bead: `pressureBead.setAttribute('cx', pt.x); pressureBead.setAttribute('cy', pt.y)`.
  - Remove conflicting CSS transitions.

- [ ] **Step 3: Test scrubbing and simulation to confirm bead stays glued to curve**

---

### Task 3: Redesign Wind Speed Gauge with Rotating Compass Dial & Dynamic Particle Flow

**Files:**
- Modify: `preview/index.html`

**Interfaces:**
- Consumes: Simulated hour `h`, synthetic wind speed `speed` and direction `deg`
- Produces: Interactive compass dial with rotating needle, dynamic speed arcs, and velocity-responsive airflow animation.

- [ ] **Step 1: Design Wind UI Structure**
  - Replace static chevron box with a 2-part layout:
    - Left: Circular mini compass dial (36px x 36px) with illuminated needle rotating to wind bearing (e.g., 45° NE).
    - Right: Speed value, Beaufort scale tag ("Gentle", "Moderate", "Breezy"), and animated wind streamline SVG whose stroke dash animation speed scales with `windSpeed`.
  
- [ ] **Step 2: Connect Wind Engine to Simulation**
  - Compute heading angle `deg = (h * 45) % 360` and cardinal label (`NE`, `E`, `SE`, `S`, `SW`, `W`, `NW`, `N`).
  - Rotate needle: `transform: rotate(${deg}deg)`.
  - Adjust animation duration of wind streamlines proportionally to speed (faster at 22 km/h, slower at 8 km/h).

- [ ] **Step 3: Test wind responsiveness across 24 hours**

---

### Task 4: End-to-End Verification & Browser Refresh

**Files:**
- Test: `preview/index.html`

- [ ] **Step 1: Verify all 3 user issues are resolved**
  - Verify zero widget resizing / jumping.
  - Verify solar and barometer dots are 100% on their respective paths at all times.
  - Verify wind gauge is lively, modern, and visually engaging.
- [ ] **Step 2: Open/reload in browser for user review**

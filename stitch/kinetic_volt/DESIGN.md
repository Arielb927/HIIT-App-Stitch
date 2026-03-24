# Design System Document: Kinetic High-Contrast HIIT Experience

## 1. Overview & Creative North Star: "The Pulse of Precision"
The Creative North Star for this design system is **"The Pulse of Precision."** In the chaotic, high-intensity environment of a HIIT workout, the UI must act as a monolithic beacon of clarity. We move beyond standard fitness app templates by embracing **Aggressive Legibility** and **Athletic Brutalism**. 

This system breaks the "grid-box" monotony through intentional asymmetry, oversized display typography that bleeds off the margins, and high-energy tonal layering. We treat the interface not as a static screen, but as a performance instrument—vibrant, glowing, and hyper-reactive.

---

## 2. Colors & Surface Architecture
The color palette is engineered for maximum contrast in low-light gym environments. We utilize a "Pure Dark" foundation to make our neon functional accents vibrate with energy.

### Core Functional Palette
- **Work (Primary):** `primary_fixed` (#c3f400) - A piercing neon green that demands action.
- **Rest (Secondary):** `secondary_container` (#c5020b) - A deep, urgent red to signal recovery.
- **Action/Music (Tertiary):** `tertiary_fixed_dim` (#adc6ff) - Electric blue for secondary psychological "flow" elements.
- **Background:** `surface` (#131313) - Deep charcoal to eliminate glare.

### The "No-Line" Rule
Standard 1px borders are strictly prohibited for sectioning. Structural definition must be achieved through:
1.  **Background Shifts:** Placing a `surface_container_low` card against the `surface_dim` background.
2.  **Negative Space:** Using the `8` (2.75rem) or `10` (3.5rem) spacing tokens to create mental boundaries.

### The "Glass & Glow" Rule
To achieve a "High-End Editorial" feel, interactive elements should utilize **Glassmorphism**. Floating music controllers or active timers should use `surface_bright` at 60% opacity with a `20px` backdrop blur. 
*Signature Polish:* Apply a `0 0 20px` outer glow to neon text (`primary_fixed`) when a timer is active to simulate a physical LED display.

---

## 3. Typography: Maximum Readability
We pair the technical precision of **Inter** with the geometric, wide-stature of **Lexend** to ensure the user can read their progress from 10 feet away while mid-burpee.

- **Display (Lexend):** Used for the countdown timer. `display-lg` (3.5rem) should be pushed even further in active states—don't be afraid to use custom 8rem or 10rem sizes for the "seconds" remaining.
- **Headlines (Lexend):** `headline-lg` (2rem) for workout titles. Use tight letter-spacing (-0.02em) to give it an aggressive, "compressed" athletic look.
- **Body & Labels (Inter):** `body-md` and `label-md` for technical data (heart rate, calories). 

*Editorial Note:* Use `title-lg` in all-caps for workout segments to create a rhythmic, columnar layout that feels like a premium sports magazine.

---

## 4. Elevation & Depth: Tonal Layering
We reject drop shadows in favor of **Tonal Stacking**. Depth is a hierarchy of luminosity, not a simulated light source.

- **The Layering Principle:** 
    - Level 0 (Base): `surface_container_lowest` (#0e0e0e)
    - Level 1 (Section): `surface_container_low` (#1c1b1b)
    - Level 2 (Interactive Card): `surface_container` (#201f1f)
- **Ambient Shadows:** Only used for floating "Pause" modals. Use a tinted shadow: `rgba(195, 244, 0, 0.08)` (a 8% tint of the primary neon) with a 40px blur to create a "light spill" effect rather than a shadow.
- **The Ghost Border:** For segment cards, use a `1px` stroke of `outline_variant` at **15% opacity**. It should be felt, not seen.

---

## 5. Components

### Large-Format Buttons
- **Primary Action (Start/Work):** Uses `primary_fixed` (#c3f400) with `on_primary_fixed` (#161e00) text. 
- **Shape:** Use `rounded-xl` (0.75rem) for a modern, "tank" feel. 
- **Sizing:** Minimum height of `12` (4rem) to ensure "fat-finger" compatibility during high-intensity movement.

### Segment Cards (Workout Steps)
- **Layout:** Asymmetric. The interval time (`headline-md`) is pinned to the top left, while the drag handle is a large `surface_bright` vertical bar on the right.
- **Constraint:** No dividers. Use `surface_container_high` to distinguish the currently active interval from the rest of the stack.

### Progress Rings
- **Stroke:** Use a heavy `12px` stroke.
- **Visual Flourish:** The "Work" ring should have a trailing gradient from `primary_fixed` to `surface_container_highest` to imply motion.

### Music Integration (Spotify/Apple)
- **Aesthetic:** Housed in a `surface_bright` glassmorphic tray at the bottom of the screen. 
- **Icons:** Use `tertiary_fixed` (#d8e2ff) for playback controls to visually separate music from workout vitals.

---

## 6. Do’s and Don’ts

### Do:
- **Use "Display-Bleed":** Allow large timer numbers to slightly overlap the edge of the screen or background elements to create depth.
- **Vibrate the UI:** Use the vibrant red `secondary_fixed_dim` for the final 3 seconds of a rest period to trigger a psychological "get ready" response.
- **Embrace Asymmetry:** Align workout stats to a 3-column grid where the center column is wider than the flanks.

### Don’t:
- **Don't use 100% White:** Use `on_surface` (#e5e2e1) for text. Pure white (#FFFFFF) is too harsh against the deep charcoal and creates visual vibration ("halation").
- **Don't use standard Dividers:** If you need to separate content, use a `12` (4rem) vertical gap or a subtle shift from `surface_container_low` to `surface_container_high`.
- **Don't use Rounded-Full for Buttons:** Keep them at `xl` (0.75rem) or `lg` (0.5rem). Full pill shapes feel too "soft" for a high-intensity professional tool.

---

## 7. Spacing & Rhythm
Rhythm is critical for an app focused on timing.
- **The "Power Gap":** Use the `16` (5.5rem) spacing token between the main timer and the "Next Up" segment to create a clear cognitive break.
- **Touch Targets:** All interactive elements (Music play, Segment skip) must maintain a minimum `48dp` hit area, padded with `3` (1rem) spacing to prevent accidental touches during sweat-induced loss of fine motor skills.
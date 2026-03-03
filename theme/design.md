# CapyDoro Design System

> A cozy, nature-inspired design language built around the capybara — the world's chillest animal. Use this guide to build any capybara-themed Flutter app with a consistent look and feel.

---

## 1. Design Philosophy

| Principle | Description |
|---|---|
| **Warm & Organic** | Earthy tones drawn from capybara fur, warm sand, and soft forest greens. Nothing neon, nothing harsh. |
| **Calm & Focused** | The UI should feel like a warm cup of tea — inviting you to slow down, breathe, and focus. |
| **Minimal & Rounded** | Clean layouts with generous whitespace. Rounded corners everywhere (buttons, cards, progress indicators). |
| **Subtle Motion** | Animations are eased and gentle (400–800 ms). No jarring pops — everything flows like a sleepy capybara sliding into a hot spring. |
| **Capybara Personality** | Emoticons and illustrations give the app a warm, mascot-driven personality without being childish. |

---

## 2. Color Palette

### Light Mode

| Role | Name | Hex | Swatch | Description |
|---|---|---|---|---|
| Background | `background` | `#F7F3EE` | 🟫 | Warm off-white / cream |
| Primary | `primary` | `#B08968` | 🟤 | Capybara fur — soft brown |
| Secondary | `secondary` | `#7F5539` | 🟫 | Capybara nose / shadow — muted dark brown |
| Text Primary | `textPrimary` | `#5C4033` | 🟤 | Rich chocolate brown |
| Text Secondary | `textSecondary` | `#8B7355` | 🟫 | Muted brown (subtitles, hints) |
| Text Light | `textLight` | `#B8A99A` | 🏖️ | Faded sand (disabled / placeholder text) |

### Dark Mode

| Role | Name | Hex | Swatch | Description |
|---|---|---|---|---|
| Background | `darkBackground` | `#1E1B18` | ⬛ | Deep warm charcoal |
| Primary | `darkPrimary` | `#C9A882` | 🟤 | Lightened capybara fur |
| Secondary | `darkSecondary` | `#D4A574` | 🟫 | Warm caramel accent |
| Text Primary | `darkTextPrimary` | `#E8DDD0` | 🏖️ | Warm parchment white |
| Text Secondary | `darkTextSecondary` | `#B8A99A` | 🟫 | Muted sand |
| Text Light | `darkTextLight` | `#6B5E52` | ⬛ | Dim brown (disabled) |

### Shared Accent Colors (same in both modes)

| Role | Name | Hex | Swatch | Usage |
|---|---|---|---|---|
| Focus / Active | `focus` | `#A3B18A` | 🟩 | Warm tea-green — used for focus-mode rings, completed session dots, active chart bars |
| Break / Rest | `breakColor` | `#B7D3DF` | 🔵 | Soft sky-blue — used for break-mode rings and bars |
| Danger / Reset | `danger` | `#D77A61` | 🟠 | Dusty coral — used for reset actions, streak counters, error states |

### Card Colors

| Mode | Color | Hex |
|---|---|---|
| Light | Card surface | `#FFFFFF` (pure white) |
| Dark | Card surface | `#2C2824` (warm dark brown) |

### Alpha / Opacity Patterns

- **Tinted backgrounds**: Use primary color at `0.1` alpha (e.g., icon containers, dropdown wells)
- **Track / inactive fills**: Use the context color at `0.18` alpha (e.g., timer ring track, progress bar track)
- **Inactive dots / elements**: Use primary at `0.2` alpha
- **Subtle shadows**: `Colors.black` at `0.05` (light) or `0.15` (dark)
- **De-emphasized text**: Secondary color at `0.5`–`0.7` alpha

---

## 3. Typography

### Font Family

**[Nunito](https://fonts.google.com/specimen/Nunito)** (via `google_fonts` package)

Nunito is a well-balanced rounded sans-serif. Its soft, friendly letterforms perfectly complement the capybara aesthetic — approachable without being playful.

### Type Scale

| Usage | Size | Weight | Letter Spacing | Example |
|---|---|---|---|---|
| Timer countdown | 48–56 px | `w700` (Bold) | 0 | `25:00` |
| Phase label | 22 px | `w700` (Bold) | 0 | `Focus Time` |
| Capybara emoticon | 28 px | — | 0 | `(•ᴗ•)` |
| Button (Primary) | 18 px | `w600` (SemiBold) | 0.5 | `START` |
| Button (Text) | 14 px | `w500` (Medium) | 0 | `Skip` |
| Section header | `labelLarge` | `w800` (ExtraBold) | 1.2 | `DURATION (MINUTES)` |
| Card value | 20 px | `w800` (ExtraBold) | 0 | `5 sessions` |
| Title Medium | default | `w600` (SemiBold) | 0 | Settings row labels |
| Body text | default | default | 0 | General descriptions |

### Text Colors

Apply via `.apply()` on the text theme:
- **Body & display text**: Use `textPrimary` / `darkTextPrimary`
- **Section headers**: Use `colorScheme.primary` with `w800` and `letterSpacing: 1.2`
- **Subtitle / hint text**: Use `colorScheme.secondary` at reduced alpha (0.5–0.7)

---

## 4. Buttons & Interactive Elements

### Primary Button (ElevatedButton)

```
Background:      colorScheme.primary
Foreground:      white (light) / darkBackground (dark)
Elevation:       0 (flat)
Padding:         horizontal: 32, vertical: 16
Border Radius:   50 (fully rounded / pill shape)
Font:            Nunito, 18px, w600, letterSpacing: 0.5
```

### Text Button

```
Foreground:      textSecondary / darkTextSecondary
Font:            Nunito, 14px, w500
```

### Micro-interaction: Scale on Tap

All action buttons use a subtle scale animation:
- **Duration**: 100 ms
- **Scale**: 1.0 → 0.97
- **Curve**: `Curves.easeInOut`

The button shrinks slightly on tap-down and bounces back on release — giving tactile feedback without being distracting.

### Icon Containers (Settings / Lists)

```
Padding:         8px all sides
Background:      colorScheme.primary at 0.1 alpha
Border Radius:   8
Icon Color:      colorScheme.primary
```

### Segmented Button (Theme Selector)

```
Background:            colorScheme.surface
Selected Background:   colorScheme.primary
Selected Foreground:   colorScheme.onPrimary
```

### Slider

```
Active Track:    colorScheme.primary
Inactive Track:  colorScheme.primary at 0.2 alpha
Thumb:           colorScheme.primary
Overlay:         colorScheme.primary at 0.1 alpha
Track Height:    6
```

### Switch

```
Active Color:    colorScheme.primary
```

---

## 5. Cards & Containers

### Standard Card

```
Background:      white (light) / #2C2824 (dark)
Border Radius:   16
Padding:         16 all sides
Shadow:          offset(0, 2), blur 8, black at 0.05 (light) / 0.15 (dark)
```

### Summary Cards (Grid)

```
Grid:            2 columns
Spacing:         12 (both axes)
Aspect Ratio:    1.6
Layout:          Icon top-left → Spacer → Value (large) → Label (small)
```

### Chart Container

```
Height:          200
Padding:         left/right/bottom: 16, top: 24
Same card styling as above
```

---

## 6. App Bar & Navigation

### App Bar

```
Elevation:       0
Background:      transparent (inherits scaffold background)
Title:           bold, centered
```

### System UI

```
Status Bar:      transparent, icons match theme brightness
Nav Bar:         matches background color, icons match theme brightness
```

### Screen-to-Screen Transitions

Use default `MaterialPageRoute` — no custom hero/slide animations needed. The standard slide-in is consistent and unobtrusive.

---

## 7. Animation Guidelines

| Element | Duration | Curve | Notes |
|---|---|---|---|
| Timer ring color change | 800 ms | `easeInOut` | Smooth `ColorTween` between phase colors |
| Timer bar progress | 800 ms | `easeInOut` | `AnimatedContainer` width + color |
| Session dots (size) | 400 ms | `easeInOut` | Active dot: 14px, inactive: 10px |
| Capybara image swap | 600 ms | `easeIn` / `easeOut` | `AnimatedSwitcher` with fade + stack |
| Button tap scale | 100 ms | `easeInOut` | 1.0 → 0.97 scale |
| Bar chart | 400 ms | `easeInOut` | `fl_chart` built-in animation |
| Phase label change | use `AnimatedSwitcher` | — | Fade between labels |

### General Rules

- **Never use linear curves** — always `easeInOut`, `easeIn`, or `easeOut`
- **Duration range**: 100–800 ms. Micro-interactions: 100–200 ms. State transitions: 400–800 ms.
- **Avoid bouncy / spring animations** — they don't match the calm aesthetic
- **Use `AnimatedContainer`** for size/color changes, **`AnimatedSwitcher`** for widget swaps

---

## 8. Progress Indicators

### Timer Ring (Circular)

```
Stroke Width:    12
Cap:             StrokeCap.round
Track:           Phase color at 0.18 alpha
Progress:        Phase color at full opacity
Start Angle:     -π/2 (12 o'clock position)
Radius:          (containerWidth - 14) / 2
```

**Phase → Color mapping:**

| Phase | Ring Color |
|---|---|
| Idle | `primary` (#B08968) |
| Focus | `focus` (#A3B18A) |
| Short Break | `breakColor` (#B7D3DF) |
| Long Break | `breakColor` (#B7D3DF) |
| Completed | `focus` (#A3B18A) |

### Timer Bar (Linear)

```
Height:          10
Border Radius:   5
Track:           Same alpha/color logic as ring
```

### Session Dots

```
Size (inactive): 10 × 10
Size (active):   14 × 14 with 2px primary-color border
Shape:           Circle
Completed:       focus color (solid)
Upcoming:        primary at 0.2 alpha
Active:          primary (solid) with border
```

---

## 9. Capybara Personality System

### Emoticon Faces (Text Fallback)

| State | Emoticon |
|---|---|
| Idle | `(•‿•)` |
| Focus | `(•ᴗ•)` |
| Short Break | `(ᵔ◡ᵔ)` |
| Long Break | `(－‿－)` |
| Completed | `(≧◡≦)` |

### Illustration Assets

Each app state has a dedicated capybara illustration:

| State | Asset Path | Description |
|---|---|---|
| Idle | `Assets/idle.png` | Capybara sitting, ready to go |
| Focus | `Assets/focus.png` | Capybara concentrating |
| Short Break | `Assets/short break.png` | Capybara relaxing |
| Long Break | `Assets/long break.png` | Capybara fully chilling |
| Completed | `Assets/completition.png` | Capybara celebrating |

### Image Display

- Use `AnimatedSwitcher` (600 ms) for crossfade between states
- `BoxFit.contain` — never crop the capybara
- Stack layout to keep old & new images aligned during transition

---

## 10. Sound Design

| Event | File | Description |
|---|---|---|
| Focus → Break | `Assets/worktobreak.mp3` | Gentle chime signaling rest |
| Break → Focus | `Assets/breaktowork.mp3` | Soft alert to resume work |
| All sessions done | `Assets/completion.mp3` | Celebratory completion sound |

**Style**: Chimes should be warm, soft, and organic — like a wind chime or wooden xylophone. Avoid harsh digital alerts.

---

## 11. Layout Patterns

### Content Padding

```
Screen body:     horizontal: 24, vertical: 16
Section spacing: 24–28 between major sections
Bottom padding:  48 (breathing room above system nav)
```

### Responsive Layout

- **Portrait**: Single column, vertically stacked (timer ring → buttons → dots)
- **Landscape**: Two-pane layout (timer left, controls right)

### List Items

```
Content Padding: EdgeInsets.zero (for tight, custom layouts)
Leading Icon:    8px padded container with 0.1-alpha primary background, rounded 8
Trailing:        chevron icons for navigation, text for metadata
```

---

## 12. Dark Mode Strategy

The design uses a **dual palette** approach — not just inverting colors, but choosing warm dark tones that preserve the cozy feel:

| Light | Dark | Why |
|---|---|---|
| Cream background | Warm charcoal (`#1E1B18`) | Keeps warmth rather than cold pure-black |
| Soft brown primary | Lightened fur (`#C9A882`) | Maintains legibility and warmth |
| White cards | Warm dark brown (`#2C2824`) | Elevated surface feels like aged leather |
| Subtle shadows | Slightly darker shadows (0.15) | Compensates for low-contrast dark surfaces |

### Dark Mode Toggle

- Quick toggle available on home screen (sun/moon icon)
- Full theme selector in Settings: System / Light / Dark
- Uses `ListenableBuilder` + `ThemeProvider` for reactive switching

---

## 13. Technology & Packages

| Package | Version | Purpose |
|---|---|---|
| `google_fonts` | ^6.2.1 | Nunito font family |
| `fl_chart` | ^0.70.2 | Bar charts for statistics |
| `audioplayers` | ^6.5.1 | Sound alerts |
| `vibration` | ^3.1.8 | Haptic feedback |
| `shared_preferences` | ^2.5.3 | Persistent settings & stats |
| `flutter_foreground_task` | ^9.2.0 | Background timer service |
| `in_app_purchase` | ^3.2.3 | Tip jar / support |
| `url_launcher` | ^6.3.2 | External links |
| `flutter_launcher_icons` | ^0.14.4 | App icon generation |

### Material 3

The app uses **Material 3** (`useMaterial3: true`). All components leverage the M3 color scheme and shape system.

---

## 14. Quick-Start: Adapting for a New App

To build a new capybara-themed app (e.g., a to-do list):

1. **Copy `app_colors.dart` and `app_theme.dart`** — they're self-contained and ready to drop in.
2. **Add `google_fonts: ^6.2.1`** to your `pubspec.yaml`.
3. **Apply the theme** in `MaterialApp`:
   ```dart
   MaterialApp(
     theme: AppTheme.lightTheme,
     darkTheme: AppTheme.darkTheme,
     themeMode: ThemeMode.system,
   );
   ```
4. **Use the shared accent colors** for state mapping:
   - `AppColors.focus` → success / completed
   - `AppColors.breakColor` → in-progress / information
   - `AppColors.danger` → warnings / destructive actions
5. **Follow animation guidelines** — 400–800 ms, easeInOut, AnimatedContainer.
6. **Use the capybara emoticons** for empty states, loading, or fun personality touches.
7. **Card radius: 16**, **Button radius: 50** (pill), **Icon container radius: 8**.
8. **Section headers**: `labelLarge`, primary color, `w800`, upper-case, `letterSpacing: 1.2`.

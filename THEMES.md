# Creating Themes

This guide explains how the Twitch Card skin is themed and walks through building a theme, from a simple
color scheme up to a fully hand-painted background image.

---

## 1. How themes work

A theme is a single file: `@Resources\Themes\<Number>.inc`.

`server.ini` first defines a **default value for every theme variable** (section *THEME-STANDARDWERTE*),
and only then includes the active theme:

```ini
Theme=35
@IncludeTheme=#ThemesPath##Theme#.inc
```

Because the theme is loaded *after* the defaults, it works like a CSS stylesheet:

- Every variable the theme sets **overrides** the default.
- Every variable the theme leaves out **keeps** its default.

A theme can therefore be four lines long (see `1.inc`) or override almost everything (see `33.inc`).

Many defaults point to other variables, e.g. `ColorIconHover=#ColorAccent#` or `ColorAvatarRing=#ColorAccent#`.
These are resolved when the skin is drawn, so if your theme only changes `ColorAccent`, the icon hover color,
the avatar ring, the tile label icons and the play button on hover all follow automatically.

### Switching themes

- Click the palette icon in the header → next theme.
- Mouse wheel over the palette icon → next / previous theme.
- The tooltip shows the theme name and its number, e.g. `Twitch Lila (1/35)`.
- Switching writes `Theme=<Number>` into `server.ini` and refreshes the skin.
  You can also edit that line by hand.

### Automatic theme count

`ThemeCount.lua` counts `1.inc`, `2.inc`, `3.inc`, … and **stops at the first missing number**.
Numbers must therefore be continuous: if `1`–`35` exist and you add `37.inc`, it will not show up
until `36.inc` exists. No other registration is needed.

---

## 2. Quick start

1. Copy an existing theme that is close to what you want:
   - `1.inc` for a simple color theme,
   - `33.inc` / `35.inc` for a full background-image theme.
2. Rename the copy to the next free number (currently `36.inc`).
3. Change `ThemeName` and the colors.
4. Put any images into `@Resources\Themes\Images\`, named after the theme number (`36.png`, `36_avatar.png`, …).
5. Set `Theme=36` in `server.ini` (or click through to it) and middle-click the skin to refresh.

Every theme file starts with the `[Variables]` section header:

```ini
[Variables]
ThemeName=My Theme
ColorBgTop=30,27,42,240
ColorBgBottom=14,14,18,240
ColorAccent=145,70,255,255
ColorAccent2=255,80,170,255
```

---

## 3. Units and value formats

| Kind | Format | Notes |
|---|---|---|
| Colors | `R,G,B,A` | Each 0–255. `A` is opacity: `0` = invisible, `255` = solid. `0,0,0,0` hides an element completely. |
| Sizes, offsets, radii | plain number | **Unscaled.** The skin multiplies them by `Scale` (default `0.75`), so always think in the 280-px-wide design grid below. |
| Font sizes | plain number | Also multiplied by `Scale`. |
| Fonts | font family name | e.g. `Segoe UI Semibold`. The font must be installed in Windows, or the `.ttf`/`.otf` placed in `@Resources\Fonts\` (Rainmeter loads that folder automatically). |
| Text effects | `None`, `Shadow` or `Border` | `Border` draws an outline. The effect color is set by the matching `Color…Effect` variable. |
| Images | path | Use `#ImagesPath#36.png` (same as `#ThemesPath#Images\36.png`). Leave empty to turn a layer off. PNG with transparency is recommended. |
| Flags | `0` or `1` | |

Gradients (`ColorBgTop`→`ColorBgBottom`, `ColorTitle`→`ColorTitle2`, `ColorValue`→`ColorValue2`) always run
**top to bottom**. To disable a gradient, set both colors to the same value. The accent bar
(`ColorAccent`→`ColorAccent2`) runs **left to right**.

---

## 4. Card layout (design grid)

All coordinates are unscaled, measured from the top-left corner of the card.

```
 0                                                          280
 ┌────────────────────────────────────────────────────────────┐ 0
 │      ▔▔▔▔▔▔▔▔▔▔▔▔ accent bar (AccentBarHeight) ▔▔▔▔▔▔▔▔▔▔      │
 │ ●/◯  Title (x = 14 + HeaderIndent, y = 13)     ✎   🎨   ⟳  │
 │      twitch.tv/name (y = 33)   ↕ y + HeaderIndentY         │
 │                                                            │ 58
 │  ┌──────────────────────────────────────────────────────┐  │
 │  │ LIVE                                                 │  │
 │  │                 Preview  252 × 141.75 (16:9)         │  │
 │  │                 x = 14 … 266                         │  │
 │  │ 👁 viewers                                            │  │
 │  └──────────────────────────────────────────────────────┘  │ 199.75
 │                                                            │ 211.75
 │  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐    │
 │  │ STATUS       │   │ VIEWERS      │   │ UPTIME       │    │  tiles 78.7 × 50
 │  │   value      │   │   value      │   │   value      │    │
 │  └──────────────┘   └──────────────┘   └──────────────┘    │ 261.75
 └────────────────────────────────────────────────────────────┘ 275.75
```

| Element | Position / size (unscaled) |
|---|---|
| Card | 280 × 275.75 (≈ 280 : 276) |
| Padding left/right | 14 |
| Status dot / avatar center | y = 30; dot at x = 20, avatar at x = 14 + `AvatarX` (left edge) |
| Title | x = 14 + `HeaderIndent`, y = 13 + `HeaderIndentY` |
| Subtitle | x = 14 + `HeaderIndent`, y = 33 + `HeaderIndentY` |
| Header buttons (right-aligned) | y = 20; reload x = 266, theme x = 242, edit x = 218 |
| Preview | x = 14, y = 58, 252 × 141.75 |
| LIVE badge | inside the preview at 8, 8, size 40 × 17 |
| Tiles | y = 211.75, each 78.67 × 50, gap 8; left edges at x = 14, 100.67, 187.33 |
| Tile label (icon + text) | centered in the tile, y = tile top + 9 |
| Tile value | centered in the tile (+ `TileValueShift<n>` + `TileValueX<n>`), y = tile top + `TileValueY<n>` (default 23) |

At `Scale=0.75` the card is about **210 × 207 px** on screen.

### Layer order (bottom → top)

1. Card background gradient (`ColorBgTop` → `ColorBgBottom`)
2. `ImgCardBack`
3. Card border + accent bar
4. Status dot **or** avatar (+ ring)
5. Title, subtitle, header buttons
6. Preview background (`ColorPreviewBg`)
7. Stream preview image (live only) + bottom shade (`ColorPreviewShade`)
8. `ImgOffline` + offline text (offline only)
9. `ImgPreviewFrame`
10. Hover overlay + play button (only while the mouse is over the preview)
11. LIVE badge, viewer count overlay
12. Preview border (`ColorPreviewBorder`)
13. Tiles, tile labels, `ImgTile1..3`, tile values
14. `ImgCardFront` – drawn on top of everything, does **not** block mouse clicks

---

## 5. Variable reference

### Required

These have **no default** – other defaults reference them, so every theme must set them.

| Variable | Meaning |
|---|---|
| `ThemeName` | Name shown in the theme button tooltip |
| `ColorBgTop`, `ColorBgBottom` | Card background gradient (top / bottom) |
| `ColorAccent` | Accent color: accent bar start, label icons, icon hover, avatar ring, play button |
| `ColorAccent2` | Accent bar end color |

### Card

| Variable | Default | Meaning |
|---|---|---|
| `CardRadius` | `18` | Corner radius of the card (also clips `ImgCardBack`) |
| `BorderWidth` | `1` | Card border width, `0` = no border |
| `ColorBorder` | `255,255,255,22` | Card border color |
| `AccentBarHeight` | `2` | Height of the accent bar at the top edge, `0` = off |

### General text and fonts

| Variable | Default | Meaning |
|---|---|---|
| `ColorText` | `245,245,250,255` | Base text color (used by title and values by default) |
| `ColorDim` | `245,245,250,120` | Dimmed text (subtitle, icons, labels, offline text by default) |
| `FontTitle` | `Segoe UI Semibold` | Title font; also default for labels, values and offline text |
| `FontText` | `Segoe UI` | Subtitle font |
| `FontBold` | `Segoe UI Bold` | LIVE badge font |
| `FontIcon` | `Segoe MDL2 Assets` | Icon font (only change if you know what you are doing – icons are glyph codes) |

### Header

| Variable | Default | Meaning |
|---|---|---|
| `HeaderIndent` | `50` | Horizontal offset (X) of title/subtitle from the left padding |
| `HeaderIndentY` | `0` | Vertical offset (Y) of title/subtitle and the name input field (positive = down, negative = up) |
| `TitleSize` | `14` | Title font size |
| `SubtitleSize` | `8` | Subtitle font size |
| `ColorTitle`, `ColorTitle2` | `#ColorText#` | Title gradient (top → bottom) |
| `TitleEffect` | `None` | `None` / `Shadow` / `Border` |
| `ColorTitleEffect` | `0,0,0,160` | Shadow / outline color of the title |
| `ColorSubtitle` | `#ColorDim#` | Subtitle color |
| `ColorIcon` | `#ColorDim#` | Header button color |
| `ColorIconHover` | `#ColorAccent#` | Header button color on hover |

### Avatar

As soon as `ImgAvatar` is set, the avatar replaces the status dot. A small status dot (red = live,
grey = offline) is then drawn at the bottom right of the avatar.

| Variable | Default | Meaning |
|---|---|---|
| `ImgAvatar` | *(empty)* | Square image, automatically cropped to a circle |
| `AvatarSize` | `22` | Diameter |
| `AvatarX` | `-4` | Left edge offset from the padding (vertical center is fixed at y = 30) |
| `AvatarRingWidth` | `1.5` | Ring width, `0` = no ring |
| `ColorAvatarRing` | `#ColorAccent#` | Ring color |

### Preview

| Variable | Default | Meaning |
|---|---|---|
| `PreviewPanelExtraH` | `12` | Adds extra height to the preview panel without changing the base `PrevH` layout value. Positive values extend the preview downward. |
| `PreviewPanelExtraW` | `0` | Adds or removes width from the preview panel without changing the base `PrevW` layout value. Positive values make the preview wider; negative values make it narrower. |
| `PreviewPanelExtraX` | `0` | Moves the complete preview panel horizontally. Positive values move it to the right; negative values move it to the left. |
| `PreviewPanelExtraY` | `0` | Moves the complete preview panel vertically. Positive values move it down; negative values move it up. |
| `PreviewRadius` | `12` | Corner radius of the preview |
| `PreviewBorderWidth` | `1` | Preview border width, `0` = none |
| `ColorPreviewBorder` | `255,255,255,26` | Preview border color |
| `ColorPreviewBg` | `0,0,0,90` | Fill behind the stream image (visible while offline/loading) |
| `ColorPreviewShade` | `0,0,0,170` | Dark gradient over the lower 45 % of the stream image (readability of the viewer count) |
| `ColorHoverOverlay` | `0,0,0,110` | Darkening while hovering the preview |
| `HidePreviewViewers` | `0` | `1` hides the viewer count overlay in the preview (it is still shown in the tile) |
| `ColorLive` | `235,4,0,255` | Status color when live (dot, status value) |
| `ColorOffline` | `120,120,130,255` | Status color when offline |
| `ColorLiveBadge` | `#ColorLive#` | LIVE badge background |
| `ColorLiveBadgeText` | `255,255,255,255` | LIVE badge text |

> `PreviewPanelExtraH`, `PreviewPanelExtraW`, `PreviewPanelExtraX` and `PreviewPanelExtraY` are set in `server.ini` under `[Variables]`. They let you resize and reposition the live `current.jpg` preview to fit custom card artwork without changing the base `PrevW` / `PrevH` layout values. The preview mask, stream image, frame, hover area and hitbox follow these adjustments.

> Do not set `ColorStatus` – the skin switches it between `ColorLive` and `ColorOffline` itself.

### Offline display

Shown inside the preview area while the stream is offline.

| Variable | Default | Meaning |
|---|---|---|
| `ImgOffline` | *(empty)* | Image filling the preview (16 : 9) |
| `OfflineText` | `Offline` | Centered text; set it empty (`OfflineText=`) for no text |
| `FontOffline` | `#FontTitle#` | Font |
| `OfflineTextSize` | `16` | Font size |
| `ColorOfflineText` | `#ColorDim#` | Text color |
| `OfflineTextEffect` | `None` | `None` / `Shadow` / `Border` |
| `ColorOfflineTextEffect` | `0,0,0,160` | Effect color |

### Tiles

| Variable | Default | Meaning |
|---|---|---|
| `TileRadius` | `10` | Tile corner radius |
| `TileBorderWidth` | `1` | Tile border width |
| `ColorTile` | `255,255,255,10` | Tile fill |
| `ColorTileBorder` | `255,255,255,14` | Tile border |
| `FontLabel` | `#FontTitle#` | Label font (STATUS / VIEWERS / UPTIME) |
| `LabelSize` | `7` | Label font size |
| `ColorLabel` | `#ColorDim#` | Label text color |
| `ColorLabelIcon` | `#ColorAccent#` | Small icon in front of the label |
| `FontValue` | `#FontTitle#` | Value font |
| `ValueSize` | `11` | Value font size |
| `ColorValue`, `ColorValue2` | `#ColorText#` | Value gradient (top → bottom). The status value always uses `ColorLive`/`ColorOffline`. |
| `ValueEffect` | `None` | `None` / `Shadow` / `Border` |
| `ColorValueEffect` | `0,0,0,160` | Effect color |
| `TileValueShift1`, `2`, `3` | `0` | Moves the value of tile 1/2/3 horizontally (negative = left), e.g. to make room for an image |
| `TileValueX1`, `2`, `3` | `0` | Set in `server.ini` `[Variables]`. Extra horizontal offset of the value in tile 1/2/3 (negative = left), added on top of `TileValueShift<n>`; scaled by `Scale` |
| `TileValueY1`, `2`, `3` | `23` | Set in `server.ini` `[Variables]`. Vertical position of the value in tile 1/2/3, measured from the tile top; scaled by `Scale` |

### Image layers

PNG with transparency recommended; empty = layer off.

| Variable | Where | Size / aspect ratio |
|---|---|---|
| `ImgCardBack` | Behind everything, clipped to the rounded corners | Whole card, **stretched** to 280 : 276 |
| `ImgCardFront` | Above everything (decoration, flowers, …) | Whole card, stretched to 280 : 276 |
| `ImgPreviewFrame` | Above the preview (frames, ornaments), clipped to the preview | Preview, stretched to 16 : 9 |
| `ImgOffline` | Inside the preview, offline only | Preview, 16 : 9 (cropped to fill) |
| `ImgAvatar` | Header left, cropped to a circle | Square (cropped to fill) |
| `ImgTile1..3` | Inside tile 1/2/3 | Free, see below |

Tile images are positioned **relative to the top-left corner of their tile** (tile ≈ 79 × 50) and keep
their aspect ratio inside the given box:

| Variable | Default | Meaning |
|---|---|---|
| `TileImg<n>X`, `TileImg<n>Y` | `0`, `0` | Offset inside tile `<n>` |
| `TileImg<n>W`, `TileImg<n>H` | `40`, `40` | Box size |

Example – a small icon on the left side of the viewer tile, with the value moved right:

```ini
ImgTile2=#ImagesPath#36_eye.png
TileImg2X=6
TileImg2Y=17
TileImg2W=24
TileImg2H=24
TileValueShift2=12
```

---

## 6. Walkthrough A – a color theme

The quickest kind of theme. Start from `1.inc`:

```ini
[Variables]
ThemeName=Ocean
ColorBgTop=18,38,58,240
ColorBgBottom=8,16,28,240
ColorAccent=0,190,220,255
ColorAccent2=60,120,255,255
```

That alone gives a complete, consistent look, because icons, rings, label icons and hover colors derive from
`ColorAccent`. Then refine step by step, refreshing after each change (middle-click the skin):

```ini
; softer card
CardRadius=22
ColorBorder=0,190,220,40

; title with a gradient and shadow
ColorTitle=230,250,255,255
ColorTitle2=140,220,240,255
TitleEffect=Shadow

; tinted tiles
ColorTile=0,190,220,18
ColorTileBorder=0,190,220,40
ColorValue=230,250,255,255
```

Tips:

- An alpha below 255 on `ColorBgTop`/`ColorBgBottom` (e.g. `240`) lets the desktop shine through slightly.
- Keep enough contrast between `ColorValue` and `ColorTile` – the values are the most important information.

---

## 7. Walkthrough B – a full background image (see `33.inc`, `35.inc`)

Here you paint the whole card as one picture and the skin only draws the live data on top of it.

### Step 1 – Paint the image

- Canvas aspect ratio **280 : 276**. For a sharp result, paint at a multiple of the design grid, e.g.
  **1120 × 1103 px** (4×). Then every coordinate in section 4 is simply ×4.
- Paint everything decorative: background, frame, the tile boxes, tile icons and labels (STATUS / VIEWERS /
  UPTIME), a frame around the preview, an avatar ring, ornaments …
- **Do not** paint live values: streamer name, `twitch.tv/…`, viewer count, uptime, status text, LIVE badge.
  The skin draws those itself – they would appear twice.
- Keep the areas where the skin draws text calm and contrasting:
  - title/subtitle area right of x = 14 + `HeaderIndent`, y ≈ 10–45 (shifted by `HeaderIndentY`),
  - header buttons at the top right (x ≈ 205–270, y ≈ 12–30),
  - preview at x = 14…266, y = 58…200 (live: covered by the stream image; offline: your image shows through),
  - value line in each tile, around y ≈ 232–252.
- Leave the corners outside `CardRadius` empty or transparent – they are clipped anyway.
- Save as `@Resources\Themes\Images\<Nr>.png`.

Tip: lay a semi-transparent screenshot of the default skin (scaled to your canvas) over your drawing as a
guide layer, so tiles and preview line up exactly.

### Step 2 – Optional: avatar

Cut a square image of the avatar and save it as `<Nr>_avatar.png`. If the avatar ring is already part of the
background, place the avatar inside it with `AvatarSize` / `AvatarX` and disable the skin's own ring:

```ini
ImgAvatar=#ImagesPath#36_avatar.png
AvatarSize=17
AvatarX=-3.4
AvatarRingWidth=0
ColorAvatarRing=0,0,0,0
```

### Step 3 – Create the theme file

```ini
[Variables]
ThemeName=My Painting
ImgCardBack=#ImagesPath#36.png
CardRadius=12
```

Match `CardRadius` (and `PreviewRadius`) to the corners in your painting.

### Step 4 – Hide everything the image already contains

```ini
; card
BorderWidth=0
AccentBarHeight=0

; preview (frame is in the image; offline the background shows through)
ColorPreviewBg=0,0,0,0
PreviewBorderWidth=0
OfflineText=

; tiles (boxes, icons and labels are in the image)
ColorTile=0,0,0,0
TileBorderWidth=0
ColorLabel=0,0,0,0
ColorLabelIcon=0,0,0,0
```

### Step 5 – Colors that still matter

Even with a full image, these are still drawn by the skin:

```ini
; required – pick them from the image (used for avatar status dot outline, hover, play button)
ColorBgTop=117,106,105,255
ColorBgBottom=127,113,110,255
ColorAccent=240,184,150,255
ColorAccent2=235,160,114,255

; live status
ColorLive=215,15,25,255

; header text and buttons
FontTitle=Segoe UI Bold
TitleSize=16
ColorTitle=255,255,255,255
ColorTitle2=255,255,255,255
TitleEffect=Shadow
ColorSubtitle=255,255,255,255
ColorIcon=251,235,226,255
ColorIconHover=255,255,255,255

; values in the tiles
FontValue=Segoe UI Bold
ValueSize=13
ColorValue=20,20,20,255
ColorValue2=11,5,2,255
ValueEffect=Shadow
```

Use a color picker on your painting to take colors directly from it – that keeps the theme cohesive.

### Step 6 – Fine-tune

- If an icon or decoration painted into a tile collides with the value, move the value with
  `TileValueShift1..3` (e.g. `TileValueShift2=16`).
- If the viewer count is already in the tile and the preview overlay feels redundant: `HidePreviewViewers=1`.
- Lower `ColorPreviewShade` (e.g. `0,0,0,120`) if the dark gradient over the stream image is too strong.
- Decorations that should overlap the preview or the stream image (flowers growing over the frame, etc.) go
  into a separate transparent PNG as `ImgPreviewFrame` (preview only) or `ImgCardFront` (whole card).

### Result

- **Offline:** the preview area shows your painted background (plus `ImgOffline`/`OfflineText` if set).
- **Live:** the stream thumbnail lies on top of the preview area, the LIVE badge appears and the status turns red.

---

## 8. Troubleshooting

| Problem | Cause / fix |
|---|---|
| New theme does not appear when clicking through | Numbers have a gap – themes are counted from `1` up to the first missing number. |
| Changes are not visible | Save the file and refresh the skin (middle-click or the reload button). |
| Theme looks like the default / colors missing | The file must start with `[Variables]`. Check the spelling of variable names – they must match exactly. |
| Image does not show | Check the path (`#ImagesPath#36.png`) and file name. The card itself shows no error – look in the Rainmeter log (Manage → Log). |
| Image looks distorted | `ImgCardBack`, `ImgCardFront` and `ImgPreviewFrame` are stretched – use the exact aspect ratios 280 : 276 and 16 : 9. |
| Image looks blurry | Paint at a higher resolution (2×–4× of the design grid). |
| Text appears twice | The value is painted into the background image – remove it from the image. |
| Wrong font | The font is not installed – install it or place it in `@Resources\Fonts\`. |
| Element still visible although "removed" | Set its color alpha to `0` (e.g. `ColorTile=0,0,0,0`) or its width to `0`. |

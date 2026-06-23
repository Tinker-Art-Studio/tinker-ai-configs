# Product Principles — Tinker Art Studio

Use when making architectural decisions, starting a new app, or designing a feature that affects multiple surfaces.

## Stack defaults

| Layer | Choice | Notes |
|-------|--------|-------|
| Hosting | Netlify | Each deploy costs credits — always ask before running |
| Backend / DB | Firebase Firestore | Shared project: `tinker-hq-apps` |
| Auth | Firebase Auth | 3 roles: admin, manager, staff |
| Backend server (when needed) | Node.js / Express on Render | Auto-deploys from GitHub push, free tier |
| Frontend | Vanilla HTML + CSS + JS | No framework unless explicitly approved |
| Firestore rules | `/Users/christiehubley/studio-hub/firestore.rules` | Single source of truth, always `--only firestore:rules` |

## Firebase deploy discipline

- **NEVER** run bare `firebase deploy` — always `--only firestore:rules` (or `storage`, or `indexes`)
- **Always** run `cd /Users/christiehubley/studio-hub && npm test` before any rules deploy
- New Firestore collection → new rule block in the same commit
- Rules regression = data looks missing = check rules before assuming data loss

## Auth + access control

- **admin**: full access to everything
- **manager**: payroll, bookkeeping, KPI, hiring, all staff management
- **staff**: zero default access; access granted via `appAccess[]` array in their user doc
- New apps must be added to `MANAGER_ONLY_APPS` in `studio-hub/js/app.js` if manager-restricted

## Behavior defaults

- When the correct answer is obvious: just do it and tell Christie what you did
- When something is risky or irreversible: stop and explain before proceeding
- Approval phrase for pushes to GitHub, Netlify deploys, or shared system changes: **"yes, do it"**
- When Christie says "deploy": run `netlify deploy --prod` — don't ask about the mechanism

## Design system

Two brands share the same font stack but have distinct palettes. Source files: `~/Desktop/Logos, Branding, and Photos/Tinker Branding Sheet - FINAL.jpg` and `~/Downloads/Clay Hub Branding Sheet.png`.

### Fonts

| Role | Web (all apps) | Brand/Print only |
|------|---------------|-----------------|
| Primary / body | **Nunito** (Google Font, wght 400/600/700/800) | Futura PT Medium |
| Display / headers | Nunito 700–800 | Vinyl OT Regular (Tinker), P22 Nudgewink Pro Bold (Clay Hub logo only) |

**All existing apps already use Nunito** — keep it. Vinyl OT, Futura PT, and P22 Nudgewink are licensed print/marketing fonts; do not load them in web apps unless Christie has confirmed web licenses.

Load snippet (already in all apps — reuse this):
```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
```
CSS: `font-family: 'Nunito', -apple-system, BlinkMacSystemFont, sans-serif;`

---

### Tinker Art Studio palette

Use for: Studio Hub, KPI, Roster Manager, Summer Camp App, Classbook, Hiring, Payroll, Bookkeeping, Timeclock, Supply List, Materials Locator, Schedule Viewer, Private Events, Playbook, Training Hub, Social Media, Recap, Tinker Notes.

| Name | Hex (approx) | Use |
|------|-------------|-----|
| Purple | `#8B30BC` | Primary accent, active states |
| Orange-red | `#E8512B` | Alerts, destructive actions, warm CTA |
| Yellow | `#F9D42A` | Highlights, badges, sunny accent |
| Teal | `#2DAD8A` | Success states, secondary CTA |
| Pink | `#F5A8C2` | Soft accent, tags |
| Mint | `#AAE8E8` | Info backgrounds, light accent |
| Indigo | `#6052C8` | Navigation, secondary headings |
| Lavender | `#C8C0EA` | Backgrounds, subtle cards |
| White | `#FFFFFF` | Card backgrounds, modal backgrounds |

**Do not use generic blue (`#2563eb`) in Tinker apps** — use Purple (`#8B30BC`) or Indigo (`#6052C8`) instead.

CSS custom properties (add to `:root` in new Tinker apps):
```css
:root {
  --brand-purple:   #8B30BC;
  --brand-orange:   #E8512B;
  --brand-yellow:   #F9D42A;
  --brand-teal:     #2DAD8A;
  --brand-pink:     #F5A8C2;
  --brand-mint:     #AAE8E8;
  --brand-indigo:   #6052C8;
  --brand-lavender: #C8C0EA;
  --brand-white:    #FFFFFF;
  /* Functional mappings */
  --color-primary:  var(--brand-purple);
  --color-success:  var(--brand-teal);
  --color-warning:  var(--brand-yellow);
  --color-danger:   var(--brand-orange);
  --color-info:     var(--brand-mint);
}
```

---

### Clay Hub palette

Use for: Clay Hub Inventory, Clay Hub Booking, Clay Hub Membership.

| Name | Hex (approx) | Use |
|------|-------------|-----|
| Sage | `#7A8B5C` | Primary accent, headers |
| Peach | `#F5C4A8` | Soft backgrounds, cards |
| Coral | `#E87E6E` | Secondary CTA, warm accent |
| Burgundy | `#7A2218` | Deep accent, destructive |
| Orange-red | `#D44820` | Alert, active CTA |
| Blush | `#F0B8C8` | Tags, soft UI |
| Lavender | `#C0AADA` | Info, light accent |
| White | `#FFFFFF` | Card/modal backgrounds |
| Cream | `#E8EABF` | Page background, neutral |

CSS custom properties for Clay Hub apps:
```css
:root {
  --brand-sage:     #7A8B5C;
  --brand-peach:    #F5C4A8;
  --brand-coral:    #E87E6E;
  --brand-burgundy: #7A2218;
  --brand-orange:   #D44820;
  --brand-blush:    #F0B8C8;
  --brand-lavender: #C0AADA;
  --brand-cream:    #E8EABF;
  --brand-white:    #FFFFFF;
  --color-primary:  var(--brand-sage);
  --color-success:  var(--brand-sage);
  --color-warning:  var(--brand-orange);
  --color-danger:   var(--brand-burgundy);
}
```

---

### UI patterns (all apps)

- **Cards**: white background, `border-radius: 8–12px`, subtle shadow (`0 1px 4px rgba(0,0,0,0.08)`)
- **Buttons**: rounded (`border-radius: 6–8px`), Nunito 600, use `--color-primary` for primary action
- **Status pills/badges**: colored background from palette + white or dark text, `border-radius: 999px`
- **Sidebar** (admin apps): dark background (`#1a1a2e` or similar), white text, accent from Tinker palette
- **Tables**: `border-collapse: collapse`, alternating row shade (`rgba(0,0,0,0.02)`), hover highlight
- **Spacing**: 8px base unit (8, 16, 24, 32, 48)
- **Do not introduce a new visual pattern** without flagging it — consistency across apps matters
- When starting a new app: copy the CSS variables block from the closest existing app and swap in the palette above

## App UX standards

- Every app needs a "How to Use" help modal accessible to staff
- "Who's editing?" name prompt: generic placeholder, not Christie's name; persists after successful save
- Admin Settings page for configuration — avoid hard-coded values that require code changes
- Staff-facing apps: keep it simple; admin-facing: power features OK

## App registry (all share Firebase project `tinker-hq-apps`)

| App | Path | localhost | Hosting |
|-----|------|-----------|---------|
| Studio Hub | `~/studio-hub/` | 8082 | Netlify |
| Materials Locator | `~/tinker-materials/` | 8084 | Netlify |
| KPI Dashboard | `~/tinker-kpi/` | 8089 | Netlify |
| Clay Inventory | `~/clay-inventory-tracker/` | — | Netlify |
| Supply Low List | `~/tinker-supply-list/` | 8085 | Netlify |
| Clay Hub Booking | `~/clay-hub-booking/` | 8096 | — |
| Schedule Viewer | `~/schedule-viewer/` | 8090 | Netlify |
| Recap | `~/recap/` | 8091 | Render |
| Clay Hub Membership | `~/clay-hub-membership/` | 8083 | Render |
| Roster Manager | `~/roster-manager/` | 8092 | Netlify |
| Classbook | `~/tinker-spring-curriculum/` | 8087 | Netlify |
| Summer Camp App | `~/summer-camp-app/` | 8088 | Netlify |
| Hiring Pipeline | `~/tinker-hiring/` | — | Netlify |
| Payroll Tool | `~/payroll-tool/` | — | Netlify |
| Bookkeeping | `~/bookkeeping/` | 8094 | Netlify |
| Private Events | `~/private-events/` | 8095 | Netlify |
| Tinker Ticker | `~/tinker-timeclock/` | 8093 | Netlify |
| Social Media Mgr | `~/social-media-manager/` | 8097 | Render |
| Training Hub | `~/Documents/New project/` | 5173 | Netlify |
| Tinker Playbook | `~/tinker-playbook/` | 8098 | Netlify |
| Pimpneymouse Farm | `~/pimpneymouse-farm/` | 5175 | Netlify |
| Tinker Notes | `~/tinker-notes/` | 8099 | Render |

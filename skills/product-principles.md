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

## Design system (PENDING — audit in progress)

A formal design system is planned. Christie will provide brand guides and palettes. Until then:
- Match the existing app's visual style (card grids, dark sidebar where present)
- Common patterns observed: white cards with subtle shadow, action buttons in blue (`#2563eb` range), status badges as colored pills
- **Do not introduce a new visual pattern** without flagging it — consistency across apps matters
- When starting a new app: reference the closest existing app's CSS for spacing, typography, and color

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

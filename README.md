# TFT Trait Lock (SwiftUI Final Project)

TFT Set 17 Wordle-style champion guessing app aligned with the CPSC 357 project style in this directory (simple targets, `README_Run_In_Xcode.md`, iOS 17+, MVC folders).

## Quick Run Steps

1. Open `TFTTraitLock.xcodeproj` in this folder.
2. Pick an iPhone simulator or your personal iPhone.
3. Build and run.

## What This Demonstrates

### Gameplay (Set 17)
- Guess the hidden champion in up to 6 tries.
- Each guess reports **Trait** (matching trait names), **Cost** (↑ ↓ ✓), and **Range** (↑ ↓ ✓).
- **All 62 Set 17 units** appear in the bottom grid on the Play screen.
- Traits, costs, and ranges follow the assignment Set 17 roster.

### Required features
| Requirement | Where |
|---|---|
| 5+ functional screens | Play, Units, Stats, History, Settings |
| Presentation Card | Play toolbar → **Card** |
| SwiftData | `GameRecord` saved from Play → Stats/History |
| User input screen | Settings (name, mode, max guesses) |
| MVC organization | `Models/`, `Controllers/`, `Views/` |
| Animation / gesture | Flip-in guess rows; swipe up for hint |
| Advanced feature | **Local notifications** — daily puzzle reminder in Settings |
### Architecture (MVC)
- Models: `Champion`, `GuessFeedback`, `GameRecord`
- Controllers: `GameController` (rules/state), `NotificationService` (advanced)
- Views: SwiftUI screens and small components

Joshua Dowd — CPSC 357 Final Project

## Project Videos

- [Demo](https://youtu.be/nbKUNzA1MWY)
- [Tutorial](https://youtu.be/uwvlSGhse3A)

# VELTRIX WARFARE

An original Android-first military first-person shooter prototype built with **Godot 4.4.1** and **GDScript**.

> Enter the battlefield. Control the mission. Survive the war.

## Current implementation

Committed to the repository:

- First-person CharacterBody3D controller with keyboard/mouse and mobile joystick/touch-look.
- Walking, sprinting, crouching and jumping.
- Procedural low-poly rifle and forearm viewmodel attached to the first-person camera.
- Hitscan rifle with 30-round magazine, 90 reserve rounds, fire cooldown, reload and crosshair/ammo HUD.
- Three damageable static training targets.
- Three simple pursuing training bots with close-range attacks and health.
- Player health component and HUD.
- Landscape Android orientation and Android export preset.
- Godot headless import/startup validation workflow.
- Automated Android debug APK workflow (export pipeline currently being verified).

## Controls

### Android
- Left side: virtual movement joystick.
- Right side: drag to look around.
- FIRE: shoot.
- RELOAD: refill magazine from reserve.
- JUMP: jump.
- RUN: hold to sprint.
- CROUCH: hold to crouch.

### PC
- WASD: movement.
- Mouse: look.
- Left mouse button: fire.
- R: reload.
- Space: jump.
- Shift: sprint.
- Ctrl: crouch.
- Escape: release mouse capture; left click to recapture.

## Project layout

- `project.godot` — project configuration.
- `scenes/main.tscn` — training environment and gameplay scene.
- `scripts/player_controller.gd` — first-person movement.
- `scripts/mobile_controls.gd` — multi-touch mobile controls.
- `scripts/weapon_controller.gd` — hitscan rifle, ammo and HUD.
- `scripts/weapon_viewmodel.gd` — procedural rifle and forearms.
- `scripts/player_health.gd` — player health and HUD.
- `scripts/training_target.gd` — damageable target component.
- `scripts/training_bot.gd` — basic pursuit and attack AI.
- `export_presets.cfg` — Android export preset.
- `.github/workflows/` — Godot validation and Android debug build workflows.

## Target platforms

- Android — primary development and testing target.
- PC — secondary target, to be brought up to parity after the core prototype is stable.

## Roadmap

1. Core first-person controller and mobile input — implemented, pending device testing.
2. Rifle firing, reload and HUD — implemented, pending device testing.
3. Training targets and basic pursuit bots — implemented, pending gameplay balancing.
4. First-person body and weapon presentation — basic procedural prototype committed, visual refinement pending.
5. Android debug APK build and installation test — pipeline verification in progress.
6. Enemy navigation, cover, ranged combat and difficulty.
7. Training map environment, sound and animation.
8. Campaign systems and mission progression.
9. Multiplayer architecture and modes.
10. Android optimization, PC compatibility and release preparation.

## Build and validation

The Godot validation workflow performs a headless editor import and startup smoke test. The Android workflow is intended to export a debug APK and upload it as a GitHub Actions artifact. A successful workflow run and artifact are required before an APK can be considered available.

Android export requires Godot 4.4.1 export templates and a compatible Android SDK/JDK toolchain.

## Licensing

This repository is publicly visible, but no open-source licence has been granted. All rights are reserved by the project owner unless separate written permission is provided.

---

**VELTRIX WARFARE**  
*Enter the battlefield. Control the mission. Survive the war.*

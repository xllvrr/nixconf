# Agent Guide

## Scope and Priorities

This is a personal NixOS and Home Manager flake for one machine. Prefer small,
direct changes that preserve the owner's current desktop behavior over broad
abstractions or speculative cleanup.

- Preserve user changes. The worktree may be dirty; never revert, overwrite, or
  reformat unrelated work.
- Inspect the current configuration and relevant Git history before reviving a
  removed package or approach. Several integrations have been tried and backed
  out for runtime reasons that evaluation alone did not reveal.
- Keep the flake plain. Do not introduce `flake-parts` unless the repository
  grows multiple hosts or systems, substantial `packages`, `checks`, or
  `devShells`, or reusable exported modules.
- Do not change `system.stateVersion` or `home.stateVersion` as part of routine
  upgrades or refactors.
- Do not update `flake.lock` unless the task intentionally changes or updates
  inputs.

## Current System

- Host: `NixDesktop`
- Architecture: `x86_64-linux`
- User: `xllvr`
- Stable package set: NixOS `26.05`
- Additional package set: `nixpkgs-unstable`, exposed as `pkgsUnstable`
- Home Manager is embedded in the NixOS configuration.
- Niri is the only active compositor/session. Greetd defaults to
  `niri-session`.
- Chromium is the active browser. Firefox has a retained but unimported Home
  Manager module.
- Noctalia is the active desktop shell and bar.
- Stylix supplies the shared Kanagawa theme and wallpaper.

## Repository Layout and Ownership

- `flake.nix` owns inputs, stable/unstable package sets, the explicit unfree
  allowlist, `repoRoot`, the custom `my-neovim` package, and
  `nixosConfigurations.NixDesktop`.
- `hosts/NixDesktop/configuration.nix` owns host-level NixOS settings and the
  active NixOS module imports.
- `hosts/NixDesktop/home.nix` owns user-level settings and the active Home
  Manager module imports.
- `hosts/NixDesktop/hardware.nix` contains machine-specific filesystems,
  hardware, printing, Bluetooth, and PipeWire configuration. Avoid casual edits
  here.
- `modules/nixos/` contains system modules and system-level suites.
- `modules/home/` contains Home Manager apps, services, suites, compositor
  configuration, and local scripts.
- `configs/` contains external application assets.
- `standalones/nvf/nvf.nix` builds `packages.x86_64-linux.my-neovim`.

Put host-specific settings in the host files and reusable configuration in the
appropriate module tree. Install user applications through Home Manager unless
they provide a system service, session, hardware integration, or other
machine-wide behavior.

## Import and Path Conventions

- Keep host and suite imports as literal relative paths so native Neovim `gf`
  navigation works.
- Use `repoRoot` for modules that read external assets under `configs/`; do not
  add new brittle paths such as `../../../../configs/...`.
- `repoRoot`, `inputs`, and `pkgsUnstable` are supplied through special args.
- Use `pkgsUnstable` only for packages that deliberately need it; stable
  `pkgs` remains the default.
- Keep internal options under `xllvr.*`. Avoid broad, collision-prone option
  names.
- Prefer suite modules only when they aggregate a real group of imports. Do not
  add `default.nix` files merely to shorten paths.
- Keep small local utilities in `modules/home/scripts.nix`; split them only when
  that file becomes meaningfully hard to maintain.

## Fragile or Intentional Configuration

- Fcitx5 spans NixOS packages, global Wayland/input-method environment
  variables, and Home Manager configuration. The Qt plugin path and input method
  variables are deliberate. Previous changes addressed Qt6/Fcitx/Noctalia
  crashes; do not simplify them without runtime evidence.
- Noctalia uses its current Home Manager module and the TOML asset at
  `configs/noctalia/config.toml`. Old v4 rollback notes are historical, not the
  active configuration.
- FreeTube's `settings.db` is newline-delimited JSON managed independently with
  `force = true`. History includes a bad Home Manager symlink; do not replace
  this with an unverified directory-level link or merge.
- Yazi settings must follow current Yazi tables; hidden-file visibility belongs
  under `programs.yazi.settings.mgr.show_hidden`.
- The custom Neovim configuration has a Nix-specific `gf` helper for expressions
  such as `repoRoot + "/configs/..."`; native `gf` handles literal imports.
- The unfree predicate in `flake.nix` is intentionally explicit. Add package
  names only when an enabled system package requires them, and remove stale
  entries when the package is removed.

## Editing and Verification

- Use `nixfmt` on touched Nix files only. Do not mass-format unrelated files and
  do not add a formatter dependency.
- Always run `git diff --check` after editing.
- Prefer these repository checks:

  ```sh
  nix flake check --no-build
  nix flake show --allow-import-from-derivation
  ```

- Use targeted `nix eval` checks for changed options, packages, generated text,
  or enabled services.
- Git-backed flake evaluation ignores new untracked files. Before they are
  staged, validate the working tree with an explicit path flake such as:

  ```sh
  nix flake check --no-build path:$PWD
  ```

- For runtime-sensitive integrations, use a targeted `nix build --no-link` and
  run a harmless command such as `--version` when available.
- Avoid leaving `result` symlinks; use `--no-link` or evaluate derivation/output
  paths when a link is unnecessary.
- Do not run `nixos-rebuild switch` unless the user asks to apply the system
  change. The normal handoff command is:

  ```sh
  sudo nixos-rebuild switch --flake .#NixDesktop
  ```

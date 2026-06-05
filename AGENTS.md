# Agent Guide

## Working Rules

- Preserve user changes. The worktree may be dirty; do not revert or overwrite unrelated changes.
- Keep this as a plain flake. Do not introduce `flake-parts` unless the repo grows multiple hosts or systems, substantial `packages`, `checks`, or `devShells`, or reusable exported modules.
- Keep host and suite imports as literal relative paths so Neovim `gf` works for navigation.
- Use `repoRoot` for modules that read external config assets from `configs/`; avoid brittle deep paths like `../../../../configs/...`.
- Keep local options namespaced under `xllvr.*`; avoid broad global option names for internal modules.
- Prefer small suite aggregators when they group real imports. Do not add `default.nix` index files just to shorten imports.
- Keep scripts together in `modules/home/scripts.nix` unless the module grows enough that splitting clearly improves maintenance.
- Use `nixfmt` for touched Nix files. Do not add a formatter dependency.
- For verification, prefer `nix flake check --no-build`, `nix flake show --allow-import-from-derivation`, and targeted `nix eval` checks.
- Avoid leaving build symlinks such as `result`; use `--no-link` or eval derivation paths when a build output link is not needed.

## Repo Overview

This is a personal NixOS and Home Manager flake for one host, `NixDesktop`, on `x86_64-linux`.

- `flake.nix` wires inputs, package sets, the custom `my-neovim` package, and `nixosConfigurations.NixDesktop`.
- `hosts/NixDesktop/configuration.nix` owns host-level NixOS settings: boot, users, services, locale, input method, system packages, and imported NixOS modules.
- `hosts/NixDesktop/home.nix` owns user-level Home Manager settings: user packages, shell aliases, XDG directories, feature flags, and imported Home Manager modules.
- `modules/nixos/` contains reusable NixOS modules and suites.
- `modules/home/` contains reusable Home Manager modules, app configs, services, window-manager config, suites, and local scripts.
- `configs/` contains external config assets consumed by modules through `repoRoot`.
- `standalones/` contains standalone application configs, including the `nvf` config used to build `packages.x86_64-linux.my-neovim`.

## Current Conventions

- Home Manager modules that read external assets receive `repoRoot` from `home-manager.extraSpecialArgs`.
- The Waybar feature flag is `xllvr.desktop.waybar.enable`.
- Yazi settings must match current Yazi tables; for example hidden files belong under `programs.yazi.settings.mgr.show_hidden`.
- The custom Neovim config includes a Nix-only `gf` helper for expressions like `repoRoot + "/configs/..."`, while native `gf` handles literal imports.

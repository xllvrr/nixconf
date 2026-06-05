# nixconf

Personal NixOS and Home Manager configuration for `NixDesktop`.

## Layout

- `flake.nix` wires inputs, packages, and the `NixDesktop` system output.
- `hosts/NixDesktop/configuration.nix` owns host-level NixOS settings.
- `hosts/NixDesktop/home.nix` owns user-level Home Manager settings.
- `modules/nixos/` contains reusable NixOS modules and suites.
- `modules/home/` contains reusable Home Manager modules and suites.
- `configs/` contains external config assets read by modules through `repoRoot`.
- `standalones/` contains standalone configs, including the custom `nvf` package.

Host and suite imports intentionally stay as literal relative paths so Vim `gf` works while navigating the repo.

## Common Commands

```sh
nix flake check --no-build
nix flake show --allow-import-from-derivation
sudo nixos-rebuild switch --flake .#NixDesktop
```

`nh` is configured to use `/home/xllvr/nixconf` as the flake path.

## Where To Add Things

- System services, users, boot, locale, networking, and host packages: `hosts/NixDesktop/configuration.nix`.
- User packages, shell aliases, XDG directories, and Home Manager feature flags: `hosts/NixDesktop/home.nix`.
- Reusable system modules: `modules/nixos/`.
- Reusable Home Manager modules: `modules/home/`.
- External app config files: `configs/`, passed to modules with `repoRoot`.

## Notes

The repo currently uses a plain flake. Reconsider `flake-parts` only if this grows into multiple hosts or systems, gains substantial `packages`, `checks`, or `devShells`, or starts exporting reusable modules. Relevant references: <https://flake.parts> and <https://flake.parts/options/home-manager.html>.

Uncommitted local changes are expected while iterating. Do not revert unrelated dirty files during cleanup work.

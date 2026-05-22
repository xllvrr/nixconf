Noctalia config in this repo

`modules/home/apps/os/noctalia.nix` reads `configs/noctalia/settings.json`, but it only applies the `.settings` object.

After editing, you must redeploy (Home Manager / NixOS rebuild). The effective file is a Home Manager-managed symlink at `~/.config/noctalia/settings.json`.

Quick checks:
- Repo config (desired): `jq '.settings.bar.widgets.left' configs/noctalia/settings.json`
- Deployed config (actual): `jq '.bar.widgets.left' ~/.config/noctalia/settings.json`

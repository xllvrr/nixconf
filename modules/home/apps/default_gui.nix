{ pkgs, ... }: {
  # Always installed GUIs
  home.packages = with pkgs; [
    # Productivity
    obsidian
    zathura
    system-config-printer

    # Health
    safeeyes

    # Music
    cava
    pulsemixer
    qpwgraph

    # Terminal
    kitty
    fuzzel
  ];
}

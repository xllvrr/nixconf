{pkgs, ...}: {
  programs.niri.enable = true;

  # Niri uses xwayland-satellite for X11 apps.
  environment.systemPackages = [
    pkgs.xwayland-satellite
  ];

  # Wayland portals (screen share, file pickers, sandboxed apps).
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };
}

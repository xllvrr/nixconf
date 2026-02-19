{
  config,
  pkgs,
  pkgsUnstable,
  inputs,
  lib,
  ...
}: {
  # Mako settings
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      borderRadius = "8";
      borderSize = "1";
      icons = "true";
      layer = "overlay";
      maxVisible = "3";
      padding = "10";
      width = "300";
    };
  };
}

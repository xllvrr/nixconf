{
  pkgs,
  lib,
  config,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = let
        tuigreet = "${lib.getExe pkgs.greetd.tuigreet}";
        baseSessionsDir = "${config.services.displayManager.sessionData.desktops}";
        xSessions = "${baseSessionsDir}/share/xsessions";
        waylandSessions = "${baseSessionsDir}/share/wayland-sessions";
        tuigreetOptions = [
          "--remember"
          "--remember-session"
          "--sessions ${waylandSessions}:${xSessions}"
          "--time"
          # Make sure theme is wrapped in single quotes. See https://github.com/apognu/tuigreet/issues/147
          "--theme 'border=blue;text=cyan;prompt=green;time=red;action=blue;button=white;container=black;input=red'"
          "--cmd sway"
        ];
        flags = lib.concatStringsSep " " tuigreetOptions;
      in {
        command = "${tuigreet} ${flags}";
        user = "greeter";
      };
    };
  };
}

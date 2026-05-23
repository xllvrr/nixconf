{
  pkgs,
  inputs,
  lib,
  config,
  configRoot,
  ...
}: {
  options = {
    waybar.enable = lib.mkEnableOption "enable waybar";
  };

  config = lib.mkIf config.waybar.enable {
    # =============================================================================
    # WAYBAR CONFIG (JSON)
    # =============================================================================
    xdg.configFile = let
      # Icons for sway workspaces (numeric workspace -> glyph).
      swayWorkspaceIcons = {
        "1" = "";
        "2" = "󰈹";
        "3" = "";
        "4" = "";
        "5" = "";
        "6" = "󱞁";
        "7" = "󰽰";
        "8" = "";
        "9" = "";
      };

      # Shared bar configuration used for both sway and niri variants.
      baseBar = {
        layer = "bottom";
        position = "top";
        height = 40;
        spacing = 8;
        margin-top = 6;
        margin-left = 8;
        margin-right = 8;

        modules-center = ["clock"];
        modules-right = ["tray" "network" "pulseaudio" "bluetooth"];

        tray = {
          icon-size = 18;
          spacing = 10;
        };
        clock = {format = "{:%a %d %b %H:%M}";};
        network = {
          format-wifi = "{essid} ";
          format-ethernet = "{ifname} = {ipaddr}/{cidr} ";
          format-disconnected = "Disconnected ⚠";
          on-click = "${pkgs.bash}/bin/bash -lc 'noctalia-shell ipc call network togglePanel || fuzzwifi'";
        };
        pulseaudio = {
          format = " {volume}%";
          format-bluetooth = " {volume}%";
          format-muted = "";
          on-click = "${pkgs.bash}/bin/bash -lc 'noctalia-shell ipc call volume togglePanel || kitty --detach --class floating pulsemixer'";
        };
        bluetooth = {
          format = "";
          on-click = "${pkgs.bash}/bin/bash -lc 'noctalia-shell ipc call bluetooth togglePanel || blueman-manager'";
        };
      };

      # Sway-specific modules
      swayBar =
        baseBar
        // {
          modules-left = ["sway/workspaces"];
          "sway/workspaces" = {
            "disable-scroll" = true;
            "all-outputs" = false;
            "format" = "{icon}";
            "format-icons" = swayWorkspaceIcons;
            "on-click" = "activate";
          };
        };

      # Niri-specific modules
      niriBar =
        baseBar
        // {
          modules-left = ["niri/workspaces"];
          "niri/workspaces" = {
            "disable-click" = false;
            "all-outputs" = false;
            # Show the workspace name when set; fall back to the index otherwise.
            "format" = "{value}";
          };
        };
    in {
      "waybar/config".text = builtins.toJSON [swayBar];
      "waybar/config-sway".text = builtins.toJSON [swayBar];
      "waybar/config-niri".text = builtins.toJSON [niriBar];
    };

    # =============================================================================
    # WAYBAR THEME (CSS)
    # =============================================================================
    programs.waybar = {
      enable = true;
      style = with config.lib.stylix.colors.withHashtag;
        ''
          @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
          @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};

          @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
          @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};
        ''
        + builtins.readFile (configRoot + "/waybar/style.css");
    };
  };
}

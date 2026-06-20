{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.stylix.targets.kmscon;

  applyOverride =
    name: option: value:
    let
      inherit (option) override;
    in
    if override == null then
      value
    else if builtins.typeOf override != builtins.typeOf value then
      throw "stylix: expected `config.stylix.targets.kmscon.${name}.override` to be a ${builtins.typeOf value}, but got: ${builtins.typeOf override}"
    else if builtins.isAttrs override then
      lib.recursiveUpdate value override
    else
      override;

  fonts = applyOverride "fonts" cfg.fonts config.stylix.fonts;
  colors = applyOverride "colors" cfg.colors config.lib.stylix.colors;

  formatBase =
    name:
    let
      getComponent = comp: colors."${name}-rgb-${comp}";
    in
    "${getComponent "r"},${getComponent "g"},${getComponent "b"}";
in
{
  disabledModules = [
    (inputs.stylix + "/modules/kmscon/nixos.nix")
  ];

  options.stylix.targets.kmscon = {
    enable = config.lib.stylix.mkEnableTarget "kmscon" true;

    fonts = {
      enable = lib.mkEnableOption "`config.stylix.fonts` for kmscon" // {
        default = true;
        example = false;
      };

      override = lib.mkOption {
        default = null;
        description = ''
          Attribute sets are recursively merged with `config.stylix.fonts`,
          while all other non-`null` types override it.
        '';
        type = lib.types.anything;
      };
    };

    colors = {
      enable = lib.mkEnableOption "`config.lib.stylix.colors` for kmscon" // {
        default = true;
        example = false;
      };

      override = lib.mkOption {
        default = null;
        description = ''
          Attribute sets are recursively merged with `config.lib.stylix.colors`,
          while all other non-`null` types override it.
        '';
        type = lib.types.anything;
      };
    };
  };

  config = lib.mkIf (config.stylix.enable && cfg.enable) {
    services.kmscon = {
      fonts = lib.mkIf cfg.fonts.enable [
        {
          inherit (fonts.monospace) name package;
        }
      ];

      extraConfig = lib.mkMerge [
        (lib.mkIf cfg.fonts.enable ''
          font-size=${toString fonts.sizes.terminal}
        '')
        (lib.mkIf cfg.colors.enable ''
          palette=custom
          palette-black=${formatBase "base00"}
          palette-red=${formatBase "base08"}
          palette-green=${formatBase "base0B"}
          palette-yellow=${formatBase "base0A"}
          palette-blue=${formatBase "base0D"}
          palette-magenta=${formatBase "base0E"}
          palette-cyan=${formatBase "base0C"}
          palette-light-grey=${formatBase "base05"}
          palette-dark-grey=${formatBase "base03"}
          palette-light-red=${formatBase "base08"}
          palette-light-green=${formatBase "base0B"}
          palette-light-yellow=${formatBase "base0A"}
          palette-light-blue=${formatBase "base0D"}
          palette-light-magenta=${formatBase "base0E"}
          palette-light-cyan=${formatBase "base0C"}
          palette-white=${formatBase "base07"}
          palette-background=${formatBase "base00"}
          palette-foreground=${formatBase "base05"}
        '')
      ];
    };
  };
}

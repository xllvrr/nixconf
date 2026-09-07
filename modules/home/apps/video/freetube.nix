{
  config,
  lib,
  pkgs,
  ...
}:
let
  settings = {
    autoplayVideos = false;
    backendFallback = true;
    backendPreference = "local";
    baseTheme = "system";
    checkForUpdates = false;
    currentLocale = "system";
    defaultQuality = "auto";
    defaultVideoFormat = "dash";
    defaultViewingMode = "theatre";
    region = "SG";
    rememberSearchHistory = false;
    sponsorBlockShowSkippedToast = false;
    useSponsorBlock = true;
  };

  settingDocs = lib.mapAttrsToList (_id: value: {
    inherit _id value;
  }) settings;
in
{
  home.packages = with pkgs; [
    freetube
  ];

  home.activation.freetubeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings_dir="${config.xdg.configHome}/FreeTube"
    settings_file="$settings_dir/settings.db"
    tmp_file="$settings_file.hm-tmp"

    mkdir -p "$settings_dir"
    touch "$settings_file"

    ${pkgs.jq}/bin/jq -s -c --argjson managed '${builtins.toJSON settingDocs}' '
      (map(select(has("_id"))) | map({ key: ._id, value: . }) | from_entries) as $existing
      | ($managed | map({ key: ._id, value: . }) | from_entries) as $managedById
      | ($existing * $managedById)
      | to_entries[]
      | .value
    ' "$settings_file" > "$tmp_file"

    mv "$tmp_file" "$settings_file"
    chmod 0600 "$settings_file"
  '';
}

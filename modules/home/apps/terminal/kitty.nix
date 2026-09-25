{ pkgs, ... }:

{
  programs.kitty = {

    enable = true;

    settings = {

      # Tabs
      tab_bar_edge = "top";
      tab_title_template = " {title} ";
      active_tab_title_template = " {title} ● ";
      tab_bar_min_tabs = 2;

      # Appearance
      window_padding_width = "15 15";

      # Other functionality
      copy_on_select = "yes";

    };

    keybindings = {
      "alt+c" = "copy_to_clipboard";
      "alt+v" = "paste_from_clipboard";
    };

    extraConfig = ''
      mouse_map middle release ungrabbed paste_from_clipboard
      mouse_map left triplepress ungrabbed mouse_selection line
    '';
  };
}

{ pkgs, ... }:

{
    programs.kitty = {

        enable = true;

        settings = {

            # For nnn previews
            allow_remote_control = "yes";
            listen_on = "unix:$TMPDIR/kitty";
            enable_layouts = "splits";

            # Tabs
            tab_bar_edge = "top";
            tab_title_template = " {title} ";
            active_tab_title_template = " {title} ● ";
            tab_bar_min_tabs = 2;

            # Appearance
            window_padding_width = "15 15";
            background_opaicty = 0.8;

            # Other functionality
            copy_on_select = "yes";

        };

        keybindings = {
            "alt+c" = "copy_to_clipboard";
            "alt+v" =  "paste_from_clipboard";
        };

        extraConfig = ''
            mouse_map middle release ungrabbed paste_from_clipboard
            mouse_map left triplepress ungrabbed mouse_selection line
        '';
    };
}

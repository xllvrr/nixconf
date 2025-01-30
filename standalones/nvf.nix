{ pkgs, lib, ... }:

{

    vim = {

        theme = {
            enable = true;
            name = "gruvbox";
            style = "dark";
        };

        options = {
            tabstop = 4;
            shiftwidth = 4;
        };

        # Copy to system clipboard for ease
        useSystemClipboard = true;

        # Added functionality
        mini.ai.enable = true;
        mini.align.enable = true;
        mini.splitjoin.enable = true;
        mini.operators.enable = true;
        mini.bracketed.enable = true;
        mini.pick.enable = true;

        # Brackets
        mini.pairs.enable = true;
        mini.surround.enable = true;

        # File management
        mini.files.enable = true;

        # Autocompletion
        autocomplete.nvim-cmp.enable = true;
        mini.icons.enable = true;

        statusline.lualine.enable = true;
        # telescope.enable = true;

        ui.colorizer.enable = true;

        # LSP settings
        languages = {
            enableLSP = true;
            enableTreesitter = true;
            enableFormat = true;

            nix.enable = true;
            r.enable = true;
            lua.enable = true;
        };

        keymaps = [
            # Easy window changing
            { key = "<C-H>"; mode = "n"; silent = true; action = "<C-W>H"; }
            { key = "<C-J>"; mode = "n"; silent = true; action = "<C-W>J"; }
            { key = "<C-K>"; mode = "n"; silent = true; action = "<C-W>K"; }
            { key = "<C-L>"; mode = "n"; silent = true; action = "<C-W>L"; }
            # Using Mini.Files
            { key = "<leader>e"; mode = "n"; silent = true; action = ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))"; desc = "Opens Mini.Files in directory of current file"; }
            { key = "<leader>E"; mode = "n"; silent = true; action = ":lua MiniFiles.open()"; desc = "Opens Mini.Files in cwd"; }
            # Using Mini.Pick
            { key = "<leader>ff"; mode = "n"; silent = true; action = ":Pick files"; desc = "Opens file picker"; }
            { key = "<leader>fg"; mode = "n"; silent = true; action = ":Pick grep_live"; desc = "Picks based on grep with live results"; }
        ];

    };

}

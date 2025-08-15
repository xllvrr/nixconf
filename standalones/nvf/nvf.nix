{
  pkgs,
  lib,
  ...
}: {
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
    clipboard = {
      enable = true;
      registers = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    # Added functionality
    mini.ai.enable = true;
    mini.align.enable = true;
    mini.cursorword.enable = true;
    mini.splitjoin.enable = true;
    mini.operators.enable = true;
    mini.pick.enable = true;
    mini.indentscope.enable = true;
    mini.diff.enable = true;
    mini.move.enable = true;
    mini.jump.enable = true;
    mini.extra.enable = true;

    # Brackets
    mini.pairs.enable = true;
    mini.surround.enable = true;
    mini.bracketed.enable = true;

    # File management
    mini.files.enable = true;
    mini.fuzzy.enable = true;

    # Autocompletion
    autocomplete = {
      # nvim-cmp.enable = true;
      blink-cmp = {
        enable = true;
        setupOpts = {
          keymap.preset = "super-tab";
        };
      };
    };
    mini.icons.enable = true;

    # Status Line
    mini.statusline.enable = true;

    # Colorizer
    ui.colorizer.enable = true;

    # LSP settings
    lsp = {
      enable = true;
      trouble.enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
    };

    languages = {
      enableTreesitter = true;
      enableFormat = true;

      nix.enable = true;
      r.enable = true;
      lua.enable = true;
      python.enable = true;
    };

    diagnostics.enable = true;

    # Formatting
    formatter.conform-nvim = {
      enable = true;
    };

    # Snippets
    autocomplete.blink-cmp.friendly-snippets.enable = true;
    mini.snippets = {
      enable = true;
      setupOpts = {
        snippets = {
          from_file = "snippets/global.json";
        };
      };
    };

    keymaps = [
      # Easy window changing
      {
        key = "<C-H>";
        mode = "n";
        silent = true;
        action = "<C-W>H";
      }
      {
        key = "<C-J>";
        mode = "n";
        silent = true;
        action = "<C-W>J";
      }
      {
        key = "<C-K>";
        mode = "n";
        silent = true;
        action = "<C-W>K";
      }
      {
        key = "<C-L>";
        mode = "n";
        silent = true;
        action = "<C-W>L";
      }
      # Using Mini.Files
      {
        key = "<leader>e";
        mode = "n";
        silent = true;
        action = ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>";
        desc = "Opens Mini.Files in current dir";
      }
      {
        key = "<leader>E";
        mode = "n";
        silent = true;
        action = ":lua MiniFiles.open()<CR>";
        desc = "Opens Mini.Files in cwd";
      }
      # Using Mini.Pick
      {
        key = "<leader>ff";
        mode = "n";
        silent = true;
        action = ":Pick files<CR>";
        desc = "Opens file picker";
      }
      {
        key = "<leader>fg";
        mode = "n";
        silent = true;
        action = ":Pick grep_live<CR>";
        desc = "Picks based on grep with live results";
      }
      # Using trouble
      {
        key = "<leader>xx";
        mode = "n";
        silent = true;
        action = "<cmd>Trouble diagnostics toggle<CR>";
        desc = "Diagnostics (Trouble)";
      }
      {
        key = "<leader>cl";
        mode = "n";
        silent = true;
        action = "<cmd>Trouble lsp toggle focus=false win.position=right<CR>";
        desc = "LSP definitions, references, ... (Trouble)";
      }
    ];
  };
}

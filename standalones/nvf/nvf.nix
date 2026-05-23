{
  pkgs,
  lib,
  ...
}: {
  vim = {
    # =============================================================================
    # THEME / UI
    # =============================================================================
    theme = {
      enable = true;
      name = "catppuccin";
      style = "macchiato";
    };

    # =============================================================================
    # EDITOR OPTIONS
    # =============================================================================
    options = {
      tabstop = 4;
      shiftwidth = 4;
      softtabstop = 4;
      expandtab = true;
    };

    # =============================================================================
    # CLIPBOARD
    # =============================================================================
    # Copy to system clipboard for ease
    clipboard = {
      enable = true;
      registers = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    # =============================================================================
    # MINI.NVIM (QUALITY OF LIFE)
    # =============================================================================
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

    # =============================================================================
    # COMPLETION
    # =============================================================================
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

    # =============================================================================
    # STATUSLINE / DIAGNOSTICS
    # =============================================================================
    # Status Line
    mini.statusline.enable = true;

    # Colorizer
    ui.colorizer.enable = true;

    # =============================================================================
    # LSP / LANGUAGES / FORMATTING
    # =============================================================================
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
      python.enable = true;
      lua.enable = true;
      bash.enable = true;
    };

    diagnostics.enable = true;

    # LSP Settings
    luaConfigRC.basedpyright_and_conform_tuning = ''
      -- Keep basedpyright inlay hints, but disable them while actively typing
      -- so they do not interfere with cursor/editing flow.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not (client and client.name == "basedpyright") then
            return
          end

          local bufnr = args.buf
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

          local group = vim.api.nvim_create_augroup("BasedPyrightInlayHintMode" .. bufnr, { clear = true })
          vim.api.nvim_create_autocmd("InsertEnter", {
            group = group,
            buffer = bufnr,
            callback = function()
              vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            end,
          })
          vim.api.nvim_create_autocmd("InsertLeave", {
            group = group,
            buffer = bufnr,
            callback = function()
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end,
          })
        end,
      })
    '';

    # Formatting
    formatter.conform-nvim = {
      enable = true;
      setupOpts = {
        format_on_save = {
          timeout_ms = 500;
          lsp_fallback = true;
        };
      };
    };

    # =============================================================================
    # SNIPPETS
    # =============================================================================
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

    # =============================================================================
    # KEYMAPS
    # =============================================================================
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
      # Using conform
      {
        key = "<leader>cf";
        mode = "n";
        silent = true;
        action = ":lua require('conform').format({ async = true, lsp_fallback = true })<CR>";
        desc = "Format current buffer";
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

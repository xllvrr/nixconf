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

    utility = {
      surround.enable = true;
    };

    statusline.lualine.enable = true;
    telescope.enable = true;
    filetree.neo-tree.enable = true;

    autopairs.nvim-autopairs.enable = true;

    autocomplete.nvim-cmp.enable = true;
    ui.colorizer.enable = true;

    languages = {
      enableLSP = true;
      enableTreesitter = true;
      enableFormat = true;

      nix.enable = true;
      r.enable = true;
      lua.enable = true;
    };
    
    keymaps = [
      { key = "<C-H>"; mode = "n"; silent = true; action = "<C-W>H"; }
      { key = "<C-J>"; mode = "n"; silent = true; action = "<C-W>J"; }
      { key = "<C-K>"; mode = "n"; silent = true; action = "<C-W>K"; }
      { key = "<C-L>"; mode = "n"; silent = true; action = "<C-W>L"; }
    ];

  };

}

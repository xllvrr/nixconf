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
    autocomplete.nvim-cmp.enable = true;

    languages = {
      enableLSP = true;
      enableTreesitter = true;

      nix.enable = true;
      r.enable = true;
      lua.enable = true;
    };

  };

}

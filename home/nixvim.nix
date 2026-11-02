{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;

    opts = {
      number = true;
      relativenumber = true;
      mouse = "a";
      termguicolors = true;
      foldenable = false;
      scrolloff = 8;

      ignorecase = true;
      smartcase = true;
      incsearch = true;
      hidden = true;
    };

    clipboard.register = "unnamedplus";

    plugins = {
      telescope.enable = true;
      lualine.enable = true;
      nvim-autopairs.enable = true;
    };
  };
}


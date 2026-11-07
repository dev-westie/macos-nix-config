_: {
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

    extraConfigLua = ''
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local argc = vim.fn.argc()
          local dir = argc == 1 and vim.fn.fnamemodify(vim.fn.argv(0), ":p") or nil

          if dir and vim.fn.isdirectory(dir) == 1 then
            local dirbuf = vim.api.nvim_get_current_buf()
            vim.cmd.cd(vim.fn.fnameescape(dir))
            vim.cmd.enew()
            vim.api.nvim_buf_delete(dirbuf, { force = true })
            vim.schedule(function()
              require("telescope.builtin").find_files()
            end)
          elseif argc == 0 and vim.fn.line2byte(vim.fn.line("$") + 1) <= 2 then
            vim.schedule(function()
              require("telescope.builtin").find_files()
            end)
          end
        end,
      })
    '';
  };
}

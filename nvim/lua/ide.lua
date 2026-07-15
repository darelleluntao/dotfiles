local ok_neotree, neotree = pcall(require, "neo-tree")
if ok_neotree then
  neotree.setup({
    close_if_last_window = true,
    popup_border_style = "single",
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },
    window = {
      width = 32,
      mappings = {
        ["<space>"] = "none",
      },
    },
  })

  vim.keymap.set("n", "<leader>n", "<cmd>Neotree toggle<cr>", { silent = true, desc = "Toggle Neo-tree" })
  vim.keymap.set("n", "<leader>o", "<cmd>Neotree focus<cr>", { silent = true, desc = "Focus Neo-tree" })
end

local ok_treesitter, treesitter = pcall(require, "nvim-treesitter")
if ok_treesitter then
  treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })

  local tree_filetypes = {
    "bash",
    "css",
    "dart",
    "go",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "typescript",
    "typescriptreact",
    "tsx",
    "vim",
    "vimdoc",
    "yaml",
  }

  vim.api.nvim_create_autocmd("FileType", {
    pattern = tree_filetypes,
    callback = function()
      pcall(vim.treesitter.start)
      pcall(function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end)
    end,
  })
end

vim.opt.pumheight = 12
vim.opt.winborder = "single"
vim.opt.shortmess:append("c")

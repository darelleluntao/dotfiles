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

local ok_gitsigns, gitsigns = pcall(require, "gitsigns")
if ok_gitsigns then
  gitsigns.setup({
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    signs_staged = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    current_line_blame = false,
    current_line_blame_opts = {
      delay = 500,
      virt_text_pos = "eol",
    },
    preview_config = {
      border = "single",
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local opts = { buffer = bufnr, silent = true }

      vim.keymap.set("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, opts)

      vim.keymap.set("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, opts)

      vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts)
      vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts)
      vim.keymap.set("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, opts)
      vim.keymap.set("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, opts)
      vim.keymap.set("n", "<leader>hS", gs.stage_buffer, opts)
      vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, opts)
      vim.keymap.set("n", "<leader>hR", gs.reset_buffer, opts)
      vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts)
      vim.keymap.set("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, opts)
      vim.keymap.set("n", "<leader>hB", gs.toggle_current_line_blame, opts)
      vim.keymap.set("n", "<leader>hd", gs.diffthis, opts)
      vim.keymap.set("n", "<leader>hD", function()
        gs.diffthis("~")
      end, opts)
    end,
  })
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

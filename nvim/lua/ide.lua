local M = {}

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
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
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
    ensure_installed = {
      "bash",
      "css",
      "dart",
      "go",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "typescript",
      "tsx",
      "vim",
      "vimdoc",
      "yaml",
    },
    highlight = {
      enable = true,
    },
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

M.telescope = function()
  local ok_telescope, telescope = pcall(require, "telescope")
  if not ok_telescope then
    return
  end

  telescope.setup({
    defaults = {
      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      layout_strategy = "horizontal",
      sorting_strategy = "ascending",
      prompt_prefix = "   ",
      selection_caret = "  ",
      path_display = { "truncate" },
    },
    pickers = {
      find_files = { hidden = true },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
  })

  pcall(telescope.load_extension, "fzf")

  pcall(vim.keymap.del, "n", "<leader>f")
  pcall(vim.keymap.del, "n", "<leader>b")

  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>ff", builtin.find_files, { silent = true, desc = "Telescope find files" })
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, { silent = true, desc = "Telescope live grep (Rg)" })
  vim.keymap.set("n", "<leader>fb", builtin.buffers, { silent = true, desc = "Telescope buffers" })
  vim.keymap.set("n", "<leader>fh", builtin.help_tags, { silent = true, desc = "Telescope help tags" })
  vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { silent = true, desc = "Telescope recent files" })
    vim.keymap.set("n", "<leader>fw", function()
    builtin.grep_string({ search = vim.fn.expand("<cword>") })
  end, { silent = true, desc = "Telescope grep word under cursor" })
end

if vim.fn.executable("glow") == 1 then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "markdown.pandoc", "markdown.gfm" },
    callback = function()
      vim.keymap.set("n", "<leader>mp", function()
        local file = vim.fn.expand("%:p")
        if file == "" then
          vim.notify("Save the file first to preview it", vim.log.levels.WARN)
          return
        end
        vim.cmd("botright 20split | terminal glow " .. vim.fn.shellescape(file) .. " -w 80")
        vim.cmd("startinsert")
      end, { buffer = true, silent = true, desc = "Preview markdown with glow" })
    end,
  })
end

local function confirm_quit(force)
  if vim.g.dont_confirm_exit then
    vim.cmd(force and "qa!" or "qa")
    return
  end
  local choice = vim.fn.confirm("Quit Neovim?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.cmd(force and "qa!" or "qa")
  end
end

vim.keymap.set("n", "ZZ", "", { silent = true })
vim.keymap.set("n", "ZQ", "", { silent = true })
vim.cmd("command! -bang Q lua confirm_quit(<bang> == 1)")
vim.keymap.set("n", "<leader>Q", function()
  confirm_quit(false)
end, { silent = true, desc = "Quit Neovim (with confirmation)" })

return M

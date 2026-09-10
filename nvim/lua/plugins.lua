local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

-- Bootstrap lazy.nvim on first launch so a fresh machine (e.g. a bare server)
-- comes up without a manual install step. If git is missing or the clone
-- fails, degrade to a plain Neovim rather than erroring on every startup.
if not uv.fs_stat(lazypath) then
  if vim.fn.executable("git") == 0 then
    vim.notify(
      "lazy.nvim is not installed and git was not found in PATH; "
        .. "install git, then restart Neovim to bootstrap plugins.",
      vim.log.levels.WARN
    )
    return
  end

  vim.notify("Bootstrapping lazy.nvim ...", vim.log.levels.INFO)
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to clone lazy.nvim:\n" .. out, vim.log.levels.ERROR)
    return
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
  },
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "lewis6991/gitsigns.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("ide").telescope()
    end,
  },
}, {
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  ui = { border = "single" },
})

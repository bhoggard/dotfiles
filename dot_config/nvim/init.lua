-- ~/.config/nvim/init.lua
--
-- A GUESSED reconstruction of Dave Thomas's (pragdave) Neovim config.
-- Dave has never published his actual dotfiles or given a talk on this setup,
-- so nothing here is confirmed -- it's inferred from public clues:
--
--   1. He forked nvim-lua/kickstart.nvim on GitHub, so this uses kickstart's
--      structure: single init.lua, lazy.nvim as the plugin manager, minimal
--      "understand every line" philosophy rather than a mega-distro.
--   2. He recommended oil.nvim on X ("edit your filesystem like a buffer").
--   3. He recommended sqls.nvim + the sqls language server on X.
--   4. He teaches Elixir/Phoenix professionally -> almost certainly has an
--      Elixir LSP configured. Using Expert (expert-lsp.org), the official
--      Elixir LS that consolidates ElixirLS/Lexical/Next LS and is now the
--      current recommendation, rather than the elixir-tools.nvim wrapper.
--   5. His "now" page says he runs Neovim inside Kitty and does ALL window
--      management -- inside the editor and in the terminal -- with a single
--      set of key sequences. That strongly implies something like
--      smart-splits.nvim, which lets the same keys move between nvim splits
--      AND Kitty panes seamlessly.
--   6. He's a lifelong git power-user ("if my machine melts overnight, can I
--      be back to where I was by that afternoon?") -> fugitive or gitsigns.
--   7. He's been vi-resistant for 30 years, so likely modal-editing basics
--      only, nothing exotic -- no evidence of things like which-key, harpoon,
--      etc, so they're left out rather than guessed in.
--
-- Anywhere a choice is a pure guess (not tied to a specific clue above),
-- it's marked with -- GUESS so you can swap it out easily.
--
-- Running Neovim 0.12.5 (checked via `nvim --version`), not the 0.11.6
-- assumed below when treesitter's branch was pinned -- see that comment.
--
-- Actual terminal here is Ghostty, not the Kitty from clue 5 above (that's
-- pragdave's setup, not this one) -- see the smart-splits.nvim comment
-- further down for what that changes in practice.

-- ============================================================================
-- Basic options
-- ============================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.mouse = 'a'
opt.showmode = false
opt.clipboard = 'unnamedplus'
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = 'yes'
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.inccommand = 'split'
opt.cursorline = true
opt.scrolloff = 8
opt.termguicolors = true

-- ============================================================================
-- lazy.nvim bootstrap
-- ============================================================================
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- Plugins
-- ============================================================================
require('lazy').setup({

  -- Git: fugitive is the classic pragmatic choice for someone who's been
  -- around vim/nvim workflows since before Lua configs existed. -- GUESS
  { 'tpope/vim-fugitive' },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
      },
    },
  },

  -- oil.nvim: confirmed interest -- he tweeted about it directly.
  {
    'stevearc/oil.nvim',
    opts = {
      default_file_explorer = true,
      view_options = { show_hidden = true },
    },
    keys = {
      { '-', '<CMD>Oil<CR>', desc = 'Open parent directory' },
    },
  },

  -- Fuzzy finding -- standard in kickstart.nvim, so likely kept as-is.
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    keys = {
      { '<leader>sf', '<cmd>Telescope find_files<cr>', desc = '[S]earch [F]iles' },
      { '<leader>sg', '<cmd>Telescope live_grep<cr>', desc = '[S]earch by [G]rep' },
      { '<leader>sb', '<cmd>Telescope buffers<cr>', desc = '[S]earch [B]uffers' },
      { '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = '[S]earch [H]elp' },
    },
  },

  -- Treesitter -- kickstart default, kept. Pinned to the `master` branch:
  -- nvim-treesitter's `main` branch is a from-scratch rewrite that drops the
  -- `ensure_installed`/`highlight.enable` config schema entirely in favor of
  -- calling `require('nvim-treesitter').install{...}` and `:TSEnable` per
  -- buffer. It now only requires Neovim 0.11+, which this machine's 0.12.5
  -- satisfies, so `main` is an option -- but switching means rewriting this
  -- block to the new API, so `master` is kept here since it still works.
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    -- Without this, lazy.nvim can't infer a unique top-level module to call
    -- `.setup(opts)` on (it only finds submodules like `nvim-treesitter.install`),
    -- so `main = nil` and `opts` below get silently dropped.
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'elixir', 'heex', 'eex', 'lua', 'ruby', 'markdown', 'sql', 'bash' },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- LSP setup, including Elixir -- his day job.
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      {
        'williamboman/mason-lspconfig.nvim',
        -- Only servers confirmed present in Mason's registry go here.
        -- Expert isn't in it as of this writing (install the binary from
        -- https://expert-lsp.org and put it on $PATH); ruby_lsp is a gem
        -- (`gem install ruby-lsp`), not a Mason package.
        opts = { ensure_installed = { 'lua_ls', 'sqls' } },
      },
      'nanotee/sqls.nvim', -- confirmed: he tweeted about this exact plugin
      'hrsh7th/cmp-nvim-lsp', -- also a dep of nvim-cmp below; listed here
      -- too so its module is guaranteed on the runtimepath before this
      -- config() runs, regardless of plugin load order.
    },
    config = function()
      -- Advertise nvim-cmp's completion capabilities to every LSP server
      -- enabled below (snippet support, better completion item resolution).
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      vim.lsp.config('*', { capabilities = capabilities })

      -- Elixir via Expert (https://expert-lsp.org), the official Elixir
      -- language server -- successor to ElixirLS/Lexical/Next LS, which
      -- elixir-tools.nvim wrapped. Not in Mason's registry -- install the
      -- binary manually and put it on $PATH, then enable nvim-lspconfig's
      -- bundled config for it.
      vim.lsp.enable 'expert'

      -- SQL, per his tweet: "TIL: there's an SQL language server and an
      -- nvim plugin that makes it really nice to use." sqls.nvim now ships
      -- its own native lsp/sqls.lua config (buffer commands, otter.nvim
      -- integration) rather than the old require('sqls').on_attach API, so
      -- load that explicitly -- nvim-lspconfig ships a bare-bones lsp/sqls.lua
      -- of its own too, and which one wins depends on runtimepath order.
      for _, path in ipairs(vim.api.nvim_get_runtime_file('lsp/sqls.lua', true)) do
        if path:match 'sqls%.nvim' then
          vim.lsp.config('sqls', dofile(path))
          break
        end
      end
      vim.lsp.enable 'sqls'

      -- Reasonable extras for a Ruby/JS-adjacent full-stack background -- GUESS
      vim.lsp.enable 'lua_ls'
      vim.lsp.enable 'ruby_lsp'
    end,
  },

  -- Completion -- kickstart default (nvim-cmp), kept as the safe assumption.
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      cmp.setup {
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  -- Split navigation, per pragdave's "now" page claim that window management
  -- is unified inside and outside the editor -- but that claim is about
  -- Kitty, and this machine runs Ghostty. smart-splits.nvim only ships
  -- multiplexer backends for tmux, kitty, wezterm, and zellij (see
  -- lua/smart-splits/mux/ in the plugin) -- there's no Ghostty backend, so
  -- <C-hjkl> below will move between nvim splits but will NOT hand off to
  -- Ghostty panes at the edge of the screen; it just wraps to the opposite
  -- nvim split instead (smart-splits' default at_edge behavior when no
  -- multiplexer is detected). To get "same keys everywhere" back, bind
  -- ctrl+hjkl to Ghostty's own pane-focus actions in ~/.config/ghostty/config
  -- (e.g. `keybind = ctrl+h=goto_split:left`) -- it won't be a true
  -- hand-off like Kitty's, but both layers respond to the same keys.
  {
    'mrjones2014/smart-splits.nvim',
    keys = {
      { '<C-h>', function() require('smart-splits').move_cursor_left() end },
      { '<C-j>', function() require('smart-splits').move_cursor_down() end },
      { '<C-k>', function() require('smart-splits').move_cursor_up() end },
      { '<C-l>', function() require('smart-splits').move_cursor_right() end },
    },
  },

  -- Colorscheme -- pure guess, no evidence either way.
  { 'folke/tokyonight.nvim', priority = 1000, config = function() vim.cmd.colorscheme 'tokyonight-night' end }, -- GUESS

  -- Statusline -- pure guess.
  { 'nvim-lualine/lualine.nvim', opts = {} }, -- GUESS

}, {})

-- ============================================================================
-- Basic keymaps
-- ============================================================================
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>e', '<cmd>Oil<CR>', { desc = 'Open file explorer (Oil)' })


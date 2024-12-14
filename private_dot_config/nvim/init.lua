vim.o.number = true -- Line numbers
vim.o.relativenumber = true -- So we can jump without math
vim.o.tabstop = 4 -- How many spaces in tab
vim.o.shiftwidth = 4 -- Indent
vim.o.expandtab = true -- Tabs -> spaces
vim.o.smartindent = true -- Autoindent new lines
vim.o.wrap = false -- No linewrap
vim.o.cursorline = true -- Highlight current line
vim.o.termguicolors = true -- Enable 24bit RGB colors

-- vim.cmd('syntax enable') -- Syntax highlighting
vim.cmd('filetype plugin indent on') -- 

vim.opt.grepprg = 'rg --vimgrep --smart-case --follow' -- Use ripgrep

-- Make netrw a bit easier to use
vim.api.nvim_set_keymap('n', '-', ':Explore<CR>', { noremap = true, silent = true })

-- Get outta insert mode easier
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true })

-- Break the habit
vim.api.nvim_set_keymap('n', '<Up>', '<NOP>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Down>', '<NOP>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Left>', '<NOP>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Right>', '<NOP>', { noremap = true })

vim.cmd('colorscheme dichromatic')

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'tpope/vim-vinegar'
    use 'tpope/vim-projectionist'
    use 'tpope/vim-fugitive'
    use 'romainl/vim-dichromatic'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    if packer_bootstrap then
        require('packer').sync()
    end
end)


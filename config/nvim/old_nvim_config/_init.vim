" 遅延化
let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1
let g:did_indent_on             = 1
let g:did_load_filetypes        = 1
let g:did_load_ftplugin         = 1
let g:loaded_2html_plugin       = 1
let g:loaded_gzip               = 1
let g:loaded_man                = 1
let g:loaded_matchit            = 1
let g:loaded_matchparen         = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_remote_plugins     = 1
let g:loaded_shada_plugin       = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_zipPlugin          = 1
let g:skip_loading_mswin        = 1

" Leader を Space に設定
let mapleader = "\<Space>"
" Option
" BSで行頭削除できる
set backspace=indent,eol,start
" 行数表示
set number
" 相対行数を表示
set relativenumber
" 改行時に前の行のインデントを継続
set autoindent
" tab size
set tabstop=2
" 自動インデントでずれる幅
set shiftwidth=2
"タブ入力を複数の空白入力に置き換える
set expandtab
" clipboard連携 
if has('mac')
  set clipboard+=unnamed
endif
if has('unix')
  set clipboard+=unnamedplus
endif
" ファイル更新反映までの時間
set updatetime=100
" 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent
" インクリメンタルな検索が可能になる
set incsearch
" 検索結果のハイライト
set hlsearch
" 常にステータスラインを表示する
set laststatus=2
" 補完表示時の挙動
set completeopt=menuone,noinsert
" 補完表示時のEnterで改行をしない
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"
" jj=esc
imap jj <Esc>
" プラグインとインデントを有効化
filetype plugin indent on
" filetype on
" 検索パターンにおいて大文字と小文字を区別しない
set ignorecase
" スワップファイルを作らない
set noswapfile
" バックアップファイル作らない
set nobackup
" undoファイル作らない
set noundofile
" 新しいウィンドウを→に開く
set splitright
" True Colorを使用する
set termguicolors
" buffer切替時に編集中ファイルを保存しなくてもOKにする
set hidden
" fugitive.vime Diffを立て分割にする
set diffopt+=vertical
" vimで使用するフォント
set guifont=HackGenNerd\ Console\ 14
set encoding=UTF-8
" mode表示しない
set noshowmode
" マウス無効
set mouse=
" コマンドのメッセージ表示欄を2行にする
set cmdheight=2

" Highlight extra whitespaces
" https://zenn.dev/kawarimidoll/articles/450a1c7754bde6
augroup extra-whitespace
  autocmd!
  autocmd ColorScheme * highlight default ExtraWhitespace ctermbg=darkmagenta guibg=darkmagenta
  autocmd VimEnter,WinEnter * call matchadd('ExtraWhitespace', "[\u00A0\u2000-\u200B\u3000]")
augroup END

" Node.js の参照先
let g:node_host_prog = '~/.asdf/installs/nodejs/16.14.2/.npm/lib/node_modules/neovim/bin/cli.js'

" tab config of golang
autocmd FileType go setlocal noexpandtab
autocmd FileType go setlocal tabstop=4
autocmd FileType go setlocal shiftwidth=4
" tab config of Ruby
autocmd FileType rb setlocal noexpandtab
autocmd FileType rb setlocal tabstop=2

nnoremap Y y$

" init.vimを開く
nnoremap <Space>. :<C-u>tabedit ~/.config/nvim/init.vim<CR>

" dein Scripts-----------------------------
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
if &compatible
  set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  let g:rc_dir = expand('~/.config/nvim')
  let s:toml = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
  " toml 読み込んでキャッシュする
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  " call dein#call_hook('source')
  call dein#save_state()
	call map(dein#check_clean(), { _, val -> delete(val, 'rf') })
	call dein#recache_runtimepath()
endif
" 未インストールのものがあればインストールする
if dein#check_install()
  call dein#install()
endif
" plugin remove check {{{
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif
" }}}
"End dein Scripts-------------------------

" Color scheme
colorscheme iceberg

" nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = { "php", "phpdoc" },
  highlight = {
    enable = true,
    disable = {},
  },
  autotag = {
    enable = true,
  },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
    -- disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
  },
  context_commentstring = {
    enable = true
  }
}
EOF

" telescope
"lua <<EOF
"require('telescope').setup{
"  extensions = {
"    fzf = {
"      fuzzy = true,                    -- false will only do exact matching
"      override_generic_sorter = false, -- override the generic sorter
"      override_file_sorter = true,     -- override the file sorter
"      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
"                                       -- the default case_mode is "smart_case"
"    }
"  }
"}
"require('telescope').load_extension('fzf')
"EOF

" toggleterm.nvim
" refer https://zenn.dev/koga1020/articles/524e4c8c80db24
lua <<EOF
require('toggleterm').setup()
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	direction = "float",
	hidden = true
})

function _lazygit_toggle()
	lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
EOF

" gitsigns.nvim
lua <<EOF
require('gitsigns').setup()
EOF

" import divided file
set runtimepath+=./
runtime! *.rc.vim


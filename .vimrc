set encoding=utf-8
scriptencoding utf-8

"構文ハイライトの有効化
syntax on
"ファイル形式別プラグイン,インデントの有効化
filetype plugin indent on

"plugin
call plug#begin('~/.vim/plugged')
Plug 'w0ng/vim-hybrid'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
call plug#end()

"normal
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k
nnoremap <C-e> $
nnoremap <C-a> ^

"insert
inoremap <C-b> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-f> <Right>

"画面分割の設定
nnoremap s <Nop>
nnoremap ss :split<Return><C-w>w
nnoremap sv :vsplit<Return><C-w>w
nnoremap <Space> <C-w>w
nnoremap sh <C-w>h
nnoremap sk <C-w>k
nnoremap sj <C-w>j
nnoremap sl <C-w>l

"colorscheme
set t_Co=256
set background=dark
colorscheme hybrid
"行番号の色の設定
hi lineNr ctermfg=243 guifg=#707880

"行番号の表示
set number
"タイトルの表示
set title
"ステータスラインの表示
set laststatus=2
"ステータスラインのフォーマットの設定
set statusline=%F%m%h%w\ %<[ENC=%{&fenc!=''?&fenc:&enc}]\ [FMT=%{&ff}]\ [TYPE=%Y]\ %=[CODE=0x%02B]\ [POS=%l/%L(%02v)]
"入力中のコマンドの表示
set showcmd
"コマンド補完の設定
set wildmenu
"現在のモードの表示
set showmode
"現在の行を強調表示
set cursorline
"ビープ音の無効化
set visualbell t_vb=
set noerrorbells
"対応する括弧を表示
set showmatch
"スワップファイルの無効化
set noswapfile
"バックアップファイルの無効化
set nobackup

"検索時に小文字で入力した場合、大文字と区別しない
set ignorecase
set smartcase
"インクリメントサーチの有効化
set incsearch
"検索語のハイライト表示
set hlsearch
"ESC連打でハイライトの無効化
nnoremap <ESC><ESC> :nohlsearch<CR>

"Tabの可視化
set list listchars=tab:>-
"Tabで半角スペースを入力
set expandtab
"行頭でのTabの表示幅
set shiftwidth=2
"行頭以外でのTabの表示幅
set tabstop=2
"改行時のインデントの保持
set autoindent

"全角スペースの可視化
highlight FullWidthSpace
  \ cterm=underline
  \ ctermfg=LightGreen
  \ gui=underline
  \ guifg=LightGreen
augroup FullWidthSpace
  autocmd!
  autocmd VimEnter,WinEnter * call matchadd("FullWidthSpace", "　")
augroup END
"行末スペースの可視化
highlight EndSpace
  \ ctermbg=199
  \ guibg=Cyan
augroup EndSpace
  autocmd!
  autocmd VimEnter,WinEnter * match EndSpace /\s\+$/
augroup END

"クリップボードから貼り付けた文の整形
if &term =~ "xterm"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction

  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

"NERD TREE
noremap <C-n> :NERDTreeToggle<CR>

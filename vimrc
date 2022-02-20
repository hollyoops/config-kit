set number
set colorcolumn=+1
set showmatch
set hlsearch
set ruler
set clipboard=unnamed

nnoremap <C-a> ^
nnoremap <C-e> $
nnoremap <C-b> <Left>
nnoremap <C-f> <Right>
nnoremap <CR> o<ESC>
nnoremap <S-CR> O<ESC>
nnoremap <C-A-f> w
nnoremap <C-A-b> b
nnoremap <C-h> "_X
nnoremap <C-d> "_x

inoremap <C-a> ^
inoremap <C-e> $
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-h> <BS>
inoremap <C-d> <DEL>
nnoremap <C-A-f> <ESC>wi
nnoremap <C-A-b> <ESC>bi

vnoremap < <gv
vnoremap > >gv

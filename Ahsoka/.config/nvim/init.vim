"""""""""""""""""""""""""""""""""""""""""""""
"          _    _____ _________             "
"         | |  |  _  \  _   _  |            "
"         | |  | | | | | | | | |            "
"         | |  | | | | | | | | |            "
"         | |__| |_| | | | | | |            "
"         |____|____/|_| |_| |_|            "
"                                           "
"   site: https://link-does-mods.github.io/ "
" github: https://github.com/link-does-mods "
"""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin()
Plug 'arcticicestudio/nord-vim'  " nord theme
Plug 'itchyny/lightline.vim'     " lightline status bar
Plug 'ap/vim-css-color'          " css color previews
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colorscheme 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set colorscheme (nord)
colorscheme nord

" Lightline colorscheme (nord)
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Line numbers (everyone needs these)
set number

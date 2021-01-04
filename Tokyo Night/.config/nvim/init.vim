"""""""""""""""""""""""""""""""""""
" Color scheme
"""""""""""""""""""""""""""""""""""

" Syntax and gui
set termguicolors

let g:tokyonight_style = 'storm'             " Style (night/storm)
let g:tokyonight_enable_italic = 1           " Italics
let g:tokyonight_transparent_background = 0  " Baclground transparency

colorscheme tokyonight

" Lightline
let g:lightline = {'colorscheme' : 'tokyonight'}


""""""""""""""""""""""""""""""""""
" Misc settings
""""""""""""""""""""""""""""""""""

" Line numbers
set number

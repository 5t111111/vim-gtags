" if exists('g:loaded_vim_gtags')
"   finish
" endif
" let g:loaded_vim_gtags = 1

command! GtagsGenerate :call gtags#generate_gtags()

" if exists('g:loaded_vim_gtags')
"   finish
" endif
" let g:loaded_vim_gtags = 1

command! -nargs=* -bang GtagsGenerate :call gtags#generate_gtags(<bang>0)
command! GtagsClean :call gtags#clean_gtags()

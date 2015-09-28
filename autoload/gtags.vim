" vim-gtags - The Gtags generator for Vim
" Maintainer:   Hirofumi Wakasugi
" Version:      0.1.0
"
" License:
" Copyright (c) 2015 Hirofumi Wakasugi and Contributors.
" Distributed under the same terms as Vim itself.
" See :help license

let s:save_cpo = &cpo
set cpo&vim

function! gtags#Testecho()
  echo "gtags#testecho loaded"
endfunction







let &cpo = s:save_cpo
unlet s:save_cpo

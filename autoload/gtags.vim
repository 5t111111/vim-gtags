" vim-gtags - The Gtags generator for Vim
" Maintainer:   Hirofumi Wakasugi
" Version:      0.1.0
"
" License:
" Copyright (c) 2015 Hirofumi Wakasugi and Contributors.
" Distributed under the same terms as Vim itself.
" See :help license

" let s:save_cpo = &cpo
" set cpo&vim


" Auto generate ctags
if !exists('g:vim_gtags_auto_generate')
  let g:vim_gtags_auto_generate = 1
endif

if !exists("g:vim_gtags_gtags_binary")
  let g:vim_gtags_gtags_binary = "gtags"
endif

command! -nargs=* -bang GtagsGenerate :call gtags#generate_gtags(<bang>0)

function! s:save_gtags_locations()
  let cache_file = g:vim_gtags_cache_dir . "/.vt_locations"
  call s:load_gtags_locations()
  call writefile(keys(s:locations), cache_file)
  let s:dirty_locations = 0
endfunction

function! s:generate_options()
  let options = ['--gtagslabel=pygments']
  return join(options, ' ')
endfunction

function! s:find_project_root()
  let project_root = fnamemodify(".", ":p:h")

  if !empty(g:vim_gtags_directories)
    let root_found = 0

    let candidate = fnamemodify(project_root, ":p:h")
    let last_candidate = ""

    while candidate != last_candidate
      for tags_dir in g:vim_gtags_directories
        let tags_dir_path = candidate . "/" . tags_dir
        if filereadable(tags_dir_path) || isdirectory(tags_dir_path)
          let root_found = 1
          break
        endif
      endfor

      if root_found
        let project_root = candidate
        break
      endif

      let last_candidate = candidate
      let candidate = fnamemodify(candidate, ":p:h:h")
    endwhile

    return root_found ? project_root : fnamemodify(".", ":p:h")
  endif

  return project_root
endfunction

function! s:execute_gtags_command(path, options)
  let command = g:vim_gtags_gtags_binary
  let command = 'echo "Creating Gtags for ' . fnamemodify(a:path, ':r.h') . '" && ' . 'pushd ' . a:path . ' && ' . command . ' && popd'
  silent! execute '!' . command
endfunction

function! gtags#generate_gtags(bang)
  let handle_acd = &acd
  set noacd

  let old_cwd = fnamemodify(".", ":p:h")

  let project_root = s:find_project_root()
  silent! execute 'cd ' . project_root

  let options = s:generate_options()

  silent! execute '!clear'

  if a:bang
    let l:bundler_cmd = "bundle show --paths"
    " TODO: for this purpose, use systemlist instead in future
    let l:bundler_result = system(l:bundler_cmd)
    if v:shell_error != 0
      if v:shell_error == 10
        echohl errormsg | echo 'Could not locate Gemfile or .bundle/ directory' | echohl none
      else
        echohl errormsg | echo 'An error occurred while executing bundle command' | echohl none
      endif
      return 1
    endif
    let l:gem_paths = split(l:bundler_result)
    for path in l:gem_paths
      call s:execute_gtags_command(path, options)
    endfor
  endif

  call s:execute_gtags_command(getcwd(), options)

  redraw!

  silent! exe "cd " . old_cwd

  if handle_acd
    set acd
  endif
endfunction

" if g:vim_gtags_auto_generate
"   au BufWritePost * call gtags#generate_gtags(0)
" endif



" let s:save_cpo = &cpo
" set cpo&vim

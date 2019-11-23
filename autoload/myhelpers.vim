" Assigns variable name in the argument to the value.
function myhelpers#EvalSetVariable(variable, value)
  execute "let " . a:variable . " = \'" . a:value . "\'"
endfunction

" Return executable path from directories in standard PATH environment variable.
" Returns path if found; else returns empty string.
function myhelpers#ExecutablePathInStandardLocation(executable)
  let l:standard_paths = [
    \ '~/.nix-profile/bin',
    \ '/bin/', '/usr/bin/', '/usr/local/bin/'
    \ ]

  for l:bin_path in l:standard_paths
    let l:executable_path = expand(l:bin_path . "/" . a:executable)
    if filereadable(l:executable_path)
      return l:executable_path
    endif
  endfor
  return ''
endfunction

" Creates directory specified in the argument if it does not exist.
function myhelpers#CreateDirectory(dir)
  let l:normalized_path = expand(a:dir)
  if exists(l:normalized_path) && !isdirectory(l:normalized_path)
    call errmsg("backup location is not a directory. Need manual intervention")
  endif

  if !exists(l:normalized_path)
    call mkdir(l:normalized_path, "p")
  endif
endfunction

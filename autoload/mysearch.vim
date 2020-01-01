" Async grep
function! mysearch#find(term) abort
  let l:callbacks = {
        \ 'on_stdout': 'OnEvent',
        \ 'on_exit': 'OnExit',
        \ 'stdout_buffered':v:true
        \ }

  let s:results = ['']

  function! OnExit(job_id, data, event)
    call setqflist([], 'r', {'title': 'Search Results', 'lines': s:results})
    exec 'cwindow'
  endfunction

  function! OnEvent(job_id, data, event)
      let eof = (a:data == [''])
      let s:results[-1] .= a:data[0]
    call extend(s:results, a:data[1:])
  endfunction

  call jobstart(printf('rg %s --vimgrep --smart-case', a:term), l:callbacks)
endfunction

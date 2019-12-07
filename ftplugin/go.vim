setlocal noexpandtab
setlocal tabstop=4
setlocal shiftwidth=4

function! s:HideTabsCharactersForGolang()
    " with list option set, tab character needs to be explicitly set in,
    " listchars. Otherwise Vim defaults to show tab character as ^I
    let l:newlistchars="tab:\ \ "

    for l:listchar in split(&listchars, ",")
        let l:whitespacechar = split(l:listchar, ":")[0]
        if l:whitespacechar != "tab"
            let l:newlistchars = l:newlistchars . "," . l:listchar
        endif
    endfor
    let &l:listchars=l:newlistchars
endfunction

call s:HideTabsCharactersForGolang()

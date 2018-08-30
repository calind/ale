function! ale#fixers#gomod#Fix(buffer) abort
    return {
    \   'command':
    \       . ' go mod edit -fmt'
    \       . ' %t',
    \   'read_temporary_file': 1,
    \}
endfunction


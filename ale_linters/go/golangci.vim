" Author: calind <calin.don@gmail.com>
" Description: golangci-lint for Go files

call ale#Set('go_golangci_options', '--fast --enable-all')

function! ale_linters#go#golangci#GetCommand(buffer) abort
    let l:options = ale#Var(a:buffer, 'go_golangci_options')

    return ale#path#BufferCdString(a:buffer)
    \   .'golangci-lint run --out-format=line-number --print-issued-lines=false'
    \   . (!empty(l:options) ? ' ' . l:options : '')
    \   . ' ./'
endfunction

function! ale_linters#go#golangci#GetMatches(lines) abort
    let l:pattern = '\v^([a-zA-Z]?:?[^:]+):(\d+):?(\d+)?:? (.+)$'

    return ale#util#GetMatches(a:lines, l:pattern)
endfunction

function! ale_linters#go#golangci#Handler(buffer, lines) abort
    let l:dir = expand('#' . a:buffer . ':p:h')
    let l:output = []

    for l:match in ale_linters#go#golangci#GetMatches(a:lines)
        call add(l:output, {
        \   'filename': ale#path#GetAbsPath(l:dir, l:match[1]),
        \   'lnum': l:match[2] + 0,
        \   'col': l:match[3] + 0,
        \   'text': l:match[4],
        \   'type': 'W',
        \})
    endfor

    return l:output
endfunction

call ale#linter#Define('go', {
\   'name': 'golangci',
\   'output_stream': 'stdout',
\   'executable': 'golangci-lint',
\   'command_callback': 'ale_linters#go#golangci#GetCommand',
\   'callback': 'ale_linters#go#golangci#Handler',
\   'lint_file': 1,
\})

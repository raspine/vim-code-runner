" vim-code-runner.vim - Single file compiler/runner for c/c++ code
" Author:       Jörgen Scott (jorgen.scott@gmail.com)
" Version:      0.1

if exists("g:loaded_vim_code_runner")
    finish
endif
let g:loaded_vim_code_runner = 1

" public interface
command! -nargs=0 InteractiveCompile call s:InteractiveCompile()
command! -nargs=0 DirectCompile call s:DirectCompile()
command! -nargs=0 RunCode call s:RunCode()

let s:code_runner_compiler = ''
let s:code_runner_standard = ''
let s:code_runner_flags = ''
let s:code_runner_libs = ''

" local functions
" global vars are used for init unless the session already modified them
function! s:InitVars()
    if empty(s:code_runner_compiler)
        let s:code_runner_compiler = g:code_runner_compiler
    endif
    if empty(s:code_runner_standard)
        let s:code_runner_standard = g:code_runner_standard
    endif
    if empty(s:code_runner_flags)
        let s:code_runner_flags = g:code_runner_flags
    endif
    if empty(s:code_runner_libs)
        let s:code_runner_libs = g:code_runner_libs
    endif
endfunction

function! s:GetKeyFromValue(dict, value)
    for [key,value] in items(a:dict)
        if value == a:value
            return key
        endif
    endfor
    return 0
endfunction

function! s:SelectFromDictionary(dict, default)
    while 1
        for [key,value] in items(a:dict)
            echo key . ") " . value
        endfor
        call inputsave()
        if empty(a:default)
            let s:sel = input('Select index:')
        else
            let s:sel = input('Select index:', s:GetKeyFromValue(a:dict, a:default))
        endif
        call inputrestore()
        if s:sel < 1 || s:sel > len(a:dict)
            echoerr s:sel . "Please select a number within range"
        else
            return get(a:dict, s:sel)
        endif
    endwhile
endfunction

function! s:DoCompile()
    let s:cmd = s:code_runner_compiler . 
                \ ' ' . expand('%') . ' -o ' . expand('%<') .
                \ ' --std=' . s:code_runner_standard .
                \ ' -Wall -Wextra -Wpedantic ' .
                \ s:code_runner_flags . ' ' .
                \ s:code_runner_libs
    if exists(":AsyncRun")
        execute 'copen'
        execute 'AsyncRun ' . s:cmd
        execute 'wincmd p'
    else
        let s:res = system(s:cmd)
        echo s:res
    endif
endfunction

function! s:InteractiveCompile()
    call s:InitVars()
    let s:compilers = { 1:'gcc', 2:'g++', 3:'clang', 4:'clang++' }
    let s:code_runner_compiler = s:SelectFromDictionary(s:compilers, s:code_runner_compiler)

    let s:standards = { 1:'c99', 2:'c11', 3:'c++98', 4:'c++03', 5:'c++11', 6:'c++14', 7:'c++17', 8:'c++2a' }
    let s:code_runner_standard = s:SelectFromDictionary(s:standards, s:code_runner_standard)

    call inputsave()
    let s:code_runner_flags = input('Enter flags (e.g. -O2 -g): ', s:code_runner_flags)
    call inputrestore()

    call inputsave()
    let s:code_runner_libs = input('Enter libs (e.g. -lboost_system -lboost_..): ', s:code_runner_libs)
    call inputrestore()

    call s:DoCompile()
endfunction

function! s:DirectCompile()
    if empty(s:code_runner_compiler)
        call s:InteractiveCompile()
    else
        call s:InitVars()
        call s:DoCompile()
    endif
endfunction

function! s:RunCode()
    let s:cmd = expand('%<')
    if exists(":AsyncRun")
        execute 'copen'
        execute 'AsyncRun ' . s:cmd
        execute 'wincmd p'
    else
        let s:res = system(s:cmd)
        echo s:res
    endif
endfunction

" vim:set ft=vim sw=4 sts=2 et:

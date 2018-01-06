# vim-code-runner
=============================
### Single file compiler/runner for c/c++ code ###
I wanted a simple way to compile and run code snippets directly in Vim.

Some websites like http://en.cppreference.com offers a convenient way to
select compiler/standard in a web code runner and I wanted something similar.

vim-code-runner lets you choose compiler/standard and extends to also let you
choose flags/libs interactively,

If you have the [AsyncRun plugin](https://github.com/skywind3000/asyncrun.vim)
installed, it will be used automatically so you can use the quickfix
with `:cnext` and friends.

## Commands
`:InteractiveCompile`
Starts an interactive session to choose compiler/standard/flags/libs.

`:DirectCompile`
Compiles directly using the last settings from `:InteractiveCompile`.

`:RunCode`
Runs the executable.

## Variables
These variables can be set if you want defaults.
If set, `DirectCompile` works directly without first doing `InteractiveCompile`.

```vimL
let g:code_runner_compiler = 'g++'
let g:code_runner_standard = 'c++14'
let g:code_runner_flags = '-O2'
let g:code_runner_libs = ''
```
## Installation
Use your Vim package manager.

## License

Distributed under the same terms as Vim itself.  See the vim license.

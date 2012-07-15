" Tagit - Trace whole project with Tags and Git!
" File:    tagit.vim
" Author:  Mosky <mosky.tw@gmail.com>
" Version: 0.1.1
" Description:
"   Put tagit.vim into ~/.vim/plugin to install.
"
"   Tagit provides the functions below:
"
"       * One tags file for whole project.
"       * Auto update tags when saving file.
"       * <leader>] to update tags of all files in your project.
"       * Auto update all tags while tags are not found.
"
"   By default, it work fine with exuberant-ctags, Python and Git.
"   You can adjust the settings below for your tags tool, language and VCS.
"   (see the source to get more info about settings)

if !exists('g:tagit_tags_command')
    " %r: recurse option
    " %t: the path of tags file
    " %f: the path of target file
    let g:tagit_tags_command = 'ctags --python-kinds=-i %r -a -o %t %f'
endif

if !exists('g:tagit_tags_command_recurse')
    let g:tagit_tags_command_recurse = '-R'
endif

if !exists('g:tagit_tags_filename')
    " tag file will be save <git_root>/<g:tagit_tags_filename>
    let g:tagit_tags_filename = 'tags'
endif

if !exists('g:TagitFindVCSRoot')
    function! g:TagitFindVCSRoot(filepath)
        " return the root path of filepath
        " (re)define it to set your root of project
        return system('cd `dirname '.a:filepath.'` && git rev-parse --show-toplevel 2> /dev/null')[:-2]
    endfunction
endif

" end of the settings.
" Have fun! :D

" main functions

function! TagitInit()
    " it will be call in the end of this script
    let rootpath = g:TagitFindVCSRoot(expand('%:p'))
    if !empty(rootpath)
        let &tags .= ','.rootpath.'/'.g:tagit_tags_filename
        let leader = '\'
        if exists('g:mapleader')
            let leader = g:mapleader
        endif
        autocmd BufWritePost * :call Tagit()
        autocmd BufReadPost * :nnoremap <leader>] :call TagitAll()<CR>
        if !filereadable(rootpath.'/'.g:tagit_tags_filename)
            call TagitAll()
        endif
    endif
endfunction

function! Tagit()
    call InnerTagit(0)
endfunction

function! TagitAll()
    call InnerTagit(1)
endfunction

function! InnerTagit(all)
    " all == 0: update the tags of this file
    " all != 0: update the tags of all the files under the root path
    let filepath = expand('%:p')
    let rootpath = g:TagitFindVCSRoot(filepath) 
    if !empty(rootpath)
        let cmd = g:tagit_tags_command
        let cmd = substitute(cmd, '%t', rootpath.'/'.g:tagit_tags_filename, '')
        if a:all
            let cmd = substitute(cmd, '%r', g:tagit_tags_command_recurse, '')
            let cmd = substitute(cmd, '%f', rootpath, '')
        else
            let cmd = substitute(cmd, '%r', '', '')
            let cmd = substitute(cmd, '%f', filepath, '')
        endif
        call system(cmd)
    endif
endfunction

call TagitInit()

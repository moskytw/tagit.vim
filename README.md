Tagit
=====

Tagit is a tags helper for vim.

It handles all of the tags work in background. Let you enjoy the benfits of tags without addational effort.

Features
--------

1. Detect the root of project (by VCS root).
2. Only one tags file for a project.
3. Update tags while saving file.
4. Create tags recursively if tags file is not found in a project.

Usage
-----

If you are using *Python*, *Git* and *exuberant-ctags*, just install it and forget it!

In other cases, see the last section, Customization.

Installation
------------

### With Vundle

Add the command in your `.vimrc`:

    Bundle "moskytw/tagit.vim"

Then, use [Vundle][] to install:

    $ vim 
    :BundleInstall

### With Git

If you are using the [Vundle][] or [pathgen][]:

    $ git clone https://github.com/moskytw/tagit.vim ~/.vim/bundle/tagit.vim

If you don't have any plugin manager, just download it and copy the files under `tagit.vim` to your `~/.vim` folder.        

Customization
-------------

Here is a list of settings you can customize in Tagit.

Use `let <key> = <value>` in your vimrc.

### g:tagit_tags_command

The tags command you want to use.

default: `'ctags --python-kinds=-i %r -a -o %t %f'`

* `%r`: the recurse flag
* `%t`: the path of tags file
* `%f`: the path of target file

### g:tagit_tags_command_recurse

The recurse option for tags command.

default: `'-R'`

### g:tagit_tags_filename

The name of tags file. Tags file will be save in the root of project.

default: `'tags'`

### g:TagitFindVCSRoot

Define how to find the root of your project.

default: 

    function g:TagitFindVCSRoot(filepath)
        " return the root path of filepath
        " (re)define it to set your root of project
        return system('cd `dirname '.a:filepath.'` && git   rev-parse --show-toplevel 2> /dev/null')[:-2]
    endfunction

Have fun!

[Vundle]: https://github.com/gmarik/vundle/
[pathgen]: https://github.com/tpope/vim-pathogen

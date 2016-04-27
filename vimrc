set list
set nowrap
set nocompatible              " be iMproved
filetype off                  " required!

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'itchyny/lightline.vim'
Plugin 'wookiehangover/jshint.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'altercation/vim-colors-solarized'
Plugin 'w0ng/vim-hybrid'
Plugin 'mfukar/robotframework-vim'
Plugin 'kien/ctrlp.vim'
Plugin 'Shutnik/jshint2.vim'
Plugin 'qbbr/vim-twig'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'
Plugin 'morhetz/gruvbox'
Plugin 'jtai/vim-womprat'
" Active pluginll of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" JSHint configuration
"let JSHintUpdateWriteOnly=1
"let g:JSHintHighlightErrorLine = 0

" NERDTree configuration
let g:NERDTreeDirArrows=0
autocmd vimenter * if !argc() | NERDTree | endif

" General
syntax on
set wmh=0 " set minum windows height to 0
set number
set noswapfile
set smartindent
set autoindent
set expandtab
set cursorline
set cursorcolumn
set hlsearch " Highlight search terms...
set tabstop=4
set laststatus=2
set shiftwidth=4
set guifont=Source\ Code\ Pro\ for\ Powerline:h14
set foldmethod=indent
set foldlevel=20
set background=dark
colorscheme hybrid
"colorscheme solarized

" Powerline configuration
set encoding=utf-8
set t_Co=255

" Force syntax higlighting
au BufRead,BufNewFile *.js.yug setfiletype javascript
au BufRead,BufNewFile *.*.js.yug setfiletype javascript

au BufRead,BufNewFile *.css.yug setfiletype css
au BufRead,BufNewFile *.*.css.yug setfiletype css
au BufRead,BufNewFile *.scss set syntax=css

au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/syntax/yaml.vim

" Ctrl-p configuration
let ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/](.git|.hg|.svn|build|regress|logs|lib|modules|daemons|cache)$',
    \ 'file': '\v\.(exe|so|dll)$',
    \}
" Lightline configuration
let g:lightline = {
    \ 'colorscheme': "solarized_light",
    \ 'mode_map': { "c": "NORMAL" },
    \ 'active': {
    \   'left': [ [ 'datemark', 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
    \   'right': [ [ 'lineinfo' ], ['percent'], [ 'fileencoding', ] ]
    \ },
    \ 'component_function': {
    \   'fugitive': 'LightLineFugitive',
    \   'filename': 'LightLineFilename',
    \   'fileformat': 'LightLineFileformat',
    \   'filetype': 'LightLineFiletype',
    \   'fileencoding': 'LightLineFileencoding',
    \   'percent': 'LightLinePercent',
    \   'mode': 'LightLineMode',
    \   'ctrlpmark': 'CtrlPMark',
    \   'datemark': 'DateMark',
    \ },
    \    "separator": { "left": "\ue0b0", "right": "\ue0b2" },
    \    "subseparator": { "left": "\ue0b1", "right": "\ue0b3" }
    \ }

function! LightLineModified()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
    return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightLineFilename()
    let fname = expand('%:f')
    return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
                \ fname == '__Tagbar__' ? g:lightline.fname :
                \ fname =~ '__Gundo\|NERD_tree' ? '' :
                \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
                \ &ft == 'unite' ? unite#get_status_string() :
                \ &ft == 'vimshell' ? vimshell#get_status_string() :
                \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
                \ ('' != fname ? fname : '[No Name]') .
                \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
    try
        if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
            let mark = "\ue0a0"  " edit here for cool mark
            let _ = fugitive#head()
            return strlen(_) ? mark.' '._ : 'no-branch'
        endif
    catch
    endtry
    return ''
endfunction

function! LightLineFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
    return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLinePercent()
    let fname = expand('%:f')
    return fname =~? 'NERD_tree' ? '' : 
                \ line('.') . '/' . line('$') . ' ('. (100 * line('.') / line('$')) . '%)'
endfunction

function! LightLineMode()
    let fname = expand('%:t')
    return fname == '__Tagbar__' ? 'Tagbar' :
                \ fname == 'ControlP' ? 'CtrlP' :
                \ fname == '__Gundo__' ? 'Gundo' :
                \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
                \ fname =~ 'NERD_tree' ? 'NERDTree' :
                \ &ft == 'unite' ? 'Unite' :
                \ &ft == 'vimfiler' ? 'VimFiler' :
                \ &ft == 'vimshell' ? 'VimShell' :
                \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
    if expand('%:t') =~ 'ControlP' && has_key(g:lightline, 'ctrlp_item')
        call lightline#link('iR'[g:lightline.ctrlp_regex])
        return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
                    \ , g:lightline.ctrlp_next], 0)
    else
        return ''
    endif
endfunction

function! DateMark()
    let fname = expand('%:t')
    return fname == 'ControlP' ? '' :
            \ fname == '__Tagbar__' ? '' :
            \ fname =~ '__Gundo\|NERD_tree' ? '' :
            \ strftime('%d/%m/%y %H:%M')
endfunction

let g:ctrlp_status_func = {
            \ 'main': 'CtrlPStatusFunc_1',
            \ 'prog': 'CtrlPStatusFunc_2',
            \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
    let g:lightline.ctrlp_regex = a:regex
    let g:lightline.ctrlp_prev = a:prev
    let g:lightline.ctrlp_item = a:item
    let g:lightline.ctrlp_next = a:next
    return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
    return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
    return lightline#statusline(0)
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

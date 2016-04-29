set helplang=cn
set number 
filetype plugin indent on 
"pydiction
let g:pydiction_location = '~/.vim/tools/pydiction/complete-dict'
let g:pydiction_menu_height=20
"taglist
"let Tlist_Show_One_File = 1 "不同时显示多个文件的tag，只显示当前文件的。
"let Tlist_Exit_OnlyWindow = 1 "如果 taglist 窗口是最后一个窗口，则退出 vim。
"let Tlist_Use_Right_Window = 1 "在右侧窗口中显示 taglist 窗口
"let Tlist_Auto_Open=1 "在启动 vim 后，自动打开 taglist 窗口。
"let Tlist_File_Fold_Auto_Close=1 "taglist 只显示当前文件 tag，其它文件的tag折叠。
"Powerline
let g:Powerline_colorschme='solarized256'
set guifont=PowerlineSymbols\ for\ Powerline
set nocompatible
set t_Co=256
let g:Powerline_symbols = 'fancy'
"pathogen
filetype plugin on
call pathogen#infect()
autocmd FileType python set omnifunc=pythoncomplete#Complete  
autocmd FileType javascrīpt set omnifunc=javascriptcomplete#CompleteJS  
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags  
autocmd FileType css set omnifunc=csscomplete#CompleteCSS  
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags  
autocmd FileType php set omnifunc=phpcomplete#CompletePHP  
autocmd FileType shell set omnifunc=bashcomplete#Complete
autocmd FileType c set omnifunc=ccomplete#Complete
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set showmatch
set cindent
set showcmd
set showmode
set ignorecase
set incsearch
set backspace=indent,eol,start
set foldmethod=indent
" 高亮显示当前行/列
set cursorline
"#set cursorcolumn
" 高亮显示搜索结果
"#set hlsearch
" 总是显示状态栏
set laststatus=2
" 显示光标当前位置
"#set ruler
"配色
"set background=dark
"colorscheme solarized
"colorscheme SolarizedDark
"colorscheme desert
"colorscheme molokai
colorscheme monokai
 " 设置状态栏主题风格
"let g:Powerline_colorscheme='solarized256'
syntax enable
if has("syntax")
    syntax on 
if has("autocmd")
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
filetype plugin indent on
endif

" 基于缩进或语法进行代码折叠
"set foldmethod=indent
set foldmethod=syntax
" 启动 vim 时关闭折叠代码
set nofoldenable
"括号自动补全
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap { {}<ESC>i
inoremap < <><ESC>i
inoremap " ""<ESC>i
inoremap ' '<ESC>i
inoremap ''' '''<ESC>i
"行首尾跳转
nmap lb 0
nmap le $
"--ctags setting--
" 按下F5重新生成tag文件，并更新taglist
map <F5> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
imap <F5> <ESC>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
set tags=tags
set tags+=./tags "add current directory's generated tags file
set tags+=~/arm/linux-2.6.24.7/tags "add new tags file(刚刚生成tags的路径，在ctags -R 生成tags文件后，不要将tags移动到别的目录，否则ctrl+］时，会提示找不到源码文件)
set tags+=./tags

"进行版权声明的设置
"添加或更新头
map <F4> :call TitleDet()<cr>'s
function AddTitle()
    call append(0,"#/*=============================================================================")
    call append(1,"#!/usr/bin/env python")
    call append(2,"#-*- coding:utf-8 -*- ")
    call append(3,"# Author: ")
    call append(4,"# Last modified: ".strftime("%Y-%m-%d %H:%M"))
    call append(5,"# Filename: ".expand("%:t"))
    call append(6,"# Description: ")
    call append(7,"#=============================================================================*/")
    echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
endfunction
"更新最近修改时间和文件名
function UpdateTitle()
    normal m'
    execute '/# *Last modified:/s@:.*$@\=strftime(":\t%Y-%m-%d %H:%M")@'
    normal ''
    normal mk
    execute '/# *Filename:/s@:.*$@\=":\t\t".expand("%:t")@'
    execute "noh"
    normal 'k
    echohl WarningMsg | echo "Successful in updating the copy right." | echohl None
endfunction

"判断前10行代码里面，是否有Last modified这个单词，
"如果没有的话，代表没有添加过作者信息，需要新添加；
"如果有的话，那么只需要更新即可
function TitleDet()
    let n=1
"默认为添加
    while n < 10
    let line = getline(n)
    if line =~ '^\#\s*\S*Last\smodified:\S*.*$'
            call UpdateTitle()
            return
    endif
    let n = n + 1
    endwhile
    call AddTitle() 
endfunction
endif

"Run"
func! CompileGcc()
     exec "w"
     let compilecmd="!gcc "
     let compileflag="-o %< "
     if search("mpi\.h") != 0
            let compilecmd = "!mpicc "
     endif
     if search("glut\.h") != 0
            let compileflag .= " -lglut -lGLU -lGL "
     endif
     if search("cv\.h") != 0
            let compileflag .= " -lcv -lhighgui -lcvaux "
     endif
     if search("omp\.h") != 0
            let compileflag .= " -fopenmp "
     endif
     if search("math\.h") != 0
            let compileflag .= " -lm "
     endif
     exec compilecmd." % ".compileflag
endfunc
func! CompileGpp()
    exec "w"
    let compilecmd="!g++ "                                                                                                            let compileflag="-o %< "
    if search("mpi\.h") != 0                                                                                                                  let compilecmd = "!mpic++ "
    endif
    if search("glut\.h") != 0
            let compileflag .= " -lglut -lGLU -lGL "
    endif
    if search("cv\.h") != 0
            let compileflag .= " -lcv -lhighgui -lcvaux "
    endif
    if search("omp\.h") != 0                
            let compileflag .= " -fopenmp "
    endif
    if search("math\.h") != 0
            let compileflag .= " -lm "
    endif
    exec compilecmd." % ".compileflag
endfunc

func! RunPython()
    exec "!python %"                                                                                                        
endfunc                                                                                                                         

func! CompileJava()  
    exec "!javac %"
endfunc

func!  Runsh()
     exec "!sh %"
endfunc

func! CompileCode()
    exec "w"
    if &filetype == "cpp"
        exec "call CompileGpp()"
    elseif &filetype == "c"
        exec "call CompileGcc()"
    elseif &filetype == "python"
        exec "call RunPython()"
    elseif &filetype == "java"
        exec "call CompileJava()" 
    elseif &filetype == "sh"
        exec "call Runsh()"
    endif                                                                                                                       
endfunc                     
func! RunResult()
    exec "w"
    if search("mpi\.h") != 0
        exec "!mpirun -np 4 ./%<"
    elseif &filetype == "cpp"
        exec "! ./%<"
    elseif &filetype == "c"
        exec "! ./%<"
    elseif &filetype == "python"
        exec "call RunPython"
    elseif &filetype == "java"
        exec "!java %<"
    elseif &filetype == "sh"
        exec "call Runsh"
    endif                                                                                                                   
endfunc
map <F5> :call CompileCode()<CR>
imap <F5> <ESC>:call CompileCode()<CR>
vmap <F5> <ESC>:call CompileCode()<CR>
map <F6> :call RunResult()<CR>



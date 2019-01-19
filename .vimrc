set nocompatible
"source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin


set timeoutlen=1000 ttimeoutlen=10

let g:ConqueTerm_Interrupt = '<c-c>'
"nnoremap ,c :let @* = expand("%:p").":".line('.')<cr>
nnoremap mc :let @+ = expand("%:p").":".line('.')<cr>

"set tags+=/home/utylee/temp/azerothcore/src/tags,~/temp/azerothcore/modules/tags
"set tags+=/home/utylee/temp/TrinityCore/src/tags
set tags+=/home/utylee/temp/projectLegion/src/tags
"set tags+=/home/utylee/temp/SkyFire.548/src/tags

" cpp <---> h 간을 간편하게 바꿔주는 vim 커맨드
nnoremap <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
nnoremap <leader>h :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
"map <leader>0 :cd /home/utylee/temp/TrinityCore/build/src/server/worldserver<cr>  :GdbStart gdb -f worldserver <cr>
		"\ :e new <cr> 
		"\ :GdbStart gdb -f worldserver <cr>

map <leader>0 :cd /home/utylee/temp/projectLegion/build/src/server/worldserver<cr>  :GdbStart gdb -f worldserver <cr>


" 현재파일의 디렉토리로 변경 %->  상대경로파일명, :p-> 절대경로파일명, :h->
" 한마디전으로

nmap <leader>z :cd %:p:h<cr> :pwd<cr>

" 버퍼를 저장하지 않아도 버퍼간 이동을 가능하게끔합니다
set hidden

"인터렉티브한 쉘을 실행해서 ! ts 를 먹히게 해준다고 하는데 bashrc 를 실행하면
"너무 느려져서 삭제하고 아래와 같이 바꿉니다
"set shell=/bin/bash\ -i
"
" bashrc 의 alias를 읽기 위한 설정입니다
"let $BASH_ENV = "/home/utylee/.bashrc"

"!ts 가 -i 로 인터렉티브하게 안해도 실행되게끔 해줍니다
" 해당 파일안에는 현재 ts 함수만 설정되어 있습니다
let $BASH_ENV = "/home/utylee/.bash_functions"
let vim_markdown_preview_hotkey='<C-m>'

"set term=screen-256color
set backspace=indent,eol,start

let g:loaded_python_provider = 1

"osx 터미널 상에서의 인서트모드 커서를 변경합니다.
"let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"osx + tmux 상에서의 인서트모드 커서를 변경합니다.
"let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"


""""""""""""""""""
" 일반 ubuntu - linux 상에서의 커서설정
"

"에디트(이동)모드커서
let &t_EI .= "\<Esc>[1 q"
"수정(인서트)모드커서
let &t_SI .= "\<Esc>[5 q"

" solid block
" let &t_EI .= "\<Esc>[1 q"
  " 1 or 0 -> blinking block
  " 3 -> blinking underscore
  "	4 -> solid underscore
  " Recent versions of xterm (282 or above) also support
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar
  
"24bit true color 지원을 위해 추가했던 것 같습니다

let &t_8f="\e[38;2;%ld;%ld;%ldm"
let &t_8b="\e[48;2;%ld;%ld;%ldm"

"set guicolors  "vim 8.0에서 true color 적용문법 번경
set termguicolors
" backround column erase 문제 수정 문법
set t_ut=

"set t_Co=256
"set t_Co=16
"let g:solarized_termcolors=256
"let g:solarized_termcolors=16
"let g:solarized_termtrans=0


"set diffexpr=MyDiff()
"function MyDiff()
  "let opt = '-a --binary '
  "if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  "if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  "let arg1 = v:fname_in
  "if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  "let arg2 = v:fname_new
  "if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  "let arg3 = v:fname_out
  "if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  "let eq = ''
  "if $VIMRUNTIME =~ ' '
    "if &sh =~ '\<cmd'
      "let cmd = '""' . $VIMRUNTIME . '\diff"'
      "let eq = '"'
    "else
      "let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    "endif
  "else
    "let cmd = $VIMRUNTIME . '\diff'
  "endif
  "silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
"endfunction

"set runtimepath=~/.vim
"==================================================================
"set nocompatible
"filetype off
"set rtp+=~/vimfiles/bundle/vundle
"call vundle#rc('~/vimfiles/bundle')
"Plugin 'gmarik/vundle'
""Plugin 'The-NERD-tree'
"Plugin 'jistr/vim-nerdtree-tabs' "닫을때tree도같이닫아줌
"
"Plugin 'AutoComplPop' "단어자동완성
""Plugin 'SuperTab'
"Plugin 'SuperTab-continued.'
"Plugin 'a.vim' "헤더-소스 전환
"Plugin 'bufexplorer.zip' "파일의 History
""Plugin 'qtpy.vim'
"Plugin 'flazz/vim-colorschemes'
""Plugin 'Python-mode-klen'
""Plugin 'cqml.vim'
""Plugin 'number-marks'
""Plugin 'qt2vimsyntax'
"filetype plugin indent on
"syntax on
"
""autocmd VimEnter * if &filetype !=# 'gitcommit'| NERDTree | wincmd p | endif 
""autocmd BufEnter * if &filetype !=# 'gitcommit'| NERDTree | wincmd p | endif
"autocmd VimEnter * NERDTree
"autocmd BufEnter * NERDTreeMirror
"
"autocmd VimEnter * wincmd w
"
"let g:NERDTreeWinPos = "right"
"let g:NERDTreeWinSize = 36
"let g:nerdtree_tabs_open_on_gui_startup=1

"==================================================================

execute pathogen#infect()

filetype plugin indent on
syntax on

"let g:virtualenv_directory = '/home/utylee/00-Projects/venv-tyTrader'
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#virtualenv#enabled = 1
"let g:airline_section_a = airline#sections#create(['mode', %{airline#extensions#branch#get_head()}''branch'])

function! AirlineWrapper(ext)
	let head = airline#extensions#branch#head()
	return empty(head) ? '' : printf(' %s', airline#extensions#branch#get_head())
endfunction


let g:airline_section_a = airline#section#create(['mode', ' ', '%{airline#extensions#branch#get_head()}'])
"let g:airline_section_a = airline#section#create(['mode', '%{AirlineWrapper()}'])
"let g:airline_section_b = airline#section#create([g:airline_symbols.branch, ' ', '%{fugitive#head()}', ' ', ' %{virtualenv#statusline()}'])
"let g:airline_section_b = airline#section#create(['%{airline#extensions#branch#get_head()}', ' %{virtualenv#statusline()}'])
let g:airline_section_b = airline#section#create(['%{virtualenv#statusline()}'])
"let g:airline_section_b = airline#section#create(['branch'])
"let g:airline_section_b = ['branch']
"let g:virtualenv_stl_format = '[%n]'
"let g:Powerline_symbols = 'fancy'

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

"function! MyOverride(...)
"	call a:l.add_section('StatusLine', 'all')
"	return l
"endfunction
"call airline#add_statusline_func('MyOverride')

let g:jedi#auto_initialization = 0 
"let g:jedi#squelch_py_warning = 1
let g:jedi#force_py_version=3

" emmet-vim 을 html과 css에서만 사용하는 설정

let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

set noundofile
set number
set cul
set ignorecase
set shiftwidth=4
set softtabstop=4
set nobackup
set noswapfile
"no equalalways or equalalways --> split 화면에서 사이즈 유즈 관련 세팅
set noea 

" 현재 파일의 디렉토리로 이동
set autochdir
" 만약 플러긴에서 문제가 생긴다면 아래대안을 사용할 것
"nnoremap ,cd :cd %:p:h<CR> 

if has("gui_running")
	"set lines=55
"	set columns=120
"	au GUIEnter * winpos 300 0
"
	"set guioptions -=T
	"set guioptions -=m
	set fullscreen
endif

set noshellslash
"map <F5> : !python3 %<CR>
"nmap <leader>e :!python3 %<CR>
"nmap <leader>e :!python3 '%:p'<CR>
"nmap <leader>e :set shellcmdflag=-ic <CR> :!ts python '%'<CR> <CR> :set shellcmdflag=-c<CR>
"nmap <leader>e :!ts python '%:p' 2>/dev/null<CR> <CR>
nmap <leader>r :redraw!<CR>
nmap <leader>e :!ts python '%' 2>/dev/null<CR> <CR>
nmap <leader>c :!ts C-c<CR> <CR>
nmap <leader>w :!ts /mnt/c/Users/utylee/.virtualenvs/win/Scripts/python.exe c:/Users/utylee/.virtualenvs/win/src/'%' 2>/dev/null<CR> <CR>
"현재 행을 실행하는 커맨드인데 공백제거가 안돼 아직 제대로 되지 않습니다
"nmap <leader>w :exec '!ts python -c \"'getline('.')'\"'<CR>
nmap <leader>` :set fullscreen<CR>
nmap <leader>q :bd!<CR>
nmap <leader>a :bufdo bd<CR>
map <F7> :NERDTreeTabsToggle<CR>
map <F2> :NERDTreeToggle<CR>
"nmap <leader>2 :NERDTreeToggle<CR>
nmap <leader>2 :NERDTree<CR>
"nmap <leader>3 :NERDTreeClose<CR>
map <F1> :e $MYVIMRC<CR>
nmap <leader>1 :e $MYVIMRC<CR>
nmap <leader>5 :syntax sync fromstart<CR>
"nmap <leader>1 :e ~/todo<CR>
"nmap <leader>3 :r ~/.vim/mytemplate/main.txt<CR>
map <A-3> :tabnext<CR>
map <A-4> :tabprevious<CR>
"map <F3> :cn<CR>
"map <F4> :cp<CR>
"ex) :ccl<CR>       "Close the search result windows

map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-h> <c-w>h
map <c-l> <c-w>l
"map <C-T> :tabnew<CR>:wincmd w<CR>

" Setup some default ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg|avi|mkv|mov|mp4|wma|xlsx|mp3|ini|doc|docx|un|bak)$',
\}


"arduino setup

let g:arduino_serial_baud = 9600
let g:arduino_serial_port = "/dev/ttyS8"

nmap <leader>v :ArduinoVerify<CR>
nmap <leader>u :ArduinoUpload<CR>
nmap <leader>3 :ArduinoSerial<CR>


" Use the nearest .git directory as the cwd
" This makes a lot of sense if you are working on a project that is in version
" control. It also supports works with .svn, .hg, .bzr.
"let g:ctrlp_working_path_mode = 'r'

" Use a leader instead of the actual named binding
"nmap <leader>f :CtrlP<cr>
nmap <leader>f :CtrlPCurWD<cr>

" Easy bindings for its various modes
nmap <leader>b :CtrlPBuffer<cr>
nmap <leader>t :CtrlPMRU<cr>
nmap <leader>m :CtrlPMixed<cr>
"nmap <leader>bs :CtrlPMRU<cr>
let g:ctrlp_match_window = 'max:20'

" Split size change
nmap <leader>- :resize -5<cr>
nmap <leader>= :resize +5<cr>

"d로 삭제시에 레지스터로 복사되는 것을 금지합니다
"noremap d "_d
"noremap dd "_dd
"noremap p "0p

"colorscheme molokai "oreilly jellybeans sweyla1 
"colorscheme oreilly "oreilly jellybeans sweyla1 
"colorscheme monokai "oreilly jellybeans sweyla1 
"set background=dark
"colorscheme solarized 
colorscheme solarized_sd_utylee

"let python_no_builtin_highlight = 1  
"let g:molokai_original = 1

"set air-line heme {dark, molokai, ...}
"let g:airline_theme='molokai'
"let g:airline_theme='solarized'
"et g:airline_theme='dark'
"let g:airline_theme='tomorrow'
"let g:airline_theme='zenburn'

" 일단 요 두개가 맘에 듬
"let g:airline_theme='wombat'
"let g:airline_theme='raven'
let g:airline_theme='base16_embers'

"let g:airline_theme='jellybeans'


let g:jedi#completions_command = "<C-N>"



"autocmd BufNewFile,BufRead *.qml so c:\vim\vim74\ftplugin\qml.vim
autocmd BufNewFile,BufRead *.qml setf qml 

if has("autocmd")
	augroup templates
		autocmd BufNewFile *.json 0r ~/.vim/template/skeleton.json
	augroup end
endif



"filetype plugin on
"set omnifunc=syntaxcomplete#Complete
"set complete


let g:vebugger_leader=','
"let g:vebugger_view_source_cmd='edit'
"let g:ConqueGdb_Leader = ','

"let g:ycm_confirm_extra_conf = 0
"let g:ycm_key_list_select_completion = ['', '']
"let g:ycm_key_list_previous_completion = ['', '']
"let g:ycm_autoclose_preview_window_after_completion = 1
"let g:ycm_warning_symbol = '>*'
"
"nnoremap g :YcmCompleter GoTo
"" nnoremap gg :YcmCompleter GoToImprecise
"nnoremap d :YcmCompleter GoToDeclaration
"nnoremap t :YcmCompleter GetType
"nnoremap p :YcmCompleter GetParent 
"let g:ycm_min_num_of_chars_for_completion = 1
"let g:ycm_auto_trigger = 1 
"let g:ycm_collect_identifiers_from_tags_files = 1



""For clang_complete
"let g:clang_snippets = 1
"let g:clang_snippets_engine = 'clang_complete'
""let g:clang_library_path='/usr/lib/llvm-3.8/lib'
""let g:clang_library_path='/usr/lib/x86_64-linux-gnu/libclang-3.8.so.1'
"let g:clang_library_path='/usr/lib/llvm-3.8/lib/libclang-3.8.so.1'






" For clang
" disable auto completion for vim-clang
"let g:clang_auto = 0
"" default 'longest' can not work with neocomplete
"let g:clang_c_completeopt = 'menuone,preview'
"let g:clang_cpp_completeopt = 'menuone,preview'
"
""nvim이 아닐 때만 neocomplete 변수를 넣습니다
"if !has('nvim')
"
" use neocomplete
" input patterns
"if !exists('g:neocomplete#force_omni_input_patterns')
	"let g:neocomplete#force_omni_input_patterns = {}
"endif

"for c and c++
"let g:neocomplete#force_omni_input_patterns.c =
   "\ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
"let g:neocomplete#force_omni_input_patterns.cpp =
	"\ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'


"let g:clang_c_options = '-std=gnu11'
"let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'
"endif



"nvim이 아닐때만 neocomplete init을 행합니다
"if !has('nvim')
" For Neocomplete config

" Use neocomplete.
"let g:neocomplete#enable_at_startup = 1
" Use smartcase.
"let g:neocomplete#enable_smart_case = 1
" Use complte first result like AutoComplPop 
"let g:neocomplete#enable_auto_select = 1
" Set minimum syntax keyword length.
"let g:neocomplete#sources#syntax#min_keyword_length = 3

" Define dictionary.
"let g:neocomplete#sources#dictionary#dictionaries = {
    "\ 'default' : '',
    "\ 'vimshell' : $HOME.'/.vimshell_hist',
    "\ 'scheme' : $HOME.'/.gosh_completions'
        "\ }

" Define keyword.
"if !exists('g:neocomplete#keyword_patterns')
    "let g:neocomplete#keyword_patterns = {}
"endif
"let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
"inoremap <expr><C-g>     neocomplete#undo_completion()
"inoremap <expr><C-l>     neocomplete#complete_common_string()
"inoremap <expr><Space>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function()
  ""return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  "" For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
"endfunction
" <TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
""" <C-h>, <BS>: close popup and delete backword char.
"inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
"inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
"" Close popup by <Space>.
""inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"
"
" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
"autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
"if !exists('g:neocomplete#sources#omni#input_patterns')
  "let g:neocomplete#sources#omni#input_patterns = {}
"endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
"let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
"endif





set langmenu=utf8
"lang mes en_US 
"set langmenu=en_US.UTF-8
set tabstop=4
"cd c:\_GoogleDrive\__시스템트레이딩\
set encoding=utf8
"set fileencodings=utf-8,cp949
set fileencodings=utf-8,cp949
"set langmenu=cp949
"set guifont=나눔고딕코딩:h12:cHANGEUL
"set guifontwide=나눔고딕코딩:h12:cHANGEUL
"set guifont=Lucida\ Console:h11:cDEFAULT
"set guifont=Consolas:h10.15:cDEFAULT
"set guifont=Consolas:h10.2:cANSI
"set guifont=Ubuntu\ Mono\ for\ Powerline:h15:cANSI
"set guifont=Ubuntu\ Mono:h15:cANSI
"set guifont=Ubuntu\ Mono\ derivative\ Powerline:h18.3
"set guifontwide=NanumGothicCoding:h23
set guifont=Ubuntu\ Mono\ derivative\ Powerline:h19
"set guifont=D2Coding\ for\ Powerline
"set font=Ubuntu\ Mono\ derivative\ Powerline:h19
set guifontwide=NanumGothicCoding:h24
"set guifontwide=NanumGothicCoding:h15:cDEFAULT
"set guifontwide=Ubuntu:h15:cDEFAULT

"cd c:\_GoogleDrive\
"cd c:\Users\utylee\00-projects
"cd c:\Users\seoru\00-projects\00-python
"
"

"fu! Sess()
	"execute 'source Session.vim'
"endfunction
"autocmd VimEnter * call Sess()

"nmap <leader>a :source Session.vim<cr>


if has('nvim')
	set rtp-=~/.vim/bundle/neocomplete.vim
endif


